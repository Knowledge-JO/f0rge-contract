// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    address public s_owner;
    uint holdingCapinPercent;

    constructor(
        string memory name,
        string memory symbol,
        uint256 totalSupply,
        uint _holdingCap
    ) ERC20(name, symbol) {
        holdingCapinPercent = _holdingCap;
        _mint(msg.sender, totalSupply * (10 ** uint256(decimals())));
    }

    function getMaxHoldings() public view returns (uint256) {
        if (holdingCapinPercent == 0) {
            // If holding cap is set to 0, return maximum possible value
            return type(uint256).max;
        } else {
            return ((totalSupply() * holdingCapinPercent) / 100);
        }
    }
}
