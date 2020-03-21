const Casino = artifacts.require("Casino");

module.exports = function(deployer) {
  //deployer.deploy(web3.toWei('0.1','ether'),100,{gas: 3000000});
  //deployer.deploy(Casino,1,10,{gas:3000000});
  const minimumBet = "0.1";
  const maxNumberOfBets = "2"
  const minumumBetEthers = web3.utils.toWei(minimumBet,"ether");

  deployer.deploy(Casino,minumumBetEthers,maxNumberOfBets,{gas: 5000000});
};
