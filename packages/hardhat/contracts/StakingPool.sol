pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";
// import ./HomeContract.sol;

contract StakingPool {

  uint public totalLiquidity;
  address public PSCAddress;
  address public nostraERC20Address;
  uint public totalBorrowed;

  function setTokenAddresses(address dappToken, address stableCoin) public {
      nostraERC20Address = dappToken;
      PSCAddress = stableCoin;
  }

  function stake(uint amount) public {
      require(IERC20(PSCAddress).balanceOf(msg.sender) >= amount, "Not enough funds!"); // Using Testnet TUSDT address, to be updated if put on mainnet
      uint dappTokensToMint = amount/50;
      IERC20(PSCAddress).transferFrom(msg.sender, address(this), amount);
      //NostraERC20(nostraERC20Address).mint(msg.sender, dappTokensToMint);
      totalLiquidity = totalLiquidity + amount;
  }


//what if the withdraw amount is more than the available liquidity?
  function unstake(uint amount) public {
      require(IERC20(nostraERC20Address).balanceOf(msg.sender) >= amount, "Can't withdraw more than already is staked!");
      uint amountInUSD = amount*50;
      require(amountInUSD <= totalLiquidity - totalBorrowed, "Not enough USDT to allow withdraw, please come back at a later date");// Maybe branch here to allow a user to enter a queue to get funds withdrawed
      //NostraERC20(nostraERC20Address).transferFrom(msg.sender, address(this), amount);
      IERC20(PSCAddress).transferFrom(address(this), msg.sender, amountInUSD);
      totalLiquidity = totalLiquidity - amountInUSD;
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
