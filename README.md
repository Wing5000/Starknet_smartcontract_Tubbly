# Tubbly StarkNet Contract

This repository contains the **Tubbly** smart contract written in Cairo for StarkNet.
The contract lets users submit balance requests, which must be confirmed by the owner
before balances are updated. It also provides functions for checking balances, viewing
requests and transferring ownership.

## How it Works

1. A user calls `submit` with a unique request ID and the desired balance increase.
   The request stores the caller address and amount.
2. The contract owner reviews pending requests and approves them by calling
   `confirm` with the same request ID. On approval, the requested amount is added
   to the user's balance and the request slot is cleared.
3. Anyone can query an address balance through `balanceOf`.
4. The owner can inspect pending requests via `getRequest` and may transfer
   control of the contract to another address using `changeOwnership`.

## Requirements
- [Scarb](https://docs.swmansion.com/scarb/) (Cairo package manager)

## Testing
Once `Scarb.toml` is provided, tests can be executed with:

```bash
scarb test
```

## License
This project is released under the MIT License.
