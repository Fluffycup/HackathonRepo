pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

contract HomeContract {

  struct Home {
    uint startDate;
    uint vestingPeriod;
    uint monthlyRent;
    bool occupied;
    address currentOccupant;
  }

  mapping (uint256 => Home) public properties;
  mapping (string => uint256) public rightsToOccupyIDs;
  address private rightsToOccupyAddress;

 constructor(address _rightsToOccupyAddress) {
    rightsToOccupyAddress = _rightsToOccupyAddress;
  } 

  function addProperty(address _occupant, uint _homeDeedTokenID, uint _vestingPeriod, uint _monthlyRent, string memory _address) public {
    // tokenURI is metadata so makes sense to make it _homeDeedTokenID
    string tokenUri = uint2str(_homeDeedTokenId);
    bytes memory payload = abi.encodeWithSignature("awardItem(adress, string)", _occupant, tokenUri);
    // decode function call results
    (bool sucess, bytes memory result) = rightsToOccupyAddress.call(payload);
    uint256 newTokenId = abi.decode(result, (uint256));

    Home newHome = Home(now, _vestingPeriod, _monthlyRent, true, _occupant); // need to change now
    // map home address to new tokenID
    // then map tokenID to Home object
    rightsToOccupyIDs[_address] = newTokenId;
    properties[newTokenId] = newHome;
    // createEquityTokens  
  }

  function claimRightsToOccupyToken(address _claimer, uint256 _occupyTokenID) public {
    require(properties[_occupyTokenID].occupied == false);
    transferRightsToOccupyToken(_claimer, address(this), _occupyTokenID);
  }

  function transferRightsToOccupyToken(address _to, address _from, uint256 _rightsToOccupyID) public {
    IERC721 rtoContract = IERC721(_rightsToOccupyAddress);
    rtoContract.safeTransferFrom(_from, _to, _rightsToOccupyID);
  }

  function payRent(address _occupant, string memory _homeAddress) payable {
    // TODO: send funds to investment pool contract.
    uint256 homeTokenID = rightsToOccupyIDs[_homeAddress];
    Home home = properties[homeTokenID];
    uint monthlyRent = home.monthlyRent;
    require(IERC20(PSCAddress).balanceOf(msg.sender) >= monthlyRent, "Not enough funds");
    IERC20(PSCAddress).transferFrom(_occupant, liquidityPool, monthlyRent);
    // TODO: transfer equity token to occupant

  } 

  function getEquity(address occupant) public {
    // TODO: return current equity
  }

  function checkIfVestingPeriodOver(Home _home) private returns (bool) {
    return now >= _home.startDate + _home.vestingPeriod;
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
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}