// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract InscribeERC20 is ERC20 {
    using SafeERC20 for InscribeERC20;
    address factory;
    string private _name;
    string private _symbol;

    constructor () ERC20("INSCRIBETOKEN","insToken") {

    }

    function name() public view override returns (string memory) {
        return _name;
    }

    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    function init(string memory name, string memory symbol) public  {
        _name = name; 
        _symbol = symbol;
        factory = msg.sender;
    }

    function inscribe(address to,uint256 amount) public {
        _mint(to, amount); 
    }

}