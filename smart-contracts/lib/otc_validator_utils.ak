use aiken/collection/list
use aiken/crypto.{ScriptHash}
use cardano/address.{from_script}
use cardano/assets.{PolicyId, add, from_asset_list, merge, quantity_of, zero}
use cardano/transaction.{Transaction}
use types.{OTCDatum, OTCParams}
use utils.{
  add_lovelace, check_if_otc_nft_is_present_in_inputs,
  check_value_sent_to_signer, check_value_sent_to_wallet, get_otc_from_inputs,
  get_otc_from_outputs, get_otc_with_outref_from_inputs, get_redeemer_of,
  is_close_or_cancel, is_signed_by_creator, normalize_otc_datum,
}

/// Initialize OTC position by minting OTC ID token. Runs along MintNFT redeemer
pub fn validate_mintID(
  params: OTCParams,
  otc_policy_id: PolicyId,
  transaction: Transaction,
) -> Bool {
  let otc_validator_hash = otc_policy_id

  // No existing OTC input should exist for creation
  expect None =
    get_otc_with_outref_from_inputs(
      transaction,
      otc_policy_id,
      params.pp_otc_id_tn,
      0,
    )

  // Get the OTC output being created to validate token details
  expect Some((otc_Out, otcDatum_Out)) =
    get_otc_from_outputs(transaction, otc_policy_id, params.pp_otc_id_tn, 1)

  // Create the expected script address
  let expected_address = from_script(otc_validator_hash)

  // Control Value for creator output with OTC NFT token
  let creator_Value_Control =
    [
      Pair(
        otcDatum_Out.od_otc_nft_policy_id,
        [Pair(otcDatum_Out.od_otc_nft_tn, 1)],
      ),
    ]
      |> from_asset_list()

  let otc_values =
    [
      from_asset_list([Pair(otc_policy_id, [Pair(params.pp_otc_id_tn, 1)])]),
      from_asset_list(
        [
          Pair(
            otcDatum_Out.od_token_policy_id,
            [Pair(otcDatum_Out.od_token_tn, otcDatum_Out.od_token_amount)],
          ),
        ],
      ),
      from_asset_list(
        [
          Pair(
            otcDatum_Out.od_mayz_policy_id,
            [Pair(otcDatum_Out.od_mayz_tn, otcDatum_Out.od_mayz_locked)],
          ),
        ],
      ),
    ]

  let otc_Out_Value_Control =
    list.foldl(otc_values, zero, merge)
      |> add_lovelace(otcDatum_Out.od_min_ada)

  // Authorization check
  let is_authorized = is_signed_by_creator(transaction, otcDatum_Out.od_creator)
  trace @"E1": is_authorized

  // Both OTC ID and NFT must be minted. With this we ensure that the OTC NFT Policy runs alongside the OTC Validator and ID Policy
  let id_token_minted =
    quantity_of(transaction.mint, otc_policy_id, params.pp_otc_id_tn) == 1
  trace @"E2": id_token_minted

  let nft_token_minted =
    quantity_of(
      transaction.mint,
      otcDatum_Out.od_otc_nft_policy_id,
      otcDatum_Out.od_otc_nft_tn,
    ) == 1
  trace @"E3": nft_token_minted

  // Verify that the created UTXO goes to the expected address
  let address_correct = otc_Out.address == expected_address
  trace @"E4": address_correct

  // Value validations
  let value_to_creator_correct =
    check_value_sent_to_wallet(
      transaction,
      otcDatum_Out.od_creator,
      creator_Value_Control,
    )
  trace @"E5A": creator_Value_Control
  trace @"E5": value_to_creator_correct

  let value_correct = otc_Out.value == otc_Out_Value_Control
  trace @"E6": value_correct

  and {
    is_authorized,
    id_token_minted,
    nft_token_minted,
    address_correct,
    value_to_creator_correct,
    value_correct,
  }
}

