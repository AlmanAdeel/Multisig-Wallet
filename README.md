## A BRIEF DESCRIPTION ON MULTISIG WALLET


## What is a multisig wallet ?
A multi-signature (MultiSig) wallet is a type of cryptocurrency wallet that requires multiple private keys to authorize a transaction instead of just one. It enhances security by preventing a single point of failure

## What does it do ?
Prevents unauthorized access – No single person can move funds without approval from others.
Enhances security – Even if one private key is compromised, the wallet remains secure.
Supports shared ownership – Ideal for DAOs, businesses, and joint accounts where multiple parties must agree before making transactions.

## How does it work ?
Wallet Creation – A MultiSig wallet is set up with multiple owners (e.g., 3-of-5 setup means 3 out of 5 keys must sign a transaction).
Transaction Proposal – A transaction is created but remains pending until enough owners approve it.
Approval Process – Owners sign the transaction using their private keys.
Execution – Once the required number of signatures is met, the transaction is executed on the blockchain.


## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
