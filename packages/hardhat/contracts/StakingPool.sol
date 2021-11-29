pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "./NostraERC20.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract StakingPool is ChainlinkClient, ERC721Holder {
  using Chainlink for Chainlink.Request;

  uint256 public avm;
  address public oracle;
  bytes32 public jobId;
  uint256 public fee;
  uint public totalLiquidity;
  address public PSCAddress;
  address public nostraERC20Address;
  address public DeedAddress;
  uint public totalBorrowed;

  constructor() {
      setPublicChainlinkToken();
      oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;
      jobId = "d5270d1c311941d0b08bead21fea7747";
      fee = 0.1 * 10 ** 18;
  }

  function setTokenAddresses(
      address dappToken, //Address for the Staking Token to represent Deposit
      address stableCoin, //Address for the stable coin that's tied closely to USD
      address deedAddress
  ) public {
      nostraERC20Address = dappToken;
      PSCAddress = stableCoin;
      DeedAddress = deedAddress;
  }

  function stake(
      uint amount //Amount in USD that they want to stake
  ) public {
      require(IERC20(PSCAddress).balanceOf(msg.sender) >= amount, "Not enough funds!"); // Using Testnet TUSDT address, to be updated if put on mainnet
      uint dappTokensToMint = amount/50; //50 is an abritrary number, it could 100, 200, or 10,000 even
      IERC20(PSCAddress).transferFrom(msg.sender, address(this), amount);
      IERC20(nostraERC20Address).transfer(msg.sender, dappTokensToMint);
      totalLiquidity = totalLiquidity + amount;
  }


  function unstake(
      uint amount // Amount in USD that they want to withdraw
  ) public {
      require(IERC20(nostraERC20Address).balanceOf(msg.sender)*50 >= amount, "Can't withdraw more than already is staked!");
      require(amount <= totalLiquidity - totalBorrowed, "Not enough USD to allow withdraw, please come back at a later date");
      // Maybe branch here to allow a user to enter a queue to get funds withdrawed
      uint dappTokensToTake = amount/50; //50 is an abritrary number, it could 100, 200, or 10,000 even
      IERC20(nostraERC20Address).transferFrom(msg.sender, address(this), dappTokensToTake);
      IERC20(PSCAddress).transfer(msg.sender, amount);
      totalLiquidity = totalLiquidity - amount;
  }

  function requestAVMData() public returns (bytes32 requestId)
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

        request.add("get", "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD");
        
        request.add("path", "RAW.ETH.USD.VOLUME24HOUR");
        
        // Multiply the result by 1000000000000000000 to remove decimals
        int timesAmount = 10**18;
        request.addInt("times", timesAmount);
        // Set the URL to perform the GET request on
        //request.add("property_id", "100000125583");
        //request.add("street", "broadway");
        //request.add("city", "New York");
        //request.add("state", "NY");
        //request.add("zip", "12345");

        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    function fulfill(bytes32 _requestId, uint256 _avm) public recordChainlinkFulfillment(_requestId)
    {
        avm = _avm;
    }


  function sellHomeToContract(uint256 deedId, uint askingPriceUSD) public {
      require(IERC721(DeedAddress).ownerOf(deedId) == msg.sender, "You are not the owner of that home!");
      //require(avm != 0, "still awaiting API valuation of home response");
      //require(avm  >= askingPriceUSD, "Amount requested is higher than estimate");
      require(totalLiquidity-totalBorrowed >= askingPriceUSD, "Sorry! Not enough funds to purchase home!");
      IERC721(DeedAddress).safeTransferFrom(msg.sender, address(this), deedId);
      IERC20(PSCAddress).transfer(msg.sender, askingPriceUSD);
      totalBorrowed += askingPriceUSD;
      avm = 0;
      //HomeContract(Walt_address).addProperty(deedId, vesting_period, monthlyRent);
  }

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
