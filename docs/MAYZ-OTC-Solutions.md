# Analysis of Possible Solutions

## Individualized Solution

- **Functionality**: Users lock tokens and receive an NFT in return, tradable in marketplaces.
- **Pros**: Simple, flexible for individuals.
- **Cons**: NFT metadata clarity must be managed well.
- **Architecture**: One Plutus v3 script handles mint + validation; uses datum to store:
  - Creator info
  - Token quantity & ID
  - Retrieval logic for MAYZ token

## Institutional Solution

- **Functionality**: Projects deploy OTC contracts tailored to their tokens.
- **Pros**: Consistency, access control, standardized rules.
- **Cons**: Complex, requires whitelisting/oracles.
- **Architecture**: Either one shared Plutus contract w/ config or per-protocol deployments.

## Chosen Approach: Individualized First

Phased plan:
1. Deploy flexible, single-user OTC contracts
2. Use metadata to make NFTs clear
3. Gather real usage feedback
4. Expand to institutional OTC if demand warrants

## MAYZ Token Utility

- Individuals use it to open OTC deals
- Protocols use it in combo w/ their token
- Burned or retrieved when position resolves

## Key Considerations

- **Standardization**: Names like "silver", "gold", or "OTC-LEND-1.5M" used for clarity
- **Multi-token NFTs**: In future, may wrap multiple tokens per OTC/NFT

<p align="right">(<a href="#readme-top">back to top</a>)</p>
