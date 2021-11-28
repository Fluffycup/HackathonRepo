pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PsuedoStableCoin is ERC20 {

    constructor() ERC20("PsuedoStableCoin", "PSC") {
        _mint(0x7c13f6F69D64119FfDEDcB04fFF559362942103c, 1000000000 * 10 ** 18);
    }
}