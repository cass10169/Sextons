//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {Sextons} from "contracts/AccessControl/Sextons.sol";

contract WithdrawalApproval is Sextons {
    event approvalSubmitted();
    event approvalRejected();
    event approvalRevoked();
    event approvalConfirmation();
    event approvalSet();


    function submitApproval() external {
        _submitApproval();
        emit approvalSubmitted();
    }

    function _submitApproval() internal {

    }

    function rejectApproval() external {
        _rejectApproval();
        emit approvalRejected();
    }

    function _rejectApproval() internal {
        
    }

    function revokeApproval() external {
        _revokeApporval();
        emit approvalRevoked();
    }

    function _revokeApporval() internal {

    }

    function confirmApproval() external {
        _confirmApproval();
        emit approvalConfirmation();
    }

    function _confirmApproval() internal {

    }

    function setApproval() external {
        _setApproval();
        emit approvalSet();
    }

    function _setApproval() internal {
        
    }
}