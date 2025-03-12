# MerkleStore Deployment
The repo houses sample merkle store contract for Sui ecosystem and steps on how to deploy it from scratch.


## How To

### Installation
The first order of business is to install sui-cli. There are multiple ways to do it, you can build it from source but the easiest approach is to use `homebrew`
- Install brew if you don't have already using `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- Check if you already have sui cli installed using `sui -V`. If not, install it using `bew install sui`. Run `sui -V` again and you should see the version of sui installed `sui 1.xx.x-homebrew`.

### Environment Setup
Next we need to decide, on which chain of Sui we want to deploy our merkle store contract to. By default sui-cli when installed has a single environment `testnet` in its configuration but you can add an environment of your choice following these steps:

- Add the environment (chain local/testnet/mainnet) to which you want to deploy the token. This can be done using `sui client new-env --alias <ALIAS> --rpc <RPC>`. For testnet do `sui client new-env --alias testnet --rpc https://fullnode.testnet.sui.io:443`. Make sure the alias `testnet` in this example being used is unique and not already existing else you will run into `Environment config with name [testnet] already exists.` error. If you want to know which environments are available run `sui client envs`
- Switch cli to the environment we created in the previous step using `sui client switch --env <ENV-ALIAS>`. For the previously created `testnet` env do `sui client switch --env testnet`

### Deployment wallet
We need to setup an account/wallet that will be used to deploy the merkle store. This account needs to be funded with SUI tokens to pay for contract deployment gas fee.
- To create a wallet using cli run `sui client new-address <KEY_SCHEME>`. You can chose `secp256k1` or `ED25519` as wallet scheme. The created wallet is stored in sui configs as well as outputted to console. You don't need to save any of the wallet details like its phrase or address as this can be retrieve from sui-cli at any point in time. 
    ```
    $ sui client new-address secp256k1
    ╭─────────────────────────────────────────────────────────────────────────────────────────────────╮
    │ Created new keypair and saved it to keystore.                                                   │
    ├────────────────┬────────────────────────────────────────────────────────────────────────────────┤
    │ alias          │ heuristic-alexandrite                                                          │
    │ address        │ 0x7945bac9edeb5751c29573cebb36b738309d7b857402a1ec42f15bc6acecdf6f             │
    │ keyScheme      │ secp256k1                                                                      │
    │ recoveryPhrase │ forget ### ###### ####### ### #### #### #### #### ####### #### ###             |
    ╰────────────────┴────────────────────────────────────────────────────────────────────────────────╯
    ```
- Next up, you need to make the wallet you want to use for deployment of the merkle store as the active wallet address on sui-cli. You may have multiple wallets on sui-cli, the one you want to use for deployment, should bet set as active. This can be done using `sui client switch --address <address>`
    ```
    $ sui client switch --address 0x7945bac9edeb5751c29573cebb36b738309d7b857402a1ec42f15bc6acecdf6f

    Active address switched to 0x7945bac9edeb5751c29573cebb36b738309d7b857402a1ec42f15bc6acecdf6f
    ```
- Before you can use the active wallet for performing any transactions like deploying the merkle store contract, you must have it funded with SUI tokens to pay for gas fee. For testnet/localnet, you can use the sui cli faucet to fund the account. To use faucet run:  `sui client faucet --help --address <address>`
    ```
    $ sui client faucet --address 0x7945bac9edeb5751c29573cebb36b738309d7b857402a1ec42f15bc6acecdf6f 

    Request successful. It can take up to 1 minute to get the merkle store. Run sui client gas to check your gas merkle stores.
    ```

### Building the contract
The merkle store contract is written in Move language. To build the contract, navigate to the directory containing the `Move.toml` and `sources/` of the contract. Once at the right path, you can build the contract using `sui move build`.

### Deployment
In order to deploy the merkle contract first navigate to the directory containing the `Move.toml` and `sources/` of the contract. Once at the right path, you can publish the contract to Sui chain using `sui client publish --json`. The `--json` is optional but it returns the output of a transaction in json