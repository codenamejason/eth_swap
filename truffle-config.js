require('babel-register');
require('babel-polyfill');
//const { projectId, mnemonic } = require('./secrets.json');
const HDWalletProvider = require('@truffle/hdwallet-provider');
const mnemonic = 'concert valve dose hollow transfer only device offer insect valley slim anger';

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    rinkeby: {
      provider: () => new HDWalletProvider(
        mnemonic, `{rinkeby.infura.io/v3/4a3706ac2ddf434fbc3ca2e68a746382}`
      ),
      networkId: 4,
      gasPrice: 10e9
    }
  },
  contracts_directory: './src/contracts/',
  contracts_build_directory: './src/abis/',
  compilers: {
    solc: {
      optimizer: {
        enabled: true,
        runs: 200
      },
      evmVersion: "petersburg"
    }
  }
}
