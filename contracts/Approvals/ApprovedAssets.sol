//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {Sextons} from "contracts/AccessControl/Sextons.sol";

contract ApprovedAssets is Sextons {
    struct Asset {
        address _token;        
        address _accountant;
        bool _approved;
        uint _timestamp;
    }

    mapping (uint => Asset) public assets;

    event assetApproved(address _token, address _accountant, bool _approved);
    event assetUnapproved(address _token, address _accountant, bool _approved);
    
    //Approve asset
    function approveAsset(address _token, address _accountant, bool _approved) external onlyRole(ACCOUNTANT) {
        _approveAsset(_token, _accountant, _approved);
        emit assetApproved(_token, _accountant, _approved);
    }

    function _approveAsset(address _token, address _accountant, bool _approved) internal {

    }

    //Unapprove asset

    function unapproveAsset(address _token, address _accountant, bool _approved) external onlyRole(ACCOUNTANT) {
        _unapproveAsset(_token, _accountant, _approved);
        emit assetUnapproved(_token, _accountant, _approved);
    }

    function _unapproveAsset(address _token, address _accountant, bool _approved) internal {

    }
} 