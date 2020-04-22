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
  
    function spin() public {
    require(bets.length > 0);
    require(now > nextPlayableTimestamp);
    nextPlayableTimestamp = now;

    uint diff = block.difficulty;
    bytes32 hash = blockhash(block.number-1);
    Bet memory lastBet = bets[bets.length-1];
    uint number = uint(keccak256(abi.encodePacked(now, diff, hash, lastBet.betType, lastBet.player, lastBet.number))) % 37;

    for (uint i = 0; i < bets.length; i++) {
      bool win = false;
      Bet memory b = bets[i];
      if (number == 0) {
        win = (b.betType == 2 && b.number == 0);                   /* bet on 0 */
      } else {
        if (b.betType == 2) { 
          win = (b.number == number);                              /* bet on number */
        } else if (b.betType == 1) {
          if (b.number == 0) win = (number % 2 == 0);              /* bet on even */
          if (b.number == 1) win = (number % 2 == 1);              /* bet on odd */
        } else if (b.betType == 0) {
          if (b.number == 0) {                                     /* bet on black */
            if (number <= 10 || (number >= 20 && number <= 28)) {
              win = (number % 2 == 0);
            } else {
              win = (number % 2 == 1);
            }
          } else {                                                 /* bet on red */
            if (number <= 10 || (number >= 20 && number <= 28)) {
              win = (number % 2 == 1);
            } else {
              win = (number % 2 == 0);
            }
          }
        }
      }
      if (win) {
        winnings[b.player] += betPrice * winMultiplicator[b.betType];
      }
    }
    
    bets.length = 0;
    
    minBalance = 0;
    
    emit RandNum(number);
    }
  
   function withdraw() public {
    address payable player = msg.sender;
    uint256 amount = winnings[player];
    require(amount > 0);
    require(amount <= address(this).balance);
    winnings[player] = 0;
    player.transfer(amount);
  }
  
  function destructor() public {
    require(msg.sender == owner);
    selfdestruct(owner);
  }
  
}
