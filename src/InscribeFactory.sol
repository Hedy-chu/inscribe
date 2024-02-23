// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/Clones.sol";

interface IInscribeERC20 {
    function init(string memory name, string memory symbol) external;

    function inscribe(address to, uint256 amount) external;

    function balanceOf(address account) external returns (uint256);

    function totalSupply() external returns (uint256);
}

contract InscribeFactory {
    using Clones for address;
    address tokenAddr;
    mapping(address => uint256) public _perMint;
    mapping(address => uint256) public _maxInscribe;

    constructor(address addr) {
        tokenAddr = addr;
    }

    modifier checkMaxInscribe(address insAddr) {
        require(
            IInscribeERC20(insAddr).totalSupply() + _perMint[insAddr] <=
                _maxInscribe[insAddr],
            "maxInscribe"
        );
        _;
    }

    function depolyInscription(
        string memory name,
        string memory symbol,
        uint256 totalSupply,
        uint256 perMint
    ) public returns (address) {
        require(totalSupply > perMint, "totalSupply must bigger than perMint");
        require(
            totalSupply % perMint == 0,
            "totalSupply % perMint must equalis 0"
        );
        address newAddress = tokenAddr.clone();
        IInscribeERC20(newAddress).init(name, symbol);
        _perMint[newAddress] = perMint;
        _maxInscribe[newAddress] = totalSupply;

        return newAddress;
    }

    function mintInscription(address insAddr) public checkMaxInscribe(insAddr) {
        IInscribeERC20(insAddr).inscribe(msg.sender, _perMint[insAddr]);
    }

    function getBalance(
        address insAddr,
        address user
    ) public returns (uint256) {
        return IInscribeERC20(insAddr).balanceOf(user);
    }
}