/// Burn OTC NFT token during CloseOTC or CancelOTC operations
pub fn validate_burnID(
  params: OTCParams,
  otc_policy_id: PolicyId,
  transaction: Transaction,
) -> Bool {
  // Get input OTC UTXO 
  expect Some((otc_In_With_OutRef, otcDatum_In)) =
    get_otc_with_outref_from_inputs(
      transaction,
      otc_policy_id,
      params.pp_otc_id_tn,
      1,
    )

  let otc_In_OutRef = otc_In_With_OutRef.output_reference

  // Does not need more validations as the consume of the OTC UTXO will trigger the NFT Validator if I ensure the correct spend reddemer there
  let redeemer_otc = get_redeemer_of(transaction.redeemers, otc_In_OutRef)
  let isCorrectRedeemer = is_close_or_cancel(redeemer_otc)
  and {
    // Valid if the correct redeemer is used
    isCorrectRedeemer,
    // Burn validations
    quantity_of(transaction.mint, otc_policy_id, params.pp_otc_id_tn) == -1,
    quantity_of(
      transaction.mint,
      otcDatum_In.od_otc_nft_policy_id,
      otcDatum_In.od_otc_nft_tn,
    ) == -1,
  }
}

pub fn validate_claim(
  params: OTCParams,
  otc_validator_hash: ScriptHash,
  otcDatum_In: OTCDatum,
  transaction: Transaction,
) -> Bool {
  let otc_policy_id: PolicyId = otc_validator_hash
  let otc_nft_policy_id: PolicyId = otcDatum_In.od_otc_nft_policy_id

  // Get input OTC UTXO with tokens
  expect Some((otc_In, _)) =
    get_otc_from_inputs(transaction, otc_policy_id, params.pp_otc_id_tn, 1)
  // Get output OTC UTXO that will hold MAYZ deposit
  expect Some((otc_Out, otcDatum_Out)) =
    get_otc_from_outputs(transaction, otc_policy_id, params.pp_otc_id_tn, 1)

  // Create the expected script address
  let expected_address = from_script(otc_validator_hash)
  // Control Value for buyer output with tokens
  let buyer_Value_Control =
    [
      Pair(
        otcDatum_In.od_token_policy_id,
        [Pair(otcDatum_In.od_token_tn, otcDatum_In.od_token_amount)],
      ),
    ]
      |> from_asset_list()

  // Control Value: Remove underlying tokens and add OTC NFT token
  let otc_Out_Value_Control =
    otc_In.value
      |> add(
          otcDatum_In.od_token_policy_id,
          otcDatum_In.od_token_tn,
          -otcDatum_In.od_token_amount,
        )
      |> add(otc_nft_policy_id, otcDatum_In.od_otc_nft_tn, 1)

  // Control Datum: Must remain unchanged
  let otcDatum_Out_Control = otcDatum_In

  and {
    // Verify OTC NFT is present in inputs
    check_if_otc_nft_is_present_in_inputs(
      transaction,
      otc_nft_policy_id,
      otcDatum_In.od_otc_nft_tn,
    ),
    // Verify that the created UTXO goes to the expected address
    otc_Out.address == expected_address,
    // Verify tokens are sent to buyer
    check_value_sent_to_signer(transaction, buyer_Value_Control),
    // Value validations
    otc_Out.value == otc_Out_Value_Control,
    // Datum validations
    otcDatum_Out == otcDatum_Out_Control,
  }
}

pub fn validate_close(
  params: OTCParams,
  otc_validator_hash: ScriptHash,
  otcDatum_In: OTCDatum,
  transaction: Transaction,
) -> Bool {
  let otc_policy_id: PolicyId = otc_validator_hash
  let otc_nft_policy_id: PolicyId = otcDatum_In.od_otc_nft_policy_id

  // Get input OTC UTXO with MAYZ deposit
  expect Some((_, _)) =
    get_otc_from_inputs(transaction, otc_policy_id, params.pp_otc_id_tn, 1)

  // No OTC output should exist after closing
  expect None =
    get_otc_from_outputs(transaction, otc_policy_id, params.pp_otc_id_tn, 0)

  // Control Value for creator output with MAYZ deposit and ADA
  let creator_Value_Control =
    [
      Pair(
        otcDatum_In.od_mayz_policy_id,
        [Pair(otcDatum_In.od_mayz_tn, otcDatum_In.od_mayz_locked)],
      ),
    ]
      |> from_asset_list()
      |> add_lovelace(otcDatum_In.od_min_ada)

  and {
    check_if_otc_nft_is_present_in_inputs(
      transaction,
      otc_nft_policy_id,
      otcDatum_In.od_otc_nft_tn,
    ),
    // Authorization check
    is_signed_by_creator(transaction, otcDatum_In.od_creator),
    // Burn validations
    quantity_of(transaction.mint, otc_policy_id, params.pp_otc_id_tn) == -1,
    quantity_of(transaction.mint, otc_nft_policy_id, otcDatum_In.od_otc_nft_tn) == -1,
    // Creator receives MAYZ deposit
    check_value_sent_to_wallet(
      transaction,
      otcDatum_In.od_creator,
      creator_Value_Control,
    ),
  }
}

pub fn validate_cancel(
  params: OTCParams,
  otc_validator_hash: ScriptHash,
  otcDatum_In: OTCDatum,
  transaction: Transaction,
) -> Bool {
  let otc_policy_id: PolicyId = otc_validator_hash
  let otc_nft_policy_id: PolicyId = otcDatum_In.od_otc_nft_policy_id

  // Get input OTC UTXO with all tokens
  expect Some((_, _)) =
    get_otc_from_inputs(transaction, otc_policy_id, params.pp_otc_id_tn, 1)
  // No OTC output should exist after canceling
  expect None =
    get_otc_from_outputs(transaction, otc_policy_id, params.pp_otc_id_tn, 0)

  // Control Value for creator output with all assets
  let creator_Value_Control =
    merge(
      from_asset_list(
        [
          Pair(
            otcDatum_In.od_mayz_policy_id,
            [Pair(otcDatum_In.od_mayz_tn, otcDatum_In.od_mayz_locked)],
          ),
        ],
      ),
      from_asset_list(
        [
          Pair(
            otcDatum_In.od_token_policy_id,
            [Pair(otcDatum_In.od_token_tn, otcDatum_In.od_token_amount)],
          ),
        ],
      ),
    )
      |> add_lovelace(otcDatum_In.od_min_ada)

  and {
    check_if_otc_nft_is_present_in_inputs(
      transaction,
      otc_nft_policy_id,
      otcDatum_In.od_otc_nft_tn,
    ),
    // Authorization check
    is_signed_by_creator(transaction, otcDatum_In.od_creator),
    // Burn validations
    quantity_of(transaction.mint, otc_policy_id, params.pp_otc_id_tn) == -1,
    quantity_of(transaction.mint, otc_nft_policy_id, otcDatum_In.od_otc_nft_tn) == -1,
    // Creator receives all assets
    check_value_sent_to_wallet(
      transaction,
      otcDatum_In.od_creator,
      creator_Value_Control,
    ),
  }
}

pub fn validate_update_min_ada(
  params: OTCParams,
  otc_validator_hash: ScriptHash,
  otcDatum_In: OTCDatum,
  new_min_ada: Int,
  transaction: Transaction,
) -> Bool {
  let otc_policy_id: PolicyId = otc_validator_hash

  // Get input and output OTC UTXOs
  expect Some((otc_In, _)) =
    get_otc_from_inputs(transaction, otc_policy_id, params.pp_otc_id_tn, 1)
  expect Some((otc_Out, otcDatum_Out)) =
    get_otc_from_outputs(transaction, otc_policy_id, params.pp_otc_id_tn, 1)

  // Create the expected script address
  let expected_address = from_script(otc_validator_hash)

  let otc_Out_Value_Control =
    otc_In.value
      |> add_lovelace(-otcDatum_In.od_min_ada + new_min_ada)

  let otcDatum_Out_Control = OTCDatum { ..otcDatum_In, od_min_ada: new_min_ada }

  and {
    // Authorization check
    is_signed_by_creator(transaction, otcDatum_In.od_creator),
    // Verify that the created UTXO goes to the expected address
    otc_Out.address == expected_address,
    // Minimum ADA validation
    new_min_ada > 0,
    // Value validations
    otc_Out.value == otc_Out_Value_Control,
    // Datum validations
    normalize_otc_datum(otcDatum_Out) == normalize_otc_datum(
      otcDatum_Out_Control,
    ),
  }
}
