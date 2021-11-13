contract HomeContract {

  struct Home {
    uint startDate;
    uint vestingPeriod;
    uint monthlyRent;
  }

  Home [] properties

  addProperty(address homeDeedToken, uint vestingPeriod, uint monthlyRent) public {
    // TODO: create Rights To Occupy Token, 
  }

  function claimRightsToOccupyToken(address claimer, address occupyToken) public {
    // TODO: transfer ownership of rights to claim token
  }

  function payRent(address rightToOccupyToken, address occupant) payable {
    // TODO: send funds to investment pool contract.
    // TODO: transfer equity token to occupant
  }

  function getEquity(address occupant) public {
    // TODO: return current equity
  }

  
}