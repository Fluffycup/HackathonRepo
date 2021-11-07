pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract Klaos is ERC20 {
    address public admin;
    constructor() ERC20('Klaos' , 'PHI') {
      _mint(msg.sender, 10000* 10 ** 18);
      admin = msg.sender;
    }

    function mint(address to , uint amount) external {
      require(msg.sender == admin, 'only admin');
      _mint(to, amount);
    }

    function burn(uint amount) external {
      _burn(msg.sender,amount);

    }





//Foot Note
/*Not Christian myself but thought it might interest someone in the lore behind the name.
So here's a quote from verse Matthew 14:19

Matthew 14:19
"And he directed the people to sit down on the grass.
Taking the five loaves and the two fish and looking up to heaven,
he gave thanks and broke the loaves.
Then he gave them to the disciples, and the disciples gave them to the people."

In the Greek translation the breaking of the bread uses the verb "klao"
which I personally thought was a good idea for the project as we are distributing
housing plots into multiple broken pieces.

*/
