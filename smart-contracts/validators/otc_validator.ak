use aiken/collection/list
use cardano/address.{Address, Script}
use cardano/assets.{PolicyId}
use cardano/transaction.{Input, Output, OutputReference, Transaction}
use otc_validator_utils.{
  validate_burnID, validate_cancel, validate_claim, validate_close,
  validate_mintID, validate_update_min_ada,
}
use types.{
  CancelOTC, ClaimOTC, CloseOTC, CreateOTC, OTCDatum, OTCParams, OTCRedeemer,
  UpdateOTCMinADA,
}

/// OTC validator script
/// Handles creation, claiming, closing and cancellation of OTC positions
validator otc(params: OTCParams) {
  spend(
    datum: Option<OTCDatum>,
    redeemer: OTCRedeemer,
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

    let otc_validator_hash = own_validator_hash

    when datum is {
      Some(otcDatum_In) ->
        when redeemer is {
          ClaimOTC ->
            validate_claim(params, otc_validator_hash, otcDatum_In, transaction)
          CloseOTC ->
            validate_close(params, otc_validator_hash, otcDatum_In, transaction)
          CancelOTC ->
            validate_cancel(
              params,
              otc_validator_hash,
              otcDatum_In,
              transaction,
            )
          UpdateOTCMinADA { new_min_ada } ->
            validate_update_min_ada(
              params,
              otc_validator_hash,
              otcDatum_In,
              new_min_ada,
              transaction,
            )
          CreateOTC -> False
        }
      None -> False
    }
  }

  mint(redeemer: OTCRedeemer, otc_policy_id: PolicyId, transaction: Transaction) {
    when redeemer is {
      CreateOTC -> validate_mintID(params, otc_policy_id, transaction)
      CloseOTC | CancelOTC ->
        validate_burnID(params, otc_policy_id, transaction)
      _ -> False
    }
  }

  else(_) {
    fail @"Invalid Use of OTC Validator"
  }
}
