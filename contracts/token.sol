// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract token is ERC20 {
    address public owner;
    uint holdingCapinPercent;

    constructor(string memory name, string memory symbol, uint256 totalSupply, uint _holdingCap) ERC20(name, symbol) {
        holdingCapinPercent = _holdingCap;
        owner = msg.sender;
        _mint(owner, totalSupply * (10**uint256(decimals())));
    }

    function getMaxHoldings() public view returns(uint256) {
        if (holdingCapinPercent == 0) {
            // If holding cap is set to 0, return maximum possible value
            return type(uint256).max;
        } else {
            return (totalSupply() * holdingCapinPercent / 100);
        }
    }

    function _transfer(address sender, address recipient, uint256 amount) internal override virtual  {
        require(balanceOf(recipient) + amount <= getMaxHoldings(), "Recipient exceeds holding cap");
        super._transfer(sender, recipient, amount);
    }

    function _approve(address _owner, address spender, uint256 amount) internal override virtual {
        owner = _owner;
        require(balanceOf(spender) + amount <= getMaxHoldings(), "Spender exceeds holding cap");
        super._approve(owner, spender, amount);
    }

    function _transferFrom(address sender, address recipient, uint256 amount) internal {
        require(balanceOf(recipient) + amount <= getMaxHoldings(), "Recipient exceeds holding cap");
        _transferFrom(sender, recipient, amount);
    }
    
}
