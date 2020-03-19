pragma solidity >=0.4.0 <0.7.0;
import "../installed_contracts/oraclize-api/contracts/usingOraclize.sol";

contract Casino is usingOraclize {
    address private owner;
    uint private minimumBet;
    uint private numberOfBets;
    uint private maxNumberOfBets;
    uint private totalBet;
    uint constant LIMIT_AMOUNT_BETS = 10;
    uint private numberWinner;
    mapping(address => uint) private playerBetsNumber;
    mapping(uint => address[]) private numberBetPlayers;

    function Casino(uint _minimumBet, uint _maxNumberOfBets) public {
        owner = msg.sender;

        numberOfBets = 0;
        totalBet = 0;
        if (_minimumBet > 0) {
            minimumBet = _minimumBet;
        }

        if (_maxNumberOfBets > 0 && _maxNumberOfBets <= LIMIT_AMOUNT_BETS) {
            maxNumberOfBets = _maxNumberOfBets;
        }
        oraclize_setProof(proofType_Ledger);
    }

    function bet(uint numberToBet) payable public {
        assert(numberOfBets < maxNumberOfBets);
        assert(checkPlayerExists(msg.sender) == false);
        assert(numberToBet >= 1 && numberToBet <= 10);
        assert(msg.value >= minimumBet);

        playerBetsNumber[msg.sender] = numberToBet;

        numberBetPlayers[numberToBet].push(msg.sender);

        numberOfBets += 1;
        totalBet += msg.value;

        if (numberOfBets >= maxNumberOfBets) {
            generateNumberWinner();
        }
    }

    function checkPlayerExists(address player) public view returns (bool) {
       return playerBetsNumber[player] > 0;
    }

    modifier onEndGame() {
        require(numberOfBets <=  maxNumberOfBets);
        _;
    }

    function generateNumberWinner() payable onEndGame public {
        uint numberRandomBytes = 7;
        uint delay = 0;
        uint callbackGas = 200000;

        bytes32 queryId = oraclize_newRandomDSQuery(delay, numberRandomBytes, callbackGas);
        queryId; // gets rid of the compiler warning about unused variable.
    }

    function __callback(bytes32 _queryId, string _result, bytes _proof) oraclize_randomDS_proofVerify(_queryId, _result, _proof) onEndGame public {
        // Checks that the sender of this callback was in fact oraclize
        assert(msg.sender == oraclize_cbAddress());

        numberWinner = (uint(keccak256(_result)) % 10 + 1);
        distributePrizes();
    }

    function distributePrizes() onEndGame public {
       uint winnerEtherAmount = totalBet / numberBetPlayers[numberWinner].length; // How much each winner gets

       // Loop through all the winners to send the corresponding prize for each one
       for (uint i = 0; i < numberBetPlayers[numberWinner].length; i++) {
           numberBetPlayers[numberWinner][i].transfer(winnerEtherAmount);
       }

       // Delete all the players for each number
       for (uint j = 1; j <= 10; j++) {
           numberBetPlayers[j].length = 0;
       }

       totalBet = 0;
       numberOfBets = 0;
    }
}