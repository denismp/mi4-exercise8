const Casino = artifacts.require("Casino");

module.exports = function(deployer) {
  //deployer.deploy(Casino(1,10),web3.utils.toWei('0.1','ether'),100,{gas: 3000000});
  deployer.deploy(Casino,1,10,{gas:3000000});
};
