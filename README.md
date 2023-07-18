# base-camp

Solidity solutions for exercises in [Base Camp](https://docs.base.org/base-camp/docs/welcome), the smart contract learning program, using [Foundry](https://github.com/foundry-rs/foundry).

This repository is intended for those who have already solved the exercises, and are looking for alternative approaches.
Please do not use the solutions here as your own if you have not solved them. I strongly suggest attempting the exercises yourself! Otherwise, you are only cheating yourself.


## Getting Started

```sh
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Build
forge build

# Testing
forge test
forge test --match-contract ControlStructures -vvvv

# Adding Deps (GitHub repository)
forge install openzeppelin/openzeppelin-contracts
```

## Deployment

Set the `MNEMONIC` environment variable when deploying.

```sh
forge script script/01_BasicMath.s.sol:DeployBasicMath --broadcast --verify --rpc-url base-goerli
```

See [`scripts`](./script) for more examples.
