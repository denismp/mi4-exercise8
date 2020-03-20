const Casino = artifacts.require("Casino");

module.exports = function(deployer) {
  //deployer.deploy(web3.utils.toWei('0.1','ether'),100,{gas: 3000000});
  //deployer.deploy(Casino,1,10,{gas:3000000});
  const minimumBet = "0.1";
  const maxNumberOfPlayers = "2"
  const minumumBetEthers = web3.utils.toWei(minimumBet,"ether");

  deployer.deploy(Casino,minumumBetEthers,maxNumberOfPlayers,{gas: 5000000});
};
