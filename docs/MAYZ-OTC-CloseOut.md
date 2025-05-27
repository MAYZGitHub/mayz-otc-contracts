# MAYZ Trustless OTC Protocol Close-Out Report

---

## 🧾 Project Overview

**Project Name**: MAYZ Trustless OTC Protocol  
**Project Number**: 1200222  
**IdeaScale Link**: [https://cardano.ideascale.com/c/cardano/idea/120544](https://cardano.ideascale.com/c/cardano/idea/120544)  
**Project Manager**: Agustín Franchella  
**Team Members**: Diego Torres Borda, Federico Ledesma Calatayud, Diego Macchi, Manuel Padilla, Alfred Vilsmeier, Luis Restrepo  
**Start Date**: July 15, 2024  
**Completion Date**: May 9, 2025

---

## 🎯 Challenge KPIs and Outcomes

**Challenge Area**: Products & Integrations That Drive Adoption

- ✔ Full OTC DApp deployed on Cardano Mainnet  
- ✔ All smart contracts and UI repos released open source  
- ✔ Demo video, onboarding guides, public documentation

---

## ✅ Project KPIs by Milestone

- **Research Liquidity Challenges**: Explored pain points within the Cardano DeFi landscape (Milestone 1)  
- **Architecture & Docs**: Delivered architecture diagrams, flowcharts, and a complete technical README (Milestone 2)  
- **Smart Contracts in Aiken**: Built and fully tested smart contract suite using Aiken (Milestone 3)  
- **Testnet Deployment**: Successfully deployed contracts and DApp to Cardano Testnet (Milestone 4)  
- **Final Delivery**: Deployed Mainnet version with demo video and open-source documentation

📌 **Proof of Achievement**: [View on Milestones Tracker](https://milestones.projectcatalyst.io/projects/1200222)

---

## 🌟 Highlights & Achievements

- Created the first trustless OTC protocol on Cardano using NFT-bound trade offers  
- Adopted Aiken and Plutus V3, contributing to modern smart contract development  
- Engaged the Cardano community in testing and validating the protocol  
- Delivered everything open-source, from smart contracts to onboarding tools

---

## 🧠 Key Learnings

- Aiken enables faster iteration and smoother testing compared to legacy Plutus  
- Starting with a clear architecture minimized rework and errors later  
- Phased deployment—testnet to Mainnet—gave us valuable feedback loops  
- Strong documentation played a key role in developer and user adoption

---

## 🔭 Next Steps

- Perform a comprehensive security audit  
- Continue planning for Mainnet expansion based on user demand  
- Add integrations with popular wallets (Lace, Eternl) and Cardano DEXs  
- Seek partners and funding to expand liquidity support and extend use cases

---

## 💬 Final Thoughts

The MAYZ Trustless OTC Protocol represents a modular, reusable system for off-chain liquidity matching. By combining NFTs and validator logic into a seamless user experience, we’ve created a new way to perform OTC trades transparently and securely. Thanks to Project Catalyst and the Cardano community for making this possible.

---

## 📂 Project Assets

- **Smart Contracts Repository**: https://github.com/MAYZGitHub/mayz-otc-contracts  
- **Frontend Application**: https://github.com/MAYZGitHub/mayz-otc-dapp  
- **Milestone Reports**: Available in `catalyst-reports/` directory in the repo  
- **Documentation**: See README and `docs/` folder  
- **Demo Video**: https://www.youtube.com/watch?v=LGw46_sO11k

---

## 🧩 Functional Documentation

### 1. Smart Contract Functionality Explained

#### `create_offer`
- **Purpose**: Starts a new OTC deal by locking the user’s tokens and minting a unique NFT  
- **How it works**: User defines offered/ask terms. Stored in smart contract UTxO. `$MAYZ` token required to authorize creation  
- **Result**: Offer becomes active on-chain

#### `accept_offer`
- **Purpose**: A counterparty accepts by sending the required tokens  
- **How it works**: Taker sends ask tokens and receives offered tokens. NFT is burned  
- **Result**: Deal is executed and closed

#### `cancel_offer`
- **Purpose**: Creator cancels offer and retrieves locked tokens  
- **How it works**: Requires valid signature and NFT ownership  
- **Result**: Offer closed, assets returned

#### `redeem_after_timeout`
- **Purpose**: Safety function to reclaim tokens after expiration  
- **How it works**: Offerer can retrieve their tokens if deadline passed

**NFT Minting Logic**:
- One NFT minted per offer  
- Unique name: Original Token Name + Amount (e.g. `MAYZ-100`, `SNEK-1000`)

---

### 2. Security and Error Handling

- **Authorized Actions**: Only creator can cancel; acceptors must own the NFT  
- **Value Checks**: Asset amounts must match exactly  
- **Failure Handling**: Invalid actions revert; no unintended side effects  
- **Off-Chain Checks**: Frontend validates parameters before signing

---

### 3. Contract Dependencies

- Self-contained logic; no dependency on other MAYZ contracts  
- Requires `$MAYZ` utility token to create offers  
- Token dependency configurable during protocol setup  
- **Admin** and **Emergency** tokens allow upgrades, but cannot override or interfere with user-owned trades

---

### 4. Wallet & Ecosystem Integration

- **Wallet Support**: Compatible with Lace, Eternl, Nami, Gero (via Lucid & CIP-30)  
- **API Endpoints**:
  - `/api/otc/create`
  - `/api/otc/claim`
  - `/api/otc/close`
  - `/api/otc/cancel`  
- **Token Standards**:
  - Uses CIP-20 for tokens
  - CIP-25 for NFT metadata
  - CIP-47 (inline datums), CIP-68 (reference scripts)
- **Marketplace Ready**: NFTs are tradable on Cardano platforms

---

### 5. Upgrade Path & Versioning

- **Approach**: Each offer is independent (via UTxO + NFT), enabling modular versioning  
- **Current Version**: Validator logic implemented as `validatorV1`  
- **How Updates Work**:
  - Future validators (`validatorV2`, etc.) can be added  
  - Clients switch via off-chain config without affecting past offers  
- **Governance Tokens**:
  - `EMERGENCY` and `ADMIN` tokens authorize edits
  - Cannot be used to seize funds or override trade logic

---

## 📣 Documentation & Community Links

- **Final Report**: [`MAYZ-OTC-CloseOut.md`](https://github.com/MAYZGitHub/mayz-otc-contracts/blob/main/docs/MAYZ-OTC-CloseOut.md)

### Connect with Us

- [Instagram](https://www.instagram.com/mayz.protocol/)  
- [Discord](https://discord.com/invite/6xkbynuNrj)  
- [Medium](https://medium.com/@MAYZ.io)  
- [X / Twitter](https://x.com/MAYZProtocol)  
- [Website](https://mayz.io)
