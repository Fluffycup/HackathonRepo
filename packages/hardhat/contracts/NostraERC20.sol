pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NostraDomus is ERC20, Ownable {
  address public admin;
    constructor() ERC20('NostraDomus' , 'Nostra') {
      _mint(msg.sender, 10000 * 10 ** 18);
      admin = msg.sender;
    }

    function mint(address to , uint amount) external {
      require(msg.sender == admin, 'only admin');
      _mint(to, amount);

    }
    function balanceOf(address _user) public{
            uint256 rawBalance = balances[_user];
	    if (rawBalance ==0) {
        	return 0;
             }
             uint256 startLevel = compoundInterestFactor[_user];
     	     uint256 currentLevel = getInterestRate().getCurrentCompoundingLevel();
             return _rawBalance.mul(currentLevel).div(startLevel);

    }
}


