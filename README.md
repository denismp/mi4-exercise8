# mi4-exercise8
Create Simple Casino with Solidity, Truffle, MetaMask, Oraclize and IPFS

Exercises: Create Simple Casino with Solidity, Truffle, MetaMask, Oraclize and IPFS
We are going to create a decentralized casino application where users are able to bet money for a number between 1 and 10 and if they are correct, they win a portion of all the ether money staked after 100 total bets.
Oraclize is the leading oracle service for smart contracts and blockchain applications, serving thousands of requests for day every day on Ethereum, Bitcoin (Rootstock). In the blockchain space, an oracle is a party, which provides real world data. The need for such figure arise from the fact that blockchain applications, such as Bitcoin scripts and smart contracts cannot access and fetch directly the data they require: price feeds for assets and financial applications; weather-related information for peer-to-peer insurance; random number generation for gambling. 
 
Problem 1.	Setup the Project
1.	Create a folder called Simple-Casino and inside open command line and execute the command: npm init 
2.	After that:
npm i –D truffle
to install the contract’s framework truffle in this project as a developing dependency
3.	Then execute:
truffle init
This will start the project.
4.	Then:
npm i -D webpack react react-dom babel-core babel-loader babel-preset-react babel-preset-es2015 babel-preset-stage-2 css-loader style-loader json-loader web3
 
5.	After you finished downloading the node modules, go to your project folder and create a webpack.config.js file. This is the file that will combine all of our JavaScript files and css to create a single file build.js that will hold all the JavaScript code in one place and paste the following code in it:
webpack.config.js
const path = require('path')

module.exports = {
    entry: path.join(__dirname, 'src/js', 'index.js'), // Our frontend will be inside the src folder
    output: {
        path: path.join(__dirname, 'dist'),
        filename: 'build.js' // The final file will be created in dist/build.js
    },
    module: {
        loaders: [{
            test: /\.css$/, // To load the css in react
            use: ['style-loader', 'css-loader'],
            include: /src/
        }, {
            test: /\.jsx?$/, // To load the js and jsx files
            loader: 'babel-loader',
            exclude: /node_modules/,
            query: {
                presets: ['es2015', 'react', 'stage-2']
            }
        }, {
            test: /\.json$/, // To load the json files
            loader: 'json-loader'
        }]
    }
}

 
6.	Create the folder src/ in the project and inside that folder, create the folders js/ and inside it create index.js and css/ and inside it create index.css to organize the source code
index.js
import React from 'react'
import ReactDOM from 'react-dom'
import Web3 from 'web3'
import './../css/index.css'

