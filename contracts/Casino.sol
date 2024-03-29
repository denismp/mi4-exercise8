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
    mapping(address => bool) private activePlayers;

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

        //OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
        //OAR = OraclizeAddrResolverI(0x3dCB1BeeD059bc733192E7b9a62AF4C62836d3da);
        //OAR = OraclizeAddrResolverI(0x5F930eEf71cDe47400ff5b3CebF714E031d8D302);
        oraclize_setProof(proofType_Ledger);
        //oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
    }

    function bet(uint numberToBet) payable public {
        assert(numberOfBets < maxNumberOfBets);
        assert(checkPlayerExists(msg.sender) == false);
        assert(numberToBet >= 1 && numberToBet <= 10);
        assert(msg.value >= minimumBet);

        playerBetsNumber[msg.sender] = numberToBet;
        activePlayers[msg.sender] = true;

        numberBetPlayers[numberToBet].push(msg.sender);

        numberOfBets += 1;
        totalBet += msg.value;

        if (numberOfBets >= maxNumberOfBets) {
            generateNumberWinner();
        }
    }

    function checkPlayerExists(address player) public view returns (bool) {
       return activePlayers[player];
    }

    modifier onEndGame() {
        require(numberOfBets <=  maxNumberOfBets);
        _;
    }

    event GenerateNumberWinner(bytes32 queryId);
    function generateNumberWinner() payable onEndGame public {
        uint numberRandomBytes = 7;
        uint delay = 0;
        uint callbackGas = 400000;

        bytes32 queryId = oraclize_newRandomDSQuery(delay, numberRandomBytes, callbackGas);
        GenerateNumberWinner(queryId);
        queryId; // gets rid of the compiler warning about unused variable.
    }

    event CallbackEvent(bytes32 _queryId, string _result, bytes _proof);
    event Winner(uint numberWinner);
    function __callback(bytes32 _queryId, string _result, bytes _proof) oraclize_randomDS_proofVerify(_queryId, _result, _proof) onEndGame public {
        // Checks that the sender of this callback was in fact oraclize
        CallbackEvent(_queryId, _result,_proof);
        assert(msg.sender == oraclize_cbAddress());

        numberWinner = (uint(keccak256(_result)) % 10 + 1);
        Winner(numberWinner);

        distributePrizes();
    }
    // function __callback(bytes32 _queryId, string _result, bytes _proof) onEndGame public {
    //     // Checks that the sender of this callback was in fact oraclize
    //     assert(msg.sender == oraclize_cbAddress());

    //     numberWinner = (uint(keccak256(_result)) % 10 + 1);
    //     distributePrizes();
    // }

    function distributePrizes() onEndGame public {
        uint winnerEtherAmount = 0;
        if(numberBetPlayers[numberWinner].length > 0) {
            winnerEtherAmount = totalBet / numberBetPlayers[numberWinner].length; // How much each winner gets
        }
        //uint winnerEtherAmount = totalBet / numberBetPlayers[numberWinner].length; // How much each winner gets

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