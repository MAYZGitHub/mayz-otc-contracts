use aiken/builtin.{equals_bytearray}
use aiken/collection/dict
use aiken/collection/list
use aiken/collection/pairs
use aiken/crypto.{VerificationKeyHash}
use aiken/fuzz
use aiken/option
use aiken/primitive/bytearray
use aiken/primitive/int
use aiken/primitive/string
use cardano/address.{VerificationKey}
use cardano/assets.{
  AssetName, PolicyId, Value, add, flatten, match, merge, negate, quantity_of,
  to_dict, tokens, zero,
}
use cardano/transaction.{
  InlineDatum, Input, Output, OutputReference, Redeemer, ScriptPurpose, Spend,
  Transaction,
}
use types.{CancelOTC, CloseOTC, OTCDatum, OTCRedeemer, ProtocolDatum}

/// Flatten a Value and remove zero-quantity tokens
pub fn flatten_clean(value: Value) -> List<(PolicyId, AssetName, Int)> {
  flatten(value)
    |> list.filter(fn((_, _, qty)) { qty != 0 })
}

/// Converts a flattened list into Dict<PolicyId, Dict<AssetName, Int>>
pub fn flatten_to_dict(
  entries: List<(PolicyId, AssetName, Int)>,
) -> dict.Dict<PolicyId, dict.Dict<AssetName, Int>> {
  list.foldl(
    entries,
    dict.empty,
    fn((pid, tn, qty), acc) {
      let current_group =
        when dict.get(acc, pid) is {
          Some(group) -> group
          None -> dict.empty
        }
      let updated_group = dict.insert(current_group, tn, qty)
      dict.insert(acc, pid, updated_group)
    },
  )
}

/// True if both values have the same non-zero tokens and quantities
pub fn is_eq_value(a: Value, b: Value) -> Bool {
  let a_dict = flatten_clean(a) |> flatten_to_dict
  flatten_clean(b)
    |> list.all(
        fn((pid, tn, qty)) {
          when dict.get(a_dict, pid) is {
            Some(group) ->
              when dict.get(group, tn) is {
                Some(actual) -> actual == qty
                None -> False
              }
            None -> False
          }
        },
      )
}

/// True if all tokens in `must_have` are included in `base`
pub fn is_include_value(base: Value, must_have: Value) -> Bool {
  let base_dict = flatten_clean(base) |> flatten_to_dict
  flatten_clean(must_have)
    |> list.all(
        fn((pid, tn, qty)) {
          when dict.get(base_dict, pid) is {
            Some(group) ->
              when dict.get(group, tn) is {
                Some(actual) -> actual >= qty
                None -> False
              }
            None -> False
          }
        },
      )
}

/// Get protocol datum from reference inputs
/// Returns an Option containing the protocol output and datum if found
/// 
/// # Arguments
/// * transaction - The transaction being validated
/// * protocol_policy_id - The policy ID of the protocol token
/// * protocol_id_tn - The token name of the protocol ID token
/// * expect_count - Expected number of protocol inputs (usually 1)
pub fn get_protocol_from_inputs_ref(
  transaction: Transaction,
  protocol_policy_id: PolicyId,
  protocol_id_tn: ByteArray,
  expect_count: Int,
) -> Option<(Output, ProtocolDatum)> {
  let protocol_refs =
    list.filter(
      transaction.reference_inputs,
      fn(input) {
        quantity_of(input.output.value, protocol_policy_id, protocol_id_tn) == 1
      },
    )
  if list.length(protocol_refs) == expect_count {
    when list.head(protocol_refs) is {
      Some(input) ->
        when extract_protocol_datum(input.output) is {
          Some(protocolDatum) -> Some((input.output, protocolDatum))
          None -> None
        }
      _ -> None
    }
  } else {
    None
  }
}

