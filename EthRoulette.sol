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
  
  Bet[] public bets;
  
  constructor() public payable {
    owner = msg.sender;
    nextPlayableTimestamp = now;
    minBalance = 0;
    winMultiplicator = [2,3,36];
    betTypeRange = [1,1,36];
    betPrice = 10000000000000000; /* 0.01 ether */
  }
  
}
