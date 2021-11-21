pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

//import "hardhat/console.sol";
//import "./NostraERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
//import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
// import ./HomeContract.sol;

contract StakingPool {

  //current revenue index
  // map of address to revenue index at last touch
  // user BalanceMap will be stored in the ERC-20 token contract but needs to be readable here
  //mapping(address => mapping(address => uint)) public stakedBalanceMap; // token -> user -> amount can I get away with just keeping this on the Dapp token?
  //mapping(address => uint) public userBalanceIndexMap;
  //uint public reserveNormalizedIncome;
  uint public totalLiquidity;
  address internal USDTAddress = 0xD92E713d051C37EbB2561803a3b5FBAbc4962431;
  address public nostraERC20Address;
  uint public totalBorrowed;
  //mapping(address => uint) public balance;
  //AggregatorV3Interface internal priceFeed;
  //uint public lastTimestamp;
  //uint constant secondsInYear = 31536000;
  //uint public interestRate;
  //address[] constant allowedTokens = [0x7079f3762805cff9c979a5bdc6f5648bcfee76c8,0x1484a6020a0f08400f6f56715016d2c80e26cdc1]; //USDC & USDT token addresses on Kovan testnet

//  constructor() {
    // what should we do on deploy?
    /*
       Network: Kovan
       Aggregator: ETH/USD
       Address: 0x9326BFA02ADD2366b30bacB125260Af641031331
    */
    //priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331); //Kovan Testnet ETH/USD Smart Contract Data Feed
 // }

  //receive() external payable { stake(); }

  function setDappToken(address token) public {
      nostraERC20Address = token;
      //priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331); //Kovan Testnet ETH/USD Smart Contract Data Feed
  }

  function stake(uint amount) payable public {
      require(IERC20(USDTAddress).balanceOf(msg.sender) >= amount, "Not enough funds!"); // Using Testnet TUSDT address, to be updated if put on mainnet
      uint dappTokensToMint = amount/50;
      IERC20(USDTAddress).transferFrom(msg.sender, address(this), amount);
      //NostraERC20(nostraERC20Address).mint(msg.sender, dappTokensToMint);
      totalLiquidity = totalLiquidity + amount;
      //balance[msg.sender] += amount;
      //require(amount > 0, "Amount cannot be 0!");
      //require(tokenIsAllowed(token), "Token is not allowed!")
      //IERC20(token).transferFrom(msg.sender, address(this), amount);
      //stakedBalanceMap[token][msg.sender] = stakedBalanceMap[token][msg.sender] + amount;
      //updateIncomeIndex();
  }


//what if the withdraw amount is more than the available liquidity?
  function unstake(uint amount) public {
      require(IERC20(nostraERC20Address).balanceOf(msg.sender) >= amount, "Can't withdraw more than already is staked!");
      uint amountInUSD = amount*50;
      require(amountInUSD <= totalLiquidity - totalBorrowed, "Not enough USDT to allow withdraw, please come back at a later date");// Maybe branch here to allow a user to enter a queue to get funds withdrawed
      //NostraERC20(nostraERC20Address).transferFrom(msg.sender, address(this), amount);
      IERC20(USDTAddress).transferFrom(address(this), msg.sender, amountInUSD);
      totalLiquidity = totalLiquidity - amountInUSD;
      //require(balance[msg.sender] - amount > 0, "You can't withdraw more than you've deposited!");
      //balance[msg.sender] -= amount;
      //payable(msg.sender).transfer(amount);
      //require(amount > 0, "Amount cannot be 0!");
      //require(stakedBalanceMap[token][msg.sender] - amount > 0, "Cannot withdraw more than you deposited!");
      //require(tokenIsAllowed(token), "Token is not offered as a valid withdraw.")
      //IERC20(token).transferFrom(address(this), msg.sender, amount);
      //stakedBalanceMap[token][msg.sender] = stakedBalanceMap[token][msg.sender] - amount;
      //updateIncomeIndex();
  }

/*
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
*/
  //function addRentToPool(uint principle, uint interest) public {
      //totalBorrowed -= principle;
      //This will call the DappToken contract and just update the amount of DappTokens each person has in one fell swoop using their addresses stored;
  
//  }

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