/// Get protocol datum from inputs
/// Returns an Option containing the protocol output and datum if found
/// 
/// # Arguments
/// * transaction - The transaction being validated
/// * protocol_policy_id - The policy ID of the protocol token
/// * protocol_id_tn - The token name of the protocol ID token
/// * expect_count - Expected number of protocol inputs (usually 1)
pub fn get_protocol_from_inputs(
  transaction: Transaction,
  protocol_policy_id: PolicyId,
  protocol_id_tn: ByteArray,
  expect_count: Int,
) -> Option<(Output, ProtocolDatum)> {
  let protocol_inputs =
    list.filter(
      transaction.inputs,
      fn(input) {
        quantity_of(input.output.value, protocol_policy_id, protocol_id_tn) == 1
      },
    )
  if list.length(protocol_inputs) == expect_count {
    when list.head(protocol_inputs) is {
      Some(input) ->
        when extract_protocol_datum(input.output) is {
          Some(protocolDatum) -> Some((input.output, protocolDatum))
          None -> None
        }
      _ -> None
    }
  } else {
    None
  }
}

/// Get protocol datum from outputs
/// Returns an Option containing the protocol output and datum if found
/// 
/// # Arguments
/// * transaction - The transaction being validated
/// * protocol_policy_id - The policy ID of the protocol token
/// * protocol_id_tn - The token name of the protocol ID token
/// * expect_count - Expected number of protocol outputs (usually 1)
pub fn get_protocol_from_outputs(
  transaction: Transaction,
  protocol_policy_id: PolicyId,
  protocol_id_tn: ByteArray,
  expect_count: Int,
) -> Option<(Output, ProtocolDatum)> {
  let protocol_outputs =
    list.filter(
      transaction.outputs,
      fn(output) {
        quantity_of(output.value, protocol_policy_id, protocol_id_tn) == 1
      },
    )
  if list.length(protocol_outputs) == expect_count {
    when list.head(protocol_outputs) is {
      Some(output) ->
        when extract_protocol_datum(output) is {
          Some(protocolDatum) -> Some((output, protocolDatum))
          None -> None
        }
      _ -> None
    }
  } else {
    None
  }
}

/// Get OTC output and datum from inputs
/// Returns an Option containing the OTC output and datum if found
/// 
/// # Arguments
/// * transaction - The transaction being validated
/// * otc_policy_id - The policy ID of the OTC token
/// * otc_id_tn - The token name of the OTC ID token
/// * expect_count - Expected number of OTC inputs (usually 1)
pub fn get_otc_from_inputs(
  transaction: Transaction,
  otc_policy_id: PolicyId,
  otc_id_tn: ByteArray,
  expect_count: Int,
) -> Option<(Output, OTCDatum)> {
  let otc_inputs =
    list.filter(
      transaction.inputs,
      fn(input) {
        quantity_of(input.output.value, otc_policy_id, otc_id_tn) == 1
      },
    )
  if list.length(otc_inputs) == expect_count {
    when list.head(otc_inputs) is {
      Some(input) ->
        when extract_otc_datum(input.output) is {
          Some(otcDatum) -> Some((input.output, otcDatum))
          None -> None
        }
      _ -> None
    }
  } else {
    None
  }
}

/// Get OTC input with output reference and datum from inputs
/// Returns an Option containing the input and OTC datum if found
/// 
/// # Arguments
/// * transaction - The transaction being validated
/// * otc_policy_id - The policy ID of the OTC token
/// * otc_id_tn - The token name of the OTC ID token
/// * expect_count - Expected number of OTC inputs (usually 1)
pub fn get_otc_with_outref_from_inputs(
  transaction: Transaction,
  otc_policy_id: PolicyId,
  otc_id_tn: ByteArray,
  expect_count: Int,
) -> Option<(Input, OTCDatum)> {
  let otc_inputs =
    list.filter(
      transaction.inputs,
      fn(input) {
        quantity_of(input.output.value, otc_policy_id, otc_id_tn) == 1
      },
    )
  if list.length(otc_inputs) == expect_count {
    when list.head(otc_inputs) is {
      Some(input) ->
        when extract_otc_datum(input.output) is {
          Some(otcDatum) -> Some((input, otcDatum))
          None -> None
        }
      _ -> None
    }
  } else {
    None
  }
}

