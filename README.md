# Cardano Freaks

Foobar is a Python library for dealing with word pluralization.

## Usage & Instalation

! Disclaimer : this is for tests & development only !
 - Guide: https://github.com/input-output-hk/plutus-apps/tree/main/plutus-pab/test-node

There are two versions v0.1 & v0.2. 
- v0.1 contains only the base image + cardano-node & cardano-wallet, without the nix packages, those will install after starting the container.
- v0.2 contains everything that v0.1 has + nix packages, follow the steps to set-up the container.

Steps:
1. `docker run --it <IMAGE>`
2. *Patience, nix-shell will download and install all the packages
3. `cabal update`
4. `cabal build plutus-pab-examples plutus-chain-index cardano-node cardano-wallet`
5. `cd plutus-pab/test-node/ ` & Start the node: `./start-testnet-node.sh`
6. Start the wallet: `cabal exec -- cardano-wallet serve \
    --testnet testnet/testnet-byron-genesis.json \
    --node-socket testnet/node.sock
    --port 8090
    --listen-address 0.0.0.0`
7. Wait for node to sync
8. Create or recover a wallet
9. Start the chain index: `cabal exec -- plutus-chain-index --config testnet/chain-index-config.json start-index`
10. Start the PAB: `cabal exec -- plutus-pab-examples \
  --config testnet/pab-config.yml migrate`
*Only for v0.1

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
