# Tubbly StarkNet Contract

This repository contains the **Tubbly** smart contract written in Cairo for StarkNet.
The contract lets users submit balance requests, which must be confirmed by the owner
before balances are updated. It also provides functions for checking balances, viewing
requests and transferring ownership.

## Requirements
- [Scarb](https://docs.swmansion.com/scarb/) (Cairo package manager)

## Testing
Once `Scarb.toml` is provided, tests can be executed with:

```bash
scarb test
```

## License
This project is released under the MIT License.