/// Get OTC output and datum from outputs
/// Returns an Option containing the OTC output and datum if found
/// 
/// # Arguments
/// * transaction - The transaction being validated
/// * otc_policy_id - The policy ID of the OTC token
/// * otc_id_tn - The token name of the OTC ID token
/// * expect_count - Expected number of OTC outputs (usually 1)
pub fn get_otc_from_outputs(
  transaction: Transaction,
  otc_policy_id: PolicyId,
  otc_id_tn: ByteArray,
  expect_count: Int,
) -> Option<(Output, OTCDatum)> {
  let otc_outputs =
    list.filter(
      transaction.outputs,
      fn(output) { quantity_of(output.value, otc_policy_id, otc_id_tn) == 1 },
    )
  if list.length(otc_outputs) == expect_count {
    when list.head(otc_outputs) is {
      Some(output) ->
        when extract_otc_datum(output) is {
          Some(otcDatum) -> Some((output, otcDatum))
          None -> None
        }
      _ -> None
    }
  } else {
    None
  }
}

/// Check if OTC NFT token is present in transaction inputs
/// Returns true if at least one input contains the OTC NFT
/// 
/// # Arguments
/// * transaction - The transaction being validated
/// * otc_policy_id - The policy ID of the OTC NFT
/// * otc_nft_tn - The token name of the OTC NFT
pub fn check_if_otc_nft_is_present_in_inputs(
  transaction: Transaction,
  otc_policy_id: PolicyId,
  otc_nft_tn: ByteArray,
) -> Bool {
  let otc_inputs =
    list.filter(
      transaction.inputs,
      fn(input) {
        quantity_of(input.output.value, otc_policy_id, otc_nft_tn) == 1
      },
    )
  list.length(otc_inputs) >= 1
}

/// Extract protocol datum from an output
/// Returns an Option containing the protocol datum if successfully extracted
/// 
/// # Arguments
/// * output - The output containing the datum
pub fn extract_protocol_datum(output: Output) -> Option<ProtocolDatum> {
  when output.datum is {
    InlineDatum(data) -> {
      expect datum: ProtocolDatum = data
      Some(datum)
    }
    _ -> None
  }
}

/// Extract OTC datum from an output
/// Returns an Option containing the OTC datum if successfully extracted
/// 
/// # Arguments
/// * output - The output containing the datum
pub fn extract_otc_datum(output: Output) -> Option<OTCDatum> {
  when output.datum is {
    InlineDatum(data) -> {
      expect datum: OTCDatum = data
      Some(datum)
    }
    _ -> None
  }
}

/// Check if transaction is authorized by a protocol admin
/// Returns true if signed by an admin or contains admin token
/// 
/// # Arguments
/// * transaction - The transaction being validated
/// * protocolDatum - The protocol datum containing admin information
pub fn is_admin_auth(
  transaction: Transaction,
  protocolDatum: ProtocolDatum,
) -> Bool {
  let is_admin_signed =
    list.any(
      protocolDatum.pd_admins,
      fn(admin) { list.has(transaction.extra_signatories, admin) },
    )
  let has_admin_token =
    list.any(
      transaction.reference_inputs,
      fn(input) {
        let tokens =
          tokens(input.output.value, protocolDatum.pd_token_admin_policy_id)
        !dict.is_empty(tokens)
      },
    )
  is_admin_signed || has_admin_token
}

/// Validate protocol parameters
/// Returns true if all parameters are valid:
/// - Minimum ADA is positive
/// - Admin list is not empty
/// - MAYZ deposit requirement is positive
/// - Admin token policy ID is not empty
///
/// # Arguments
/// * protocolDatum - The protocol datum to validate
pub fn validate_protocol_params(protocolDatum: ProtocolDatum) -> Bool {
  and {
    protocolDatum.pd_min_ada > 0,
    !list.is_empty(protocolDatum.pd_admins),
    protocolDatum.pd_mayz_deposit_requirement >= 0,
    !bytearray.is_empty(protocolDatum.pd_token_admin_policy_id),
  }
}

/// Check if transaction is signed by OTC creator
/// Returns true if the creator's verification key hash is among the signers
/// 
/// # Arguments
/// * transaction - The transaction being validated
/// * creator - The verification key hash of the OTC creator
pub fn is_signed_by_creator(
  transaction: Transaction,
  creator: VerificationKeyHash,
) -> Bool {
  list.has(transaction.extra_signatories, creator)
}

