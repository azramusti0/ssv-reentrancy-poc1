// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.24;

interface ISSVOperators {
    function withdrawAllOperatorEarnings(uint64 operatorId) external;
    function registerOperator(bytes calldata publicKey, uint256 fee, bool setPrivate) external returns (uint64 id);
}

contract SSVOperators is ISSVOperators {
    mapping(uint64 => uint256) public earnings;
    mapping(uint64 => address) public owners;
    uint64 public lastId;

    function registerOperator(bytes calldata, uint256 fee, bool) external override returns (uint64 id) {
        require(fee > 0, "Fee too low");
        id = ++lastId;
        owners[id] = msg.sender;
        earnings[id] = 10 ether;
    }

    function withdrawAllOperatorEarnings(uint64 operatorId) external override {
        require(msg.sender == owners[operatorId], "Not owner");
        uint256 amount = earnings[operatorId];
        require(amount > 0, "No earnings");
        earnings[operatorId] = 0;
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Transfer failed");
    }

    function setOperatorOwner(uint64 operatorId, address newOwner) external {
        owners[operatorId] = newOwner;
    }

    receive() external payable {}
}
