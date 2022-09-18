//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {Sextons} from "contracts/AccessControl/Sextons.sol";

contract DepositApproval is Sextons {
    event deposit(address indexed sender, uint amount, uint balance);
    event approvalSubmitted(address indexed requestor, uint indexed txIndex, address indexed to, uint amount, bytes data, address token);
    event approvalRejected(address indexed hades, uint indexed txIndex);
    event approvalRevoked(address indexed hades, uint indexed txIndex);
    event approvalConfirmation(address indexed hades, uint indexed txIndex);
    event approvalSet(address indexed hades, uint indexed txIndex);

    address[] public hades;
    mapping(address => bool) public isHades;
    uint public numConfirmationsRequired;



    struct Hades {
        address requestor;
        bytes32 role;
    }

    struct Approval {
        address requestor;
        address to;
        address token; //later to be adjusted for approved assets
        uint amount;
        bytes data;
        bool isSubmitted;
        mapping(address => bool) isConfirmed;
        mapping(address => bool) isApproved;
        uint numConfirmations;         
    }

    Approval [] public approvals;

    modifier txExists(uint _txIndex) {
        require(_txIndex < approvals.length, "tx does not exist");
        _;
    }

    modifier notSubmitted(uint _txIndex) {
        require(!approvals[_txIndex].isSubmitted, "tx already submitted");
        _;
    }

    modifier notConfirmed(uint _txIndex) {
        require(!approvals[_txIndex].isConfirmed[msg.sender], "tx already confirmed");
        _;
    }

    modifier notApproved(uint _txIndex) {
        require(!approvals[_txIndex].isApproved[msg.sender], "tx already confirmed");
        _;        
    }

    constructor(address[] memory _hades, uint _numConfirmationsRequired) {
        require(_hades.length > 0, "owners required");
        require (
            _numConfirmationsRequired > 0 && _numConfirmationsRequired <= _hades.length,
            "invalid number of required confirmations"
        );
        for (uint i = 0; i < _hades.length; i++) {
            address hades = _hades[i];

            require(hades != address(0), "invalid owner");
            require(!isHades[hades], "owner not unique");
            require(roles[HADES][msg.sender], "not authorized");

            isHades[hades] = true;
            hades.push(hades);
        } 
        numConfirmationsRequired = _numConfirmationsRequired;
    }

    function submitApproval(address _to, address _token, uint _amount, bytes memory _data) public onlyRole(HADES, REAPER, ACCOUNTANT) {
        _submitApproval(_to,  _amount, _data, _token);        
    }

    function _submitApproval(address _to, address _token, uint _amount, bytes memory _data) internal {
            approvals.push(Approval({
            to: _to,
            token: _token,
            amount: _amount,
            data: _data,
            submitted: true,
            isApproved: false,
            numConfirmations: 0            
        }));

        emit approvalSubmitted(msg.sender, _to, _amount, _data, _token);
    }

    function rejectApproval() public onlyRole(HADES) {
        _rejectApproval();        
    }

    function _rejectApproval() internal {
        emit approvalRejected();
    }

    function revokeApproval() public onlyRole(HADES) {
        _revokeApporval();        
    }

    function _revokeApporval() internal {
        emit approvalRevoked();
    }    

    function confirmApproval(uint _txIndex) public onlyRole(HADES) {
        _confirmApproval();        
    }

    function _confirmApproval(uint _txIndex) internal 
        txExists(_txIndex)
        notConfirmed(_txIndex)
        notApproved(_txIndex)
    {
        Approval storage approval = approvals[_txIndex];

        approval.isApproved[msg.sender] =  true;
        approval.numConfirmations += 1;

        emit approvalConfirmation();
    }

    function setApproval(uint txIndex) public onlyRole(HADES) {
        _setApproval();        
    }

    function _setApproval() internal {
        emit approvalSet();
    }
}