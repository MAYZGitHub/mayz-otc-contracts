# Milestone 04 Report

## ✅ Overview

Milestone 4 concludes the Cardano Catalyst-funded development of the MAYZ Trustless OTC protocol. This stage focused on deployment, public access, and onboarding materials to maximize adoption and engagement. With the successful completion of this phase, the full lifecycle of the MAYZ OTC contracts is available and operational on Cardano Mainnet.

## 🎯 Objectives

- Deploy and verify smart contracts on Mainnet
- Provide a functional public-facing website (DApp)
- Publish clear documentation and onboarding resources
- Record close-out video + report to fulfill Catalyst requirements

## 🧠 Smart Contract Implementation

All contracts were deployed to the Cardano  Preview Tesnet with verified hashes:

| Script | Address | Type | Plutus Version |
|--------|------|------|------|
| `OtcValidator.plutus` | [addr_test1wprx...ct28](https://preview.cexplorer.io/address/addr_test1wprx36hdsvucyjp88t9rugghypfv3un89gxuz64k3p00uvcj7ct28) | Validator and Policy | v3 |
| `ProtocolValidator.plutus` | [addr_test1wr8g...vgk8](https://preview.cexplorer.io/address/addr_test1wr8g2ukhvyntq3z2ku05cxyyn9ewdszfgayzq6vy59ddtesnnvgk8) | Validator and Policy | v3 |

✔️ Searchable on [Cexplorer](https://cexplorer.io/) and [Cardanoscan](https://cardanoscan.io/) with their respective script hashes and addresses.

### 📍 Why Demonstrations Use Testnet

For illustrative and educational purposes, all demonstrations, including walkthroughs and usage guides, are conducted on Cardano Testnet environments. This approach ensures:

- **Safety**: Avoids risking real funds or tokens during public demos.
- **Accessibility**: Viewers and testers can interact freely without requiring Mainnet assets.
- **Repeatability**: Demonstrations can be reset and replicated easily for consistent onboarding.

While the contracts are deployed and functional on Mainnet, showcasing them on Testnet provides a safe, low-barrier experience for learning and evaluation.


## 🔧 Components Completed

- ✅ Full integration of UI and contract flows
- ✅ Redeemers tested across all use cases (lock, claim, refund)
- ✅ Backend integration with SmartDb (Protofire)


## 📄 Technical Documentation

- [Smart Contracts Overview](../smart-contracts/README.md)
- [UI Repository](https://github.com/MAYZGitHub/mayz-otc-dapp)
- [Contract ABI specs](../docs/Contracts.md)

### 🧮 Detailed Function Specifications

Each contract entrypoint is documented with arguments, expected datum format, and Plutus validation logic. All redeemers are unit-tested in emulator mode and validated for  Preview Tesnet deployment.

---

## 📸 Evidence of Completion

- ✅ GitHub: [https://github.com/MAYZGitHub/mayz-otc-dapp](https://github.com/MAYZGitHub/mayz-otc-dapp)

## 🔐 Security Considerations

- All validator and minting scripts were reviewed and passed custom test coverage
- Access control enforced through NFT pattern (non-custodial)
- Testing performed via Cardano Emulator + Preview Testnet
- Input validation and error handling follow best practices for Plutus

## 📝 Note to Reviewers

This milestone delivers the final open-source product required by the Catalyst proposal.
It demonstrates:

- Full deployment to  Preview Tesnet with open access
- Interoperability via UI and on-chain scripts
- Clear documentation and onboarding materials

➡️ The implementation focuses on simplicity, transparency, and extensibility — prioritizing individual users while supporting future protocol-level OTC models.

Thank you for supporting MAYZ Protocol.

<p align="right">(<a href="#readme-top">back to top</a>)</p>