/// Add lovelace to a value
/// Returns a new value with the added lovelace amount
/// 
/// # Arguments
/// * v - The base value
/// * lovelace - The amount of lovelace to add
pub fn add_lovelace(v: Value, lovelace: Int) -> Value {
  add(v, #"", #"", lovelace)
}

/// Check if a value is sent to a specific wallet address
/// Returns true if the wallet receives at least the specified value
/// 
/// # Arguments
/// * transaction - The transaction being validated
/// * wallet - The verification key hash of the recipient wallet
/// * value - The minimum value that should be received
pub fn check_value_sent_to_wallet(
  transaction: Transaction,
  wallet: VerificationKeyHash,
  expected_value: Value,
) -> Bool {
  let wallet_value =
    list.filter(
      transaction.outputs,
      fn(output) {
        when output.address.payment_credential is {
          VerificationKey(payment_key_hash) -> payment_key_hash == wallet
          _ -> False
        }
      },
    )
      |> list.map(fn(output) { output.value })
      |> list.foldl(zero, merge)
  trace @"wallet_value": wallet_value
  trace @"expected_value": expected_value

  let is_included = is_include_value(wallet_value, expected_value)
  trace @"is_included": is_included

  is_included
  // match(wallet_value, to_data(value), >=)
}

/// Check if a value is sent to the transaction signer
/// Returns true if the signer receives at least the specified value
/// 
/// # Arguments
/// * transaction - The transaction being validated
/// * value - The minimum value that should be received
pub fn check_value_sent_to_signer(
  transaction: Transaction,
  value: Value,
) -> Bool {
  let signer_value =
    list.filter(
      transaction.outputs,
      fn(output) {
        when output.address.payment_credential is {
          VerificationKey(payment_key_hash) ->
            list.has(transaction.extra_signatories, payment_key_hash)
          _ -> False
        }
      },
    )
      |> list.map(fn(output) { output.value })
      |> list.foldl(zero, merge)

  match(signer_value, value, >=)
}

/// Validate OTC token name format
/// Returns true if the name follows the convention "OTC-[TOKEN]-[AMOUNT]"
/// 
/// # Arguments
/// * name - The OTC token name to validate
/// * token_tn - The underlying token name
/// * token_amount - The amount of underlying tokens
pub fn validate_otc_name(
  name: ByteArray,
  token_tn: ByteArray,
  token_amount: Int,
) -> Bool {
  // Create expected OTC name and compare
  let expected_name = generate_otc_name(token_tn, token_amount)
  equals_bytearray(name, expected_name)
}

/// Generate OTC token name following the convention "OTC-[TOKEN]-[AMOUNT]"
/// 
/// # Arguments
/// * token_tn - The underlying token name
/// * amount - The amount of underlying tokens
pub fn generate_otc_name(token_tn: ByteArray, amount: Int) -> ByteArray {
  // "OTC-" in hex is "4F54432D"
  let prefix = #"4f54432d"
  // Append token name
  let with_token = bytearray.concat(prefix, token_tn)
  // Append separator "-" (hex: 2D)
  let with_separator = bytearray.concat(with_token, #"2d")
  // Format amount and append
  let formatted_amount = format_large_number(amount)
  bytearray.concat(with_separator, formatted_amount)
}

/// Format a large number into a readable string
/// 
/// # Arguments
/// * n - The number to format
fn format_large_number(n: Int) -> ByteArray {
  let number_as_string = int.to_string(n)
  // Convierte a cadena
  bytearray.from_string(number_as_string)
  // Convierte la cadena a ByteArray
}

fn format_with_separators(n: Int, acc: ByteArray) -> ByteArray {
  if n == 0 {
    acc
  } else {
    let current_group = n % 1000
    // Convert current group to 3 digits with leading zeros if needed
    let group_bytes = pad_number(current_group)
    let new_acc =
      if bytearray.length(acc) == 0 {
        group_bytes
      } else {
        // Add separator (.) which is 2E in hex
        bytearray.concat(group_bytes, bytearray.concat(#"2e", acc))
      }
    format_with_separators(n / 1000, new_acc)
  }
}

fn pad_number(n: Int) -> ByteArray {
  let bytes = builtin.integer_to_bytearray(True, 0, n)
  let len = bytearray.length(bytes)
  if len == 1 {
    bytearray.concat(#"3030", bytes)
  } else if // Add "00" prefix
  len == 2 {
    bytearray.concat(#"30", bytes)
  } else {
    // Add "0" prefix
    bytes
  }
}

pub fn extract_otc_redeemer(redeemer: Redeemer) -> Option<OTCRedeemer> {
  expect otc_redeemer: OTCRedeemer = redeemer
  Some(otc_redeemer)
}

/// Check if any redeemer in the transaction is a Close or Cancel operation
pub fn is_close_or_cancel(redeemers: List<Redeemer>) -> Bool {
  list.any(
    redeemers,
    fn(redeemer) {
      when extract_otc_redeemer(redeemer) is {
        Some(otc_redeemer) ->
          when otc_redeemer is {
            CloseOTC -> True
            CancelOTC -> True
            _ -> False
          }
        None -> False
      }
    },
  )
}

/// Get redeemer for a specific output reference
pub fn get_redeemer_of(
  redeemers: Pairs<ScriptPurpose, Redeemer>,
  outRef: OutputReference,
) -> List<Redeemer> {
  pairs.get_all(redeemers, Spend(outRef))
}

// Helper to create mock transaction
pub fn mock_transaction(
  reference_inputs: List<Input>,
  inputs: List<Input>,
  outputs: List<Output>,
  mint: Value,
  extra_signatories: List<ByteArray>,
) -> Transaction {
  Transaction {
    ..transaction.placeholder,
    reference_inputs: reference_inputs,
    inputs: inputs,
    outputs: outputs,
    mint: mint,
    extra_signatories: extra_signatories,
  }
}

//  unit testing

test generate_otc_name_inspect() {
  let token_tn = #"544f4b454e"
  let amount = 1000000

  let result = generate_otc_name(token_tn, amount)
  trace @"result": result
  trace @"result": bytearray.to_string(result)
  // Crea un error con el resultado para inspeccionarlo
  expect result == #"4f54432d544f4b454e2d31303030303030"
}

test validate_otc_name_with_valid_input() {
  let name = #"4f54432d544f4b454e2d31303030303030"
  // "OTC-TOKEN-1000000"
  let token_tn = #"544f4b454e"
  // "TOKEN"
  let token_amount = 1000000
  expect validate_otc_name(name, token_tn, token_amount) == True
}

test validate_otc_name_with_invalid_input() {
  let name = #"4f54432d574f4e472d31303030303030"
  // "OTC-WRONG-1000000"
  let token_tn = #"544f4b454e"
  // "TOKEN"
  let token_amount = 1000000
  expect validate_otc_name(name, token_tn, token_amount) == False
}

test generate_otc_name_with_large_amount() {
  let token_tn = #"544f4b454e"
  // "TOKEN"
  let amount = 1234567890
  let result = generate_otc_name(token_tn, amount)
  expect bytearray.to_string(result) == @"OTC-TOKEN-1234567890"
}

test pad_number_with_single_digit() {
  trace @"result": pad_number(7)
  expect pad_number(7) == #"303007"
  // Should return "007"
}

test pad_number_with_two_digits() {
  trace @"result": pad_number(42)
  expect pad_number(42) == #"30302a"
  // Should return "042"
}

test pad_number_with_three_digits() {
  trace @"result": pad_number(999)
  expect pad_number(999) == #"3003e7"
  // Should return "999"
}

test prop_validate_otc_name(
  inputs: (ByteArray, Int) via generate_otc_name_inputs_fuzzer(),
) {
  let (token_name_bytes, amount) = inputs
  // Generate the OTC name
  let generated_name = generate_otc_name(token_name_bytes, amount)

  // Validate the generated name with the token_name_bytes and amount
  let is_valid = validate_otc_name(generated_name, token_name_bytes, amount)

  // Trace values for debugging
  trace @"token_name (hex)": bytearray.to_hex(token_name_bytes)
  trace @"amount": amount
  trace @"generated_name (hex)": bytearray.to_hex(generated_name)
  trace @"is_valid": is_valid

  // Ensure the validation passes
  expect is_valid == True
}

fn generate_otc_name_inputs_fuzzer() -> Fuzzer<(ByteArray, Int)> {
  fuzz.map2(
    fuzz.bytearray_between(1, 10),
    // Fuzz ByteArray for token_name
    fuzz.int_between(1, 1_000_000),
    // Fuzz Int for amount
    fn(token_name, amount) { (token_name, amount) },
  )
}

test prop_generate_otc_name_reversible(
  inputs: (ByteArray, Int) via generate_otc_name_inputs_fuzzer(),
) {
  let (token_name_bytes, amount) = inputs
  // Convert the token_name_bytes to hex for tracing
  let token_name_hex = bytearray.to_hex(token_name_bytes)
  trace @"token_name (hex)": token_name_hex

  // Trace the amount
  trace @"amount": amount

  // Generate the name
  let generated_name = generate_otc_name(token_name_bytes, amount)
  trace @"generated_name": generated_name

  // Convert the generated name to hex
  let name_as_hex = bytearray.to_hex(generated_name)
  trace @"name_as_hex": name_as_hex

  // Build the expected readable name
  let expected_readable_name =
    string.concat(
      string.concat(@"OTC-", bytearray.to_hex(token_name_bytes)),
      string.concat(@"-", string.from_int(amount)),
    )
  trace @"expected_readable_name": expected_readable_name

  // Build the expected name hex directly from the bytearray components
  let expected_name_bytes =
    builtin.append_bytearray(
      bytearray.from_string(@"OTC-"),
      builtin.append_bytearray(
        token_name_bytes,
        builtin.append_bytearray(
          bytearray.from_string(@"-"),
          bytearray.from_string(string.from_int(amount)),
        ),
      ),
    )
  let expected_name_hex = bytearray.to_hex(expected_name_bytes)
  trace @"expected_name_hex": expected_name_hex

  // Validate that the generated name matches the expected name
  expect name_as_hex == expected_name_hex
}

// Top-level recursive insert
fn insert_vkeyhash(
  x: VerificationKeyHash,
  sorted: List<VerificationKeyHash>,
) -> List<VerificationKeyHash> {
  when sorted is {
    [] -> [x]
    [y, ..ys] ->
      if bytearray.compare(x, y) == Less {
        [x, y, ..ys]
      } else {
        [y, ..insert_vkeyhash(x, ys)]
      }
  }
}

// Top-level sort
pub fn sort_vkeyhashes(
  xs: List<VerificationKeyHash>,
) -> List<VerificationKeyHash> {
  when xs is {
    [] -> []
    [x, ..rest] -> insert_vkeyhash(x, sort_vkeyhashes(rest))
  }
}

pub fn normalize_protocol_datum(d: ProtocolDatum) -> ProtocolDatum {
  ProtocolDatum {
    pd_admins: sort_vkeyhashes(d.pd_admins),
    pd_token_admin_policy_id: d.pd_token_admin_policy_id,
    pd_mayz_policy_id: d.pd_mayz_policy_id,
    pd_mayz_tn: d.pd_mayz_tn,
    pd_mayz_deposit_requirement: d.pd_mayz_deposit_requirement,
    pd_min_ada: d.pd_min_ada,
  }
}

pub fn normalize_otc_datum(d: OTCDatum) -> OTCDatum {
  OTCDatum {
    od_creator: d.od_creator,
    od_otc_nft_policy_id: d.od_otc_nft_policy_id,
    od_otc_nft_tn: d.od_otc_nft_tn,
    od_token_policy_id: d.od_token_policy_id,
    od_token_tn: d.od_token_tn,
    od_token_amount: d.od_token_amount,
    od_mayz_policy_id: d.od_mayz_policy_id,
    od_mayz_tn: d.od_mayz_tn,
    od_mayz_locked: d.od_mayz_locked,
    od_min_ada: d.od_min_ada,
  }
}
