pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
//import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
// import ./HomeContract.sol;

contract StakingPool {

  //current revenue index
  // map of address to revenue index at last touch
  // user BalanceMap will be stored in the ERC-20 token contract but needs to be readable here
  //mapping(address => mapping(address => uint)) public stakedBalanceMap; // token -> user -> amount can I get away with just keeping this on the Dapp token?
  mapping(address => uint256) public balance;
  //mapping(address => uint) public userBalanceIndexMap;
  //uint public reserveNormalizedIncome;
  uint public totalLiquidity;
  AggregatorV3Interface internal priceFeed;
  //uint public totalBorrowed;
  //uint public lastTimestamp;
  //uint constant secondsInYear = 31536000;
  //uint public interestRate;
  //address[] constant allowedTokens = [0x7079f3762805cff9c979a5bdc6f5648bcfee76c8,0x1484a6020a0f08400f6f56715016d2c80e26cdc1]; //USDC & USDT token addresses on Kovan testnet

  constructor() {
    // what should we do on deploy?
    /*
       Network: Kovan
       Aggregator: ETH/USD
       Address: 0x9326BFA02ADD2366b30bacB125260Af641031331
    */
    priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331); //Kovan Testnet ETH/USD Smart Contract Data Feed
  }

  receive() external payable { stake(); }

  function stake() payable public {
      balance[msg.sender] += msg.value;
      //require(amount > 0, "Amount cannot be 0!");
      //require(tokenIsAllowed(token), "Token is not allowed!")
      //IERC20(token).transferFrom(msg.sender, address(this), amount);
      //stakedBalanceMap[token][msg.sender] = stakedBalanceMap[token][msg.sender] + amount;
      totalLiquidity = totalLiquidity + msg.value;
      //updateIncomeIndex();
  }
//what if the withdraw amount is more than the available liquidity?
  function unstake(uint amount) public {
      require(balance[msg.sender] > 0, "You haven't deposited anything yet!");
      require(balance[msg.sender] - amount > 0, "You can't withdraw more than you've deposited!");
      balance[msg.sender] -= amount;
      payable(msg.sender).transfer(amount);
      //require(amount > 0, "Amount cannot be 0!");
      //require(stakedBalanceMap[token][msg.sender] - amount > 0, "Cannot withdraw more than you deposited!");
      //require(tokenIsAllowed(token), "Token is not offered as a valid withdraw.")
      //IERC20(token).transferFrom(address(this), msg.sender, amount);
      //stakedBalanceMap[token][msg.sender] = stakedBalanceMap[token][msg.sender] - amount;
      totalLiquidity = totalLiquidity - amount;
      //updateIncomeIndex();
  }

  function sellHomeToContract(uint256 deedId, uint askingPriceUSD) public {
      require(IERC721(propertydeed_address).ownerOf(deedId) == msg.sender, "You are not the owner of that home!");
      //fairSalePrice = Query ZillowAPI via Chainlink Oracle using deedId Info
      //require(fairSalePrice >= amount, "Amount requested is higher than estimate");
      (uint80 roundID, int ethPriceInUSD, uint startedAt, uint timestamp, uint80 answeredInRound) = priceFeed.latestRoundData();
      require(totalLiquidity-totalBorrowed >= askingPrice/ethPriceInUSD, "Sorry! Not enough funds to purchase home!")
      IERC721(propertydeed_address).safeTransferFrom(msg.sender, address(this), deedId)
      payable(msg.sender).transfer(amount/ethPriceInUSD)
      totalBorrowed += amount/ethPriceInUSD;
      //HomeContract(Walt_address).addProperty(deedId, vesting_period, monthlyRent);
  }

  //function addRentToPool(uint principle, uint interest) public {
      //totalBorrowed -= principle;
  
  }

  //function closeOutHome() public {
  //    totalBorrowed -= 380,000
  //}
  //function addAppreciationToPool() public {
  // 
  //}


      //TODO setup Walt's 
      //TODO calculate monthly rent for 


      //require(homeNFT == 0x00000000000000000000000000000000000000000000, "Not a homeNFT") //need to update with the smart contract address for the homeNFTs
      //require(amount < totalLiquidity - totalBorrowed, "Not enough funds to purchase home")
      //IERC721(token).transferFrom(msg.sender, address(this), homeId
  

//  function updateIncomeIndex() public {
//      utilizationRate = totalBorrowed/totalLiquidity;
//      liquidityRate = interestRate * utilizationRate;
//      deltaTYear = (block.timestamp - lastTimestamp)/secondsInYear
//      reserveNormalizedIncome = reserveNormalizedIncome*(liquidityRate*deltaTYear + 1);
//  }
 
//  function tokenIsAllowed(address memory token) public returns (bool) {
//      for(uint256 allowedTokensIndex = 0; allowedTokensIndex < allowedTokens.length; allowedTokensIndex++) {
//          if(allowedTokens[allowedTokensIndex] == token){
//              return true;
//          }
//      }
//      return false;
//  }

}
