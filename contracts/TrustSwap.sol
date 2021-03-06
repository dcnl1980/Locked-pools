// SPDX-License-Identifier: MIT
pragma solidity >=0.4.24 <0.7.0;

import "./LockedPoolzData.sol";

contract TrustSwap is LockedPoolzData {
    constructor() public {
        StartIndex = 0;
    }

    uint256 internal StartIndex;

    function Work() internal returns (uint256) {
        uint256 WorkDone = 0;
        bool FixStart = true;
        for (uint256 index = StartIndex; index <= Index; index++) {
            if (WithdrawToken(index)) WorkDone++;
            if (FixStart && AllPoolz[index].Amount == 0) {
                //do nothing - no need De Morgan law here
            } else {
                FixStart = false;
                StartIndex = index - 1;
            }
        }
        return WorkDone;
    }

    //@dev no use of revert to make sure the loop will work
    function WithdrawToken(uint256 _PoolId) public returns (bool) {
        //pool is finished + got left overs + did not took them
        if (
            _PoolId < Index &&
            AllPoolz[_PoolId].UnlockTime <= now &&
            AllPoolz[_PoolId].Amount > 0
        ) {
            TransferToken(
                AllPoolz[_PoolId].Token,
                AllPoolz[_PoolId].Owner,
                AllPoolz[_PoolId].Amount
            );
            AllPoolz[_PoolId].Amount = 0;
            return true;
        }
        return false;
    }
}
