pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract HomeContract {

    address public PSCAddress;

  struct Home {
    uint startDate;
    uint vestingPeriod;
    uint monthlyRent;
    bool occupied;
    address currentOccupant;
    uint256 homeDeedID;
  }

  mapping (uint256 => Home) public properties;
  mapping (string => uint256) public rightsToOccupyIDs;
  address private rightsToOccupyAddress;
  address private equityContract;
  address liquidityPool;

 constructor(address _rightsToOccupyAddress, address _equityContract) {
    rightsToOccupyAddress = _rightsToOccupyAddress;
    equityContract = _equityContract;
  } 

function setTokenAddresses(address _stableCoin, address _liquidityPool) public {
      PSCAddress = _stableCoin;
      liquidityPool = _liquidityPool;
  }


  function addProperty(address _occupant, uint _homeDeedTokenID, uint _vestingPeriod, uint _monthlyRent, string memory _address) public {
    // tokenURI is metadata so makes sense to make it _homeDeedTokenID
    string memory tokenUri = uint2str(_homeDeedTokenID);
    bytes memory payload = abi.encodeWithSignature("awardItem(address, string)", _occupant, tokenUri);
    // decode function call results
    (bool sucess, bytes memory result) = rightsToOccupyAddress.call(payload);
    uint256 newTokenId = abi.decode(result, (uint256));

    Home memory newHome = Home(block.timestamp, _vestingPeriod, _monthlyRent, true, _occupant, _homeDeedTokenID); // need to change now
    // map home address to new tokenID
    // then map tokenID to Home object
    rightsToOccupyIDs[_address] = newTokenId;
    properties[newTokenId] = newHome;
    // createEquityTokens
    bytes memory payload2 = abi.encodeWithSignature("mintEquity(uint256, uint256)", _homeDeedTokenID, _vestingPeriod);
    equityContract.call(payload2);
  }

  function claimRightsToOccupyToken(address _claimer, uint256 _occupyTokenID) public {
    require(properties[_occupyTokenID].occupied == false);
    transferRightsToOccupyToken(_claimer, address(this), _occupyTokenID);
  }

  function transferRightsToOccupyToken(address _to, address _from, uint256 _rightsToOccupyID) public {
    IERC721 rtoContract = IERC721(rightsToOccupyAddress);
    rtoContract.safeTransferFrom(_from, _to, _rightsToOccupyID);
    properties[_rightsToOccupyID].currentOccupant = _to;
    properties[_rightsToOccupyID].occupied = true;
  }

  function payRent(address _occupant, string memory _homeAddress) public payable {
    // send funds to investment pool contract.
    uint256 homeTokenID = rightsToOccupyIDs[_homeAddress];
    Home storage home = properties[homeTokenID];
    uint monthlyRent = home.monthlyRent;
    uint homeDeedID = home.homeDeedID;
    require(IERC20(PSCAddress).balanceOf(msg.sender) >= monthlyRent, "Not enough funds");
    IERC20(PSCAddress).transferFrom(_occupant, liquidityPool, monthlyRent); // I think this needs to be switched to a function call from stake contract
    // transfer equity token to occupant
    bytes memory payload = abi.encodeWithSignature("rewardRenter(uint256, address)", homeDeedID, _occupant);
    equityContract.call(payload);
  } 

  function checkIfVestingPeriodOver(Home storage _home) private view returns (bool) {
    return block.timestamp >= _home.startDate + _home.vestingPeriod; //This doesn't work
  }

  // helper function
  function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}