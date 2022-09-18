//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "contracts/Management/Manager.sol";

contract TestManager is Manager{
    constructor() {}

    function echidna_only_reaper_withdrawal_FTM_pass() public view returns(bool){

    }

    function echidna_no_role_withdrawal_FTM_fail() public view returns(bool){

    }

    function echidna_accountant_withdrawal_FTM_fail() public view returns(bool){

    }

    function noRoleWithdrawal(address _to, uint _amount) external {
        IReaperTreasury(treasury).withdrawFTM(_to, _amount);
    }
