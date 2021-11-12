FROM debian:stable-slim as build

ENV \
    ENV=/etc/profile \
    CARDANO_NODE_PATH=~/cardano-node \
    CARDANO_NODE_SOCKET_PATH=$CARDANO_NODE_PATH/node-ipc/testnet/node.socket \
    NETWORK=testnet

WORKDIR /

# Install dependencies
RUN apt-get update && apt-get install -y ca-certificates curl git wget jq \
    && apt clean && apt autoremove -y

# Download cardano-node and cardano-cli executable and configuration files
# https://hydra.iohk.io/job/Cardano/cardano-node/cardano-node-linux/latest-finished
RUN wget -O cardano-node.tar.gz https://hydra.iohk.io/job/Cardano/cardano-node/cardano-node-linux/latest-finished/download \
    && mkdir -p cardano-node db/testnet cardano-node/node-ipc/testnet \
    && tar -xzvf cardano-node.tar.gz --directory ./cardano-node \
    && cp -R ./cardano-node/./ /usr/local/bin \
    && rm cardano-node-1.31.0-linux.tar.gz ./cardano-node/./cardano-cli ./cardano-node/./cardano-node ./cardano-node/./cardano-node-chairman ./cardano-node/./cardano-submit-api ./cardano-node/./cardano-testnet ./cardano-node/./cardano-topology ./cardano-node/./scan-blocks ./cardano-node/./scan-blocks-pipelined ./cardano-node/./chain-sync-client-with-ledger-state ./cardano-node/./ledger-state ./cardano-node/./locli ./cardano-node/./stake-credential-history ./cardano-node/./trace-dispatcher-examples ./cardano-node/./tx-generator

RUN cd ./cardano-node/./ && mkdir -p ./configuration/testnet && cd ./configuration/testnet \
    && wget https://hydra.iohk.io/build/7654130/download/1/testnet-topology.json \
    && wget https://hydra.iohk.io/build/7654130/download/1/testnet-shelley-genesis.json \
    && wget https://hydra.iohk.io/build/7654130/download/1/testnet-config.json \
    && wget https://hydra.iohk.io/build/7654130/download/1/testnet-byron-genesis.json \
    && wget https://hydra.iohk.io/build/7654130/download/1/testnet-alonzo-genesis.json

ENTRYPOINT [ "cardano-node" ]
#RUN bash -c 'cardano-node run --config cardano-node/configuration/testnet/testnet-config.json --topology cardano-node/configuration/testnet/testnet-topology.json'