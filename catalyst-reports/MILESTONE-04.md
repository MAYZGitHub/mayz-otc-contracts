# Milestone 04 Report

**Project:** MAYZ Trustless OTC Protocol  
**Milestone 04:** Open-Source Release and Community Engagement  
**Submitted to:** Project Catalyst

## ✅ Overview

Milestone 4 concludes the Cardano Catalyst-funded development of the MAYZ Trustless OTC protocol. This stage focused on deployment, public access, and onboarding materials to maximize adoption and engagement. With the successful completion of this phase, the full lifecycle of the MAYZ OTC contracts is available and operational on Cardano.

## 🎯 Objectives

- Deploy and verify smart contracts
- Provide a functional public-facing website (DApp)
- Publish clear documentation and onboarding resources
- Record close-out video & report to fulfill Catalyst requirements

## 🧠 Smart Contract Implementation

All contracts were deployed on **Cardano Mainnet** with verified hashes and addresses:

| Script | Address | Type | Plutus Version |
|--------|------|------|------|
| `OtcValidator.plutus` | [addr1w93kjy8vgfka66aaw2780njmjz9csxvt9k43snv7mwmvfygnwg8nw](https://cexplorer.io/address/addr1w93kjy8vgfka66aaw2780njmjz9csxvt9k43snv7mwmvfygnwg8nw) | Validator and Policy | v3 |
| `ProtocolValidator.plutus` | [addr1wye288h4r29j40ktpu4r7zlf25e84vj58w63r5jnxp3xphgs645fj](https://cexplorer.io/address/addr1wye288h4r29j40ktpu4r7zlf25e84vj58w63r5jnxp3xphgs645fj) | Validator and Policy | v3 |

| Token | PolicyID/Assetname | Type | Network |
|--------|------|------|------|
| `Protocol` | [32a39ef51a8b2abecb0f2a3f0be955327ab2543bb511d253306260dd](https://cexplorer.io/policy/32a39ef51a8b2abecb0f2a3f0be955327ab2543bb511d253306260dd) | Protocol Policy ID | Mainnet |
| `Validator` | [636910ec426ddd6bbd72bc77ce5b908b88198b2dab184d9edbb6c491](https://cexplorer.io/policy/636910ec426ddd6bbd72bc77ce5b908b88198b2dab184d9edbb6c491) | Validator Policy ID | Mainnet |
| `OTC-SNEK-100` | [636910ec426ddd6bbd72bc77ce5b908b88198b2dab184d9edbb6c491.4f54432d534e454b2d313030](https://cexplorer.io/asset/asset1m3w4yj0y97fkd47tphz09fzfwy3pu6aas4hw5l) | OTC token | Mainnet |

✔️ Searchable on [Cexplorer](https://cexplorer.io/) and [Cardanoscan](https://cardanoscan.io/) with their respective script hashes and addresses.

These contracts are deployed and fully functional. They were tested using emulator mode, on-chain via the Preview Testnet and finally in the Cardano Mainnet. This fulfills validation for trustless OTC functionality, including minting, locking, claiming, and refund logic.

## 🔧 Components Completed

- ✅ Full contract functionality tested and deployed
- ✅ UI integrated with all redeemers (lock, claim, refund)
- ✅ SmartDB backend integrated and operational
- ✅ NFT-based representation of OTC positions
- ✅ Emulator and Testnet test flows working as expected
- ✅ Mainnet deployment working as expected

## 📄 Technical Documentation

- [Architecture](../docs/MAYZ-OTC-Architecture.md)
- [Smart Contracts - Overview](../docs/MAYZ-OTC-Architecture.md)
- [Smart Contract - Architecture](../smart-contracts/README.md)
- [dApp UI Repository](https://github.com/MAYZGitHub/mayz-otc-dapp)

### 🧮 Detailed Function Specifications

Each contract entrypoint is documented with arguments, expected datum format, and Plutus validation logic. All redeemers are unit-tested in emulator mode and validated for  Preview Tesnet deployment.

## 🌐 DApp, Code Repositories and Sites

Repositories
- DApp (Frontend): <https://github.com/MAYZGitHub/mayz-otc-dapp>
- Smart Contracts: <https://github.com/MAYZGitHub/mayz-otc-contracts> [this repo]

Live sites:
- Mainnet site: <https://otc.mayz.io>

## 📸 Evidence of Completion

- ✅ GitHub Repo: <https://github.com/MAYZGitHub/mayz-otc-dapp>
- ✅ Final Demonstration Video: <https://www.youtube.com/watch?v=mfEXdJ-sYZY>
- ✅ Live Cardano Mainnet site: <https://otc.mayz.io>
- ✅ Close Out Report: <https://docs.google.com/document/d/1pHb-QT5XRtmgv34d59-rkA_PKDrSHBvMj8qLljnJ-Xg/edit?tab=t.0>

The video showcases:

- Protocol creation flow
- OTC position creation (token locking)
- Claiming / refunding positions
- Wallet connection and UI interactions
- Verification of contract addresses

## 📄 How to Use (For Reviewers / Community)

OPTION 1: To test the live Cardano Mainnet site:

1. Go to <https://otc.mayz.io>
2. Follow the on-screen instructions, site is running at MVP level at the moment.
3. You can then:
      - Create a protocol
      - Create OTC positions locking any supported token
      - Claim or cancel OTC positions
      - View your positions represented via NFTs


OPTION 2: To run the DApp locally:

1. Clone the repository:
   ```
   git clone https://github.com/MAYZGitHub/mayz-otc-dapp.git
   cd mayz-otc-dapp
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Copy the example environment file and configure:
   ```
   cp .env .env.local
   ```

4. Run the development server:
   ```
   npm run dev
   ```

5. Open the browser and connect your Cardano wallet (Testnet Preview)

You can then:

- Create a protocol
- Create OTC positions locking any supported token
- Claim or cancel OTC positions
- View your positions represented via NFTs

## 🔐 Security Considerations

- Trustless design using validator + NFT pattern
- Contracts enforce strict ownership and redeemer logic
- No custodial backend — funds locked at script address
- Emulator + Testnet used for reproducible testing and safety

## 📝 Note to Reviewers

This milestone demonstrates:

- Full protocol lifecycle across UI, backend, and contracts
- Public open-source release
- Onboarding support via demo video and walkthrough
- Verified on-chain deployment (Testnet)
- Verified on-chain deployment (Mainnet) and live MVP dApp site

➡️ We believe this satisfies both the letter and intent of the milestone requirements. The current setup maximizes accessibility, verifiability, and safety.

➡️ The implementation focuses on simplicity, transparency, and extensibility — prioritizing individual users while supporting future protocol-level OTC models.

Thank you for supporting MAYZ Protocol.

<p align="right">(<a href="#readme-top">back to top</a>)</p>
