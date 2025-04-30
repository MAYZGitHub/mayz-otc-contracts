# MAYZ OTC - Architecture Overview

## Core Design: Individualized OTC Smart Contract

- Users lock tokens into a smart contract
- Contract mints a unique NFT = claim right for locked assets
- NFT tradable on 3rd-party marketplaces
- Redemption logic enforced via datum

## Smart Contract Flow

1. **Token Locking**
   - User sends ADA + tokens to contract address
2. **Minting NFT**
   - NFT encodes claim right and metadata describing locked value
3. **NFT Trading**
   - OTC NFT can be freely traded
4. **Redemption**
   - Holder sends NFT to contract to receive locked assets

## Datum Schema
- `creator`: original locker / MAYZ holder
- `token_info`: token name, policy, amount
- `expiration`: optional timeout for claim
- `status`: locked / redeemed / expired

## Minting Policy
- NFTs are unique and governed by same script validating redemptions

## UI Tabs
- **Create OTC** — admin tools for protocol owners
- **Manage** — see locked tokens and open positions
- **Claim** — see OTCs eligible for redemption

## Tech Stack
- **SmartDb** backend (Protofire)
- **Next.js + React** frontend
- **MongoDB / PostgreSQL** supported

<p align="right">(<a href="#readme-top">back to top</a>)</p>
