/**
 * More information about configuration can be found at:
 *
 * truffleframework.com/docs/advanced/configuration
 *
 */

const HDWalletProvider = require("@truffle/hdwallet-provider");

const INFURA_KEY = "7d4a1308aa2d4a5bbc448aabb6433e57";  // REPLACE WITH YOUR OWN KEY This is a Node Address from infuia.io project creation!!!
const MNEMONIC = "orbit journey pond cheap fly paper volume march expand town frown arm";  // REPLACE WITH YOUR OWN MNEMONIC from BIP39 generate

module.exports = {
  /**
   * The default output directory for compiled contracts is ./build/contracts relative to the project root.
   * This can be changed with the contracts_build_directory key.
   */
  contracts_build_directory: "./src/contracts",
  
  /**
   * Networks define how you connect to your ethereum client and let you set the
   * defaults web3 uses to send transactions.
   * $ truffle migrate --network ropsten
   */

  networks: {
    ropsten: {
      provider: () =>
        new HDWalletProvider(
          MNEMONIC,
          `https://ropsten.infura.io/v3/${INFURA_KEY}`
        ),
      network_id: 3, // Ropsten's id
      gas: 5500000, // Ropsten has a lower block limit than mainnet
      confirmations: 0, // # of confs to wait between deployments. (default: 0)
      timeoutBlocks: 200, // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true, // Skip dry run before migrations? (default: false for public nets )
      networkCheckTimeout: 10000
    },
  },
  // Configure your compilers
  compilers: {
    solc: {
      version: "0.4.18" // Fetch exact version from solc-bin (default: truffle's version)
    }
  }
};