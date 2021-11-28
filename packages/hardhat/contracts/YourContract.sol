pragma solidity >=0.8.3 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract equityContract {
    // mapping of Deed ID to equity holders to equity shares
    mapping(uint256 => mapping(address => uint256)) equityMap;
    mapping(uint256 => address[]) deedRegistry;
    mapping(uint256 => uint256) equityMinted;
    mapping(uint256 => uint256) housePrices;
    address treasuryHolding;
    address public PSCAddress;
    address liquidityPool;

    constructor() {

    }

    function setPSCTokenAddresses(address stableCoin) public {
      PSCAddress = stableCoin;
  }

    function showEquity(address _addr, uint256 _deedId) public view returns (uint256) {
      return equityMap[_deedId][_addr];
    }

    function mintEquity(uint256 _deedId, uint256 _mortgageTermYears) public {
      equityMap[_deedId][address(this)] = _mortgageTermYears * 12;
      equityMinted[_deedId] = _mortgageTermYears * 12;
      deedRegistry[_deedId].push(address(this));
      treasuryHolding = address(this);
    }

    function setLiquidityPoolAddress(address _addr) public {
      liquidityPool = _addr;
    }

    function payRent(uint256 _deedId, uint256 _rentAmount) public {
      IERC20(PSCAddress).transferFrom(msg.sender, liquidityPool, _rentAmount);
      rewardRenter(_deedId, msg.sender);
    }

    function rewardRenter(uint256 _deedId, address _addr) public {
      require(equityMap[_deedId][treasuryHolding] >= 1, "Not enough equity to allocate.");
      equityMap[_deedId][treasuryHolding] -= 1;
      equityMap[_deedId][_addr] += 1;
      deedRegistry[_deedId].push(_addr);
    }
  
    function allocateEquity(uint256 _deedId, address _addr, uint256 _equityAmount) public {
      require(equityMap[_deedId][treasuryHolding] >= _equityAmount, "Not enough equity to transfer.");
      equityMap[_deedId][treasuryHolding] -= _equityAmount;
      equityMap[_deedId][_addr] += _equityAmount;
      deedRegistry[_deedId].push(_addr);
    }

    function setHousePrice(uint256 _deedId, uint256 _housePrice) public {
      housePrices[_deedId] = _housePrice;
    }

    function buyoutEquityHolders(uint256 _deedId) public {
      // ensure sender has enough funds
      uint256 housePrice = housePrices[_deedId];
      require(IERC20(PSCAddress).balanceOf(msg.sender) >= housePrice);
      for (uint i = 0; i < deedRegistry[_deedId].length; i++) {
        // Send each equity holder amount = equity / total equity * house price
        address currentAddr = deedRegistry[_deedId][i];
        uint256 amountToSend = equityMap[_deedId][currentAddr] / equityMinted[_deedId] * housePrice;
        IERC20(PSCAddress).transferFrom(msg.sender, deedRegistry[_deedId][i], amountToSend);
        // reduce their equity to 0
        equityMap[_deedId][deedRegistry[_deedId][i]] = 0;
      }
      // set buyout address equity to 100%
      equityMap[_deedId][msg.sender] = equityMinted[_deedId];
    }
}