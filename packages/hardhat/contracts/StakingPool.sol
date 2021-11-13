pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract StakingPool {

  //current revenue index
  // map of address to revenue index at last touch
  // user BalanceMap will be stored in the ERC-20 token contract but needs to be readable here
  mapping(address => mapping(address => uint)) public stakedBalanceMap; // token -> user -> amount can I get away with just keeping this on the Dapp token?
  mapping(address => uint) public userBalanceIndexMap;
  uint public reserveNormalizedIncome;
  uint public totalLiquidity;
  uint public totalBorrowed;
  uint public lastTimestamp;
  uint constant secondsInYear = 31536000;
  uint public interestRate;
  address[] constant allowedTokens = [0x7079f3762805cff9c979a5bdc6f5648bcfee76c8,0x1484a6020a0f08400f6f56715016d2c80e26cdc1]; //USDC & USDT token addresses on Kovan testnet

  constructor() {
    // what should we do on deploy?
  }

  function stake(uint memory amount, address memory token) public {
      require(amount > 0, "Amount cannot be 0!");
      require(tokenIsAllowed(token), "Token is not allowed!")
      IERC20(token).transferFrom(msg.sender, address(this), amount);
      stakedBalanceMap[token][msg.sender] = stakedBalanceMap[token][msg.sender] + amount;
      totalLiquidity = totalLiquidity + amount;
      updateIncomeIndex();
  }
//what if the withdraw amount is more than the available liquidity?
  function unstake(uint memory amount, address memory token) public {
      require(amount > 0, "Amount cannot be 0!");
      require(stakedBalanceMap[token][msg.sender] - amount > 0, "Cannot withdraw more than you deposited!");
      require(tokenIsAllowed(token), "Token is not offered as a valid withdraw.")
      IERC20(token).transferFrom(address(this), msg.sender, amount);
      stakedBalanceMap[token][msg.sender] = stakedBalanceMap[token][msg.sender] - amount;
      totalLiquidity = totalLiquidity - amount;
      updateIncomeIndex();
  }

  function buyHome(address memory homeNFT, uint memory amount) public {
      require(homeNFT == 0x00000000000000000000000000000000000000000000, "Not a homeNFT") //need to update with the smart contract address for the homeNFTs
      require(amount < totalLiquidity - totalBorrowed, "Not enough funds to purchase home")
      IERC721(token).transferFrom(msg.sender, address(this), homeId
     
  }

  function updateIncomeIndex() public {
      utilizationRate = totalBorrowed/totalLiquidity;
      liquidityRate = interestRate * utilizationRate;
      deltaTYear = (block.timestamp - lastTimestamp)/secondsInYear
      reserveNormalizedIncome = reserveNormalizedIncome*(liquidityRate*deltaTYear + 1);

  }
  function tokenIsAllowed(address memory token) public returns (bool) {
      for(uint256 allowedTokensIndex = 0; allowedTokensIndex < allowedTokens.length; allowedTokensIndex++) {
          if(allowedTokens[allowedTokensIndex] == token){
              return true;
          }
      }
      return false;
  }
  // function to stake money
  // function to withdraw money
  // function to send money
  // internatl function to update revenue index
  // function to sell home to contract and create home smart contract
  function setPurpose(string memory newPurpose) public {
      purpose = newPurpose;
      console.log(msg.sender,"set purpose to",purpose);
      // emit SetPurpose(msg.sender, purpose);
  }
}
