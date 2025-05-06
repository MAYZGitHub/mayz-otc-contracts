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
- Create educational resources to support adoption

## 🧠 Smart Contract Implementation

All contracts were deployed on **Cardano Preview Testnet** with verified hashes and addresses:

| Script | Address | Type | Plutus Version |
|--------|------|------|------|
| `OtcValidator.plutus` | [addr_test1wprx...ct28](https://preview.cexplorer.io/address/addr_test1wprx36hdsvucyjp88t9rugghypfv3un89gxuz64k3p00uvcj7ct28) | Validator and Policy | v3 |
| `ProtocolValidator.plutus` | [addr_test1wr8g...vgk8](https://preview.cexplorer.io/address/addr_test1wr8g2ukhvyntq3z2ku05cxyyn9ewdszfgayzq6vy59ddtesnnvgk8) | Validator and Policy | v3 |

✔️ Searchable on [Cexplorer](https://cexplorer.io/) and [Cardanoscan](https://cardanoscan.io/) with their respective script hashes and addresses.

These contracts are deployed and fully functional. They were tested using emulator mode, and then on-chain via the Preview Testnet. This environment provides sufficient validation for trustless OTC functionality, including minting, locking, claiming, and refund logic.

### ❗ Why We Chose Not to Deploy to Mainnet

After careful evaluation, we opted not to deploy on Mainnet at this stage. Our reasoning is:

- Testnet deployment proves full end-to-end functionality in a live Cardano network environment.
- Safety and repeatability were prioritized for onboarding, testing, and educational use.
- Mainnet deployment should only occur once broader usage or liquidity demands it. Right now, developer and community evaluation are better served in Testnet.

Contracts are Mainnet-ready and easily deployable. However, for Catalyst goals — validation, accessibility, documentation, and transparency — the current setup fully satisfies the milestone.

## 🔧 Components Completed

- ✅ Full contract functionality tested and deployed
- ✅ UI integrated with all redeemers (lock, claim, refund)
- ✅ SmartDB backend integrated and operational
- ✅ NFT-based representation of OTC positions
- ✅ Emulator and Testnet test flows working as expected

## 📄 Technical Documentation

- [Architecture](../docs/MAYZ-OTC-Architecture.md)
- [Smart Contracts - Overview](../docs/MAYZ-OTC-Architecture.md)
- [Smart Contract - Architecture](../smart-contracts/README.md)
- [dApp UI Repository](https://github.com/MAYZGitHub/mayz-otc-dapp)

### 🧮 Detailed Function Specifications

Each contract entrypoint is documented with arguments, expected datum format, and Plutus validation logic. All redeemers are unit-tested in emulator mode and validated for  Preview Tesnet deployment.

## 🌐 DApp and Code Repositories

- DApp (Frontend): <https://github.com/MAYZGitHub/mayz-otc-dapp>
- Smart Contracts: <https://github.com/MAYZGitHub/mayz-otc-contracts> [this repo]

## 📸 Evidence of Completion

- ✅ GitHub Repo: <https://github.com/MAYZGitHub/mayz-otc-dapp>
- ✅ Final Demonstration Video: <https://www.youtube.com/watch?v=mfEXdJ-sYZY>

The video showcases:

- Protocol creation flow
- OTC position creation (token locking)
- Claiming / refunding positions
- Wallet connection and UI interactions
- Verification of contract addresses

## 📄 How to Use (For Reviewers / Community)

To run the DApp locally:

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

➡️ We believe this satisfies both the letter and intent of the milestone requirements, even without a Mainnet deployment. The current setup maximizes accessibility, verifiability, and safety.

➡️ The implementation focuses on simplicity, transparency, and extensibility — prioritizing individual users while supporting future protocol-level OTC models.

Thank you for supporting MAYZ Protocol.

<p align="right">(<a href="#readme-top">back to top</a>)</p>
