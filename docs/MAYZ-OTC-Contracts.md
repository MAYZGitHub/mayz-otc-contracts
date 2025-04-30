# Smart Contracts Overview

## 📂 Structure

- `contracts/`
  - `OtcTokenMint.plutus`
  - `OtcValidator.plutus`
  - `MAYZToken.plutus`

## 🔐 Scripts

### 1. `OtcTokenMint`
- Enforces NFT mint policy
- Ensures each OTC NFT represents valid underlying tokens

### 2. `OtcValidator`
- Core contract that receives token deposits
- Ensures redemption only possible by NFT holder

### 3. `MAYZToken`
- MAYZ token utility logic (future use)

## 🧾 Datum Fields
```json
{
  "creator": "addr1...",
  "tokenName": "LEND",
  "amount": 1500000,
  "policyId": "abcdef...",
  "status": "locked"
}
```

## 🔄 Flow
- Lock tokens → Contract mints NFT
- NFT traded → Secondary market
- NFT returned → Unlock tokens

## Future Plans
- Audit by external firm
- Extend contract to allow multi-token support
- Support institutional/multi-user contracts

<p align="right">(<a href="#readme-top">back to top</a>)</p>
