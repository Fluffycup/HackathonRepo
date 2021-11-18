pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract  is ERC20, ownable {
  address public admin;
    constructor() ERC20('NostraDomus' , 'Nostra') {
      _mint(msg.sender, 10000 * 10 ** 18);
      admin = msg.sender;
    }

    function mint(address to , uint amount) external {
      require(msg.sender == admin, 'only admin');
      _mint(to, amount);
    }
}


