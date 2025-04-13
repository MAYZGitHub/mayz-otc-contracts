use aiken/collection/list
use cardano/address.{Address, Script}
use cardano/assets.{PolicyId}
use cardano/transaction.{Input, Output, OutputReference, Transaction}
use protocol_utils.{
  validate_create, validate_update_min_ada, validate_update_params,
}
use types.{
  CreateProtocol, ProtocolDatum, ProtocolParams, ProtocolRedeemer,
  UpdateProtocolMinADA, UpdateProtocolParams,
}

/// Protocol validator implementing both spend and minting policies in a single Plutus V3 script
validator protocol(params: ProtocolParams) {
  spend(
    datum: Option<ProtocolDatum>,
    redeemer: ProtocolRedeemer,
    own_ref: OutputReference,
    transaction: Transaction,
  ) {
    let Transaction { inputs, .. } = transaction

    expect Some(own_input) =
      list.find(inputs, fn(input) { input.output_reference == own_ref })

    let Input {
      output: Output { address: Address { payment_credential, .. }, .. },
      ..
    } = own_input

    expect Script(own_validator_hash) = payment_credential

    let protocol_policy_id = own_validator_hash

    when datum is {
      Some(protocolDatum_In) ->
        when redeemer is {
          UpdateProtocolParams ->
            validate_update_params(
              params,
              protocol_policy_id,
              protocolDatum_In,
              transaction,
            )
          UpdateProtocolMinADA { new_min_ada } ->
            validate_update_min_ada(
              params,
              protocol_policy_id,
              protocolDatum_In,
              new_min_ada,
              transaction,
            )
          CreateProtocol -> False
        }
      None -> False
    }
  }

  mint(
    redeemer: ProtocolRedeemer,
    protocol_policy_id: PolicyId,
    transaction: Transaction,
  ) {
    when redeemer is {
      CreateProtocol -> validate_create(params, protocol_policy_id, transaction)
      _ -> False
    }
  }

  else(_) {
    fail @"Invalid Use of Protocol Validator"
  }
}
