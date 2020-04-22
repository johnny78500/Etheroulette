pragma solidity ^0.5.16;

contract EthRoulette {

  address payable owner;
  uint8[] winMultiplicator;
  uint8[] betTypeRange;
  uint betPrice;
  uint minBalance;
  uint nextPlayableTimestamp;
  mapping (address => uint256) winnings;
  
  struct Bet {
    address player;
    uint8 betType;
    uint8 number; 
  }
  
  event RandNum(uint256 number);
  
  Bet[] public bets;
  
  constructor() public payable {
    owner = msg.sender;
    nextPlayableTimestamp = now;
    minBalance = 0;
    winMultiplicator = [2,3,36];
    betTypeRange = [1,1,36];
    betPrice = 10000000000000000; /* 0.01 ether */
  }
  
  function addEther() payable public {}
  
  function getInfo() public view returns(uint, uint, uint, uint, uint) {
    return (
      bets.length,             // number of active bets
      bets.length * betPrice, // value of active bets
      nextPlayableTimestamp,      // when can we play again
      address(this).balance,   // roulette balance
      winnings[msg.sender]     // winnings of player
    ); 
  }
  
  function bet(uint8 number, uint8 betType) payable public {
    require(msg.value == betPrice);                           
    require(betType >= 0 && betType <= 2);                   
    require(number >= 0 && number <= betTypeRange[betType]); 
    uint possibleWinnings = winMultiplicator[betType] * msg.value;
    uint neededBalance = minBalance + possibleWinnings;
    require(neededBalance < address(this).balance);
    minBalance += possibleWinnings;
    bets.push(Bet({
      betType: betType,
      player: msg.sender,
      number: number
    }));
  }
  
}