class App extends React.Component {
   constructor(props){
      super(props)
      this.state = {
         lastWinner: 0,
         numberOfBets: 0,
         minimumBet: 0,
         totalBet: 0,
         maxAmountOfBets: 0,
      }

      if(typeof web3 != 'undefined'){
         console.log("Using web3 detected from external source like Metamask")
         this.web3 = new Web3(web3.currentProvider)
      }else{
         console.log("No web3 detected. Falling back to http://localhost:8545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
         this.web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"))
      }

      const MyContract = web3.eth.contract([{"constant":false,"inputs":[],"name":"generateNumberWinner","outputs":[],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"myid","type":"bytes32"},{"name":"result","type":"string"}],"name":"__callback","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"numberOfBets","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_queryId","type":"bytes32"},{"name":"_result","type":"string"},{"name":"_proof","type":"bytes"}],"name":"__callback","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"player","type":"address"}],"name":"checkPlayerExists","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"resetData","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"bets","type":"uint256"}],"name":"updateMaxBets","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"number","type":"uint256"}],"name":"bet","outputs":[],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"amountWei","type":"uint256"}],"name":"updateMinimumBet","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"distributePrizes","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"numberWinner","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"minimumBet","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"maxAmountOfBets","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"players","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalBet","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[{"name":"_maxAmountOfBets","type":"uint256"}],"payable":false,"type":"constructor"},{"payable":true,"type":"fallback"}])
      this.state.ContractInstance = MyContract.at("0x430d959fa54714aca8eecd61fae2661fca900e04")

      window.a = this.state
   }

   componentDidMount(){
      this.updateState()
      this.setupListeners()

      setInterval(this.updateState.bind(this), 7e3)
   }

   updateState(){
      this.state.ContractInstance.minimumBet((err, result) => {
         if(result != null){
            this.setState({
               minimumBet: parseFloat(web3.fromWei(result, 'ether'))
            })
         }
      })
      this.state.ContractInstance.totalBet((err, result) => {
         if(result != null){
            this.setState({
               totalBet: parseFloat(web3.fromWei(result, 'ether'))
            })
         }
      })
      this.state.ContractInstance.numberOfBets((err, result) => {
         if(result != null){
            this.setState({
               numberOfBets: parseInt(result)
            })
         }
      })
      this.state.ContractInstance.maxAmountOfBets((err, result) => {
         if(result != null){
            this.setState({
               maxAmountOfBets: parseInt(result)
            })
         }
      })
   }

   // Listen for events and executes the voteNumber method
   setupListeners(){
      let liNodes = this.refs.numbers.querySelectorAll('li')
      liNodes.forEach(number => {
         number.addEventListener('click', event => {
            event.target.className = 'number-selected'
            this.voteNumber(parseInt(event.target.innerHTML), done => {

               // Remove the other number selected
               for(let i = 0; i < liNodes.length; i++){
                  liNodes[i].className = ''
               }
            })
         })
      })
   }

   voteNumber(number, cb){
      let bet = this.refs['ether-bet'].value

      if(!bet) bet = 0.1

      if(parseFloat(bet) < this.state.minimumBet){
         alert('You must bet more than the minimum')
         cb()
      } else {
         this.state.ContractInstance.bet(number, {
            gas: 300000,
            from: web3.eth.accounts[0],
            value: web3.toWei(bet, 'ether')
         }, (err, result) => {
            cb()
         })
      }
   }

   render(){
      return (
         <div className="main-container">
            <h1>Bet for your best number and win huge amounts of Ether</h1>

            <div className="block">
               <b>Number of bets:</b> &nbsp;
               <span>{this.state.numberOfBets}</span>
            </div>

            <div className="block">
               <b>Last number winner:</b> &nbsp;
               <span>{this.state.lastWinner}</span>
            </div>

            <div className="block">
               <b>Total ether bet:</b> &nbsp;
               <span>{this.state.totalBet} ether</span>
            </div>

            <div className="block">
               <b>Minimum bet:</b> &nbsp;
               <span>{this.state.minimumBet} ether</span>
            </div>

            <div className="block">
               <b>Max amount of bets:</b> &nbsp;
               <span>{this.state.maxAmountOfBets}</span>
            </div>

            <hr/>

            <h2>Vote for the next number</h2>

            <label>
               <b>How much Ether do you want to bet? <input className="bet-input" ref="ether-bet" type="number" placeholder={this.state.minimumBet}/></b> ether
               <br/>
            </label>

            <ul ref="numbers">
               <li>1</li>
               <li>2</li>
               <li>3</li>
               <li>4</li>
               <li>5</li>
               <li>6</li>
               <li>7</li>
               <li>8</li>
               <li>9</li>
               <li>10</li>
            </ul>

            <hr/>

            <div><i>Only working with the Ropsten Test Network</i></div>
            <div><i>You can only vote once per account</i></div>
            <div><i>Your vote will be reflected when the next block is mined</i></div>
         </div>
      )
   }
}

ReactDOM.render(
   <App />,
   document.querySelector('#root')
)


7.	index.css
index.css
body{
    font-family: 'open sans';
    margin: 0;
}
ul{
    list-style-type: none;
    padding-left: 0;
    display: flex;
    justify-content: space-around;
    max-width: 1300px;
}
li{
    padding: 40px;
    border: 2px solid rgb(30,134,255);
    margin-right: 5px;
    border-radius: 10px;
    cursor: pointer;
}
li:hover{
    background-color: rgb(30,134,255);
    color: white;
}
li:active{
    opacity: 0.7;
}
*{
    color: #444444;
}
.main-container{
    padding: 20px;
}
.block{
    display: flex;
    align-items: center;
}
.number-selected{
    background-color: rgb(30,134,255);
    color: white;
}
.bet-input{
    padding: 15px;
    border-radius: 10px;
    border: 1px solid lightgrey;
    font-size: 15pt;
    margin: 0 10px;
}

@media (max-width: 1100px){
    ul{
        flex-direction: column;
    }
    li{
        margin: 5px 0;
    }
}

8.	Finally create folder dist/ in the root folder and in this folder create index.html and paste the following code in it:
index.html
<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <link href='https://fonts.googleapis.com/css?family=Open+Sans:400,700' rel='stylesheet' type='text/css'>
   <title>Casino Ethereum DApp</title>
</head>
<body>
   <div id="root"></div>

   <script src="build.js"></script>
</body>
</html>

9.	The <div id="root"></div> is where the react code will be inserted and the <script src="build.js"></script> to include the build file generated by webpack.
Problem 2.	Create Smart Contracts
1.	Create the file contracts/Casino.sol, this is the main Solidity contract that we will be writing
2.	We will use oracalizeAPI so we should install it in our project. Go to contracts/ folder and run the following command:
truffle install oraclize-api
3.	A new folder will appear in the casino directory, named “installed_contracts”. We should import usingOraclize contract in our Casino contract. The Casino contract will inherit the usingOraclize contract. Casino contract will have:
•	address of the owner
•	minimum bet (default 0.1 ether) – minimum bet a user has to make
•	total bet – total amount of Ether bet for this current game
•	number of bets  – how many bets the users have made
•	maximum bets (default 10 ether)– maximum amount of bets can be made for each game
•	limit amount bets (100)– max amount of bets that cannot be exceeded to avoid excessive gas consumption 
•	number winner – number that won the last game
•	array of all the players
•	structure, storing for each number the players who bet on it
•	structure, storing each player’s number he bet on
•	function modifier, allowing the execution of functions when the bets are completed

4.	Go to the migrations/ folder and create the file 2_deploy_contracts.js and write the code below which 
•	First, we require the Casino.sol contract.
•	Then, in the .deploy() method we specify the minimum bet, in this case it’s 0.1 ether converted to wei with that function
•	100 is the max amount of players
•	Finally the gas limit that we are willing to use to deploy the contract
 
5.	Open truffle.js from the root folder and customize your Truffle configuration
 
6.	Now create the constructor that is used to configure the minimum bet per game and the max amount of bets. The minimum bet that each user has to make in order to participate in the game. The max amount of bets that are required for each game:
 
7.	Set the proof of oraclize in order to make secure random number generations in the constructor:
 
 
8.	We should create bet function:
 
9.	We have the checkPlayerExists(address) function, which checks if the player exists in the game.
10.	We should generate winner number by using oraclize function oraclize_newRandomDSQuery which takes delay, numberRandomBytes and callbackGas:
 
11.	We should create a callback function which gets called by oraclize when the random number is generated, it gets the _queryId that was generated to proofVerify, the _result string that contains the number generated and _proof string with a proof code to verify the authenticity of the number generation
 
 
12.	Finally, we should create the function to send the corresponding Ether to each winner then deletes all the players for the next game and resets the total bet and number of bets:
 
Problem 3.	Deploy the application online with IPFS
1.	First install webpack to generate the build.js file which will contain all the js, css and html files.
2.	Install webpack by npm install -g webpack
npm install –g webpack
 Go to the directory casino/ and then run:
webpack
3.	Open another command line and run: 
testrpc
4.	Then go to the src/ folder and 
truffle compile
and then:
truffle migrate
to compile and migrate the contracts.
5.	Go to https://dist.ipfs.io/#go-ipfs  and download the go-ipfs then extract it
6.	Either add ipfs as a path variable or go to the ipfs folder and run in Command Prompt ipfs init 
7.	Open command line and type ipfs daemon and this will create node
8.	Then open another command line and type:
ipfs swarm peers
This will get you peers that will share your content.
9.	Get the path of your dist/ folder and run the command:
ipfs add –r <dist_folder_location>
This will add your folder to the network. You will see a long hash, which has been generated for you.
10.	Copy the last hash. For example “QmUCjkUigBFw4RuTLwUajvQ5q8QMqmFHpmAiTBhLVosEcR”:
 
11.	Run the following command: 
ipfs name publish <hash_of_dir_folder>

 
12.	Open the following link. For example: https://gateway.ipfs.io/ipfs/QmUCjkUigBFw4RuTLwUajvQ5q8QMqmFHpmAiTBhLVosEcR 
13.	If you make changes to your files remember to execute webpack then ipfs add –r <your_location> and ipfs name publish <hash_of_dir_folder>. The publish name hash is always the same:
14.	Play with the Dapp.
15.	The app should look like this go and play with it:
 

What to Submit?
Submit as exercise outcome the .txt file with the URL after it is uploaded to ipfs.
Example: https://gateway.ipfs.io/ipfs/QmUCjkUigBFw4RuTLwUajvQ5q8QMqmFHpmAiTBhLVosEcR


NOTES:
git clone https://github.com/oraclize/ethereum-bridge.git
cd ethereum-bridge
npm install

sudo npm install ethereum-bridge -g

then I ran 

cd mi4-exercise8
ethereum-bridge -H localhost:8545 -a 1

Follow the instructions of the output.
Please add this line to your contract constructor:

OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);

NOTE: 03/22/2020
Forget the previous NOTE.

1. Make sure you are running v10.14.2 of node.  Nvm is a node version manager.  All of this is important to get webpack to work.
   0. Go to https://github.com/nvm-sh/nvm/blob/master/README.md
   1. Install nvm:
      a. curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
      b. nvm ls-remote -- this will list all available versions of node
      c. nvm install 10.14.2
      d. nvm use 10
      e. In your project root directory run "npm install" to update your package.json file.

2. /Users/denisputnam/git/mi4-exercise8>npm install @truffle/hdwallet-provider
3. /Users/denisputnam/git/mi4-exercise8>truffle migrate --network ropsten
4. run webpack in the project root directory

5. ipfs init  // only once
6. in a separate window run ipfs daemon
7. ipfs swarm peers // only once
8. ipfs add --recursive "full path to dist"
9. ipfs name publish Qme1iY4Zayn5RRYPvuaLskZ5mGQZq5MEn66j3dY1SmjSqg // hash is the dist one