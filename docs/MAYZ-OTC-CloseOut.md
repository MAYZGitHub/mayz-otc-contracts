MAYZ Trustless OTC Protocol Close-Out Report
Project Metadata
Name: MAYZ Trustless OTC Protocol


Project Number: 1200222


Project URL: https://cardano.ideascale.com/c/cardano/idea/120544


Project Manager: Agustín Franchella


Team: Diego Torres Borda, Federico Ledesma Calatayud, Diego Macchi, Manuel Padilla, Alfred Vilsmeier, Luis Restrepo


Start Date: July 15, 2024


Completion Date: May 9, 2025


Challenge KPIs and How Addressed
Products & Integrations That Drive Adoption


dApps & tools released: Full OTC DApp deployed on Cardano Mainnet.


Open-source deliverables: All smart contracts and UI repositories released.


Onboarding & ecosystem expansion: Demo video, onboarding guides, and complete documentation provided.


Project KPIs and How Addressed
Research liquidity challenges: Completed in Milestone 1.


Technical architecture & documentation: Completed in Milestone 2; diagrams, flowcharts, README.


Implement smart contracts in Aiken: Completed and tested with 100% pass in Milestone 3.


Deploy DApp & Contracts to Testnet: Achieved in Milestone 4.


Deliver code, demo video, documentation: Completed.


Evidence
Proof of Achievement: https://milestones.projectcatalyst.io/projects/1200222
Key Achievements
Implemented a fully trustless OTC protocol with NFT-based positions.


Adopted Aiken and Plutus V3, aligning with Cardano’s latest smart contract evolution.


Delivered a working DApp connected to Cardano Mainnet.


Engaged community testers, developers, and SPOs.


Released all deliverables open-source via GitHub.


Key Learnings
Aiken accelerates development and testing, offering better developer UX than traditional Plutus.


Early architectural clarity reduces downstream errors.


Mainnet deployment is best staged after community testing.


Documentation and onboarding support were crucial for feedback.


Next Steps
Conduct additional security audits.


Plan Mainnet deployment based on adoption signals.


Integrate with wallets (Lace, Eternl) and DEXs for deeper ecosystem utility.


Seek partnership/funding to extend functionality and liquidity sourcing.


Final Thoughts
MAYZ Trustless OTC is a pioneering effort in solving off-chain liquidity pain points within Cardano. By combining NFTs, validator logic, and a simple UI, we’ve built a modular and reusable system. We appreciate Catalyst support and look forward to community experimentation and adoption.
Project Sources & Documents
Smart Contracts Repo: https://github.com/MAYZGitHub/mayz-otc-contracts


Frontend DApp Repo: https://github.com/MAYZGitHub/mayz-otc-dapp


Milestone Reports: Included in catalyst-reports/ folder in the contracts repo


Documentation: See main README and docs/ directory in contracts repo


Close-out Video
https://www.youtube.com/watch?v=LGw46_sO11k

Functional Documentation
1. Smart Contract Function Breakdown
create_offer
Purpose: Mint NFT & lock offered tokens.


Inputs:


OfferDatum fields: offerer: PubKeyHash, offered_asset: (PolicyID, AssetName, Integer), ask_asset: (PolicyID, AssetName, Integer), deadline: Slot


Outputs:


UTxO at script address with locked tokens and NFT


State Changes:


Mints one NFT via OtcTokenMint policy


Locks offered tokens in validator UTxO


accept_offer
Purpose: Exchange offered tokens for ask tokens.


Inputs:


Redeemer: AcceptOffer


OfferDatum from UTxO


Offer NFT (to burn)


Ask tokens from taker


Outputs:


Sends offered tokens to taker


Sends ask tokens to offerer


State Changes:


Burns NFT


Consumes UTxO; transfers assets


cancel_offer
Purpose: Allow offerer to cancel and retrieve tokens.


Inputs:


Redeemer: CancelOffer


OfferDatum from UTxO


Offerer’s signature


Offer NFT


Outputs:


Returns offered tokens to offerer


State Changes:


Burns NFT


Consumes UTxO; returns assets


redeem_after_timeout (safety)
Purpose: Recover tokens after deadline.


Inputs:


Similar to cancel but enforces txInfo.validRange ⊆ (−∞, deadline]


Outputs: Returns tokens


State Changes: Consumes UTxO


NFT Minting Policy (OtcTokenMint.aiken):
Mints exactly one NFT per OfferDatum


Token name: sha2_256(OfferDatum)


Only in same Tx as locking UTxO


2. Error & Security Handling
Redeemer Enforcement: pattern-match on AcceptOffer/CancelOffer; invalid redeemers fail.


Signature Checks: CancelOffer requires datum.offerer ∈ txInfo.signatories; AcceptOffer requires NFT.


NFT Policy Safeguards: Enforces exact NFT count/name in minting; tests verify mint failures.


Expiration Logic: Enforces txInfo.validRange ⊆ (−∞, deadline]; tests cover post-deadline rejection.


Value Preservation: Checks exact asset amounts both in accept and cancel.


Reversion Behavior: Any unmet condition reverts Tx.


Off-Chain Checks: Pre-flight validations mirror on-chain, with clear UI error messages.


3. Dependency on Other MAYZ Contracts
Self-contained: no external MAYZ contracts.


Emergency/Admin tokens minted off-chain via cardano-cli with fixed expiry; cannot be minted/burned further.


Future validators (validatorV2) can be added without other contracts; off-chain config selects version.


4. External Interface Details
Wallets (CIP-30)
Lucid with CIP-30 wallets: Lace, Eternl, Nami, Gero.


Connect via walletStore.getLucid() after enable().


Endpoints
Next.js API at /api/otc:


OTC_CREATE → CreateOTCTxParams (protocol_id, od_token_policy_id, od_token_tn, od_token_amount)


OTC_CLAIM → ClaimOTCTxParams (protocol_id, otcDbId)


OTC_CLOSE → CloseOTCTxParams (protocol_id, otcDbId)


OTC_CANCEL → CancelOTCTxParams (protocol_id, otcDbId)


Handled by OTCBackEndApplied using Lucid’s TxBuilder.


Token Standards
Offered/ask: any CIP-20.


Offer NFT: CIP-25 metadata:


name, description, properties (offered_amount, ask_amount, deadline, offerer)


Inline datums (CIP-47) and reference scripts (CIP-68).


DEX & Marketplace
Off-chain code can integrate DEXs for liquidity.


Offer NFTs listable on Cardano NFT marketplaces.


5. Smart Contract Upgrade Plan
Rationale
Shift to individualized UTxO+NFT approach enables per-offer auditability, reduces dependencies, simplifies versioning.
On-Chain Version Tagging
validatorV1 exposed in ProtocolValidator.aiken; future validatorV2 added in the same module.


Off-Chain Version Selection
VALIDATOR_VERSION = "v1" in DApp config; update value and redeploy for upgrades.


Deployment & Roll-Out
Develop & test new validator; run full test suite.


Compile new script hash; update DApp config; redeploy.


(Optional) Update on-chain registry UTxO if used.


Existing offers remain under validatorV1 unless migrated.


Governance
No admin backdoor; emergency/admin tokens immutable markers only.
6. Documentation Publication & Social Links
Location: docs/MAYZ-OTC-CloseOut.md in mayz-otc-contracts repo.


Channels:


Instagram: https://www.instagram.com/mayz.protocol/


Discord: https://discord.com/invite/6xkbynuNrj


Medium: https://medium.com/@MAYZ.io


X: https://x.com/MAYZProtocol


Website: https://mayz.io
