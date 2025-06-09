// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract SSVOperatorsMock {
    mapping(uint64 => uint256) public earnings;
    address public attacker;

    constructor() payable {
        attacker = msg.sender;
        earnings[1] = 5 ether;
    }

    function withdrawAllOperatorEarnings(uint64 operatorId) external {
        uint256 amount = earnings[operatorId];
        require(amount > 0, "Nothing to withdraw");
        earnings[operatorId] = 0;

        // Erişim kontrolü kaldırıldı, doğrudan ödeme yapılır
        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent, "Transfer failed");
    }

    receive() external payable {}
}
