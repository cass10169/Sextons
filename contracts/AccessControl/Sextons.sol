//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Sextons {
    struct CryptData {
        mapping(address => bool) members;
        bytes32 _role;
    }

    mapping(bytes32 => CryptData) private _roles;
    mapping(bytes32 => mapping(address => bool)) public roles;

    event GrantRole(bytes32 indexed role, address indexed account);
    event RevokeRole(bytes32 indexed role, address indexed account);
    event TransferCrypt(bytes32 indexed role, address indexed account, address indexed keeper);
    event CryptConfigured(bytes32 indexed role, address indexed keeper);
    //event RoleAdded(bytes32 indexed role, address indexed account);

    bytes32 internal constant HADES = keccak256(abi.encodePacked("HADES")); //MULTISIG
    bytes32 internal constant CRYPTKEEPER = keccak256(abi.encodePacked("CRYPTKEEPER")); //MASTER ADMIN
    bytes32 internal constant REAPER = keccak256(abi.encodePacked("REAPER")); //FUNDS MANAGER
    bytes32 internal constant ACCOUNTANT = keccak256(abi.encodePacked("ACCOUNTANT")); //ASSET APPROVAL 
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef"; //CHARACTER VALIDATION

    modifier onlyRole(bytes32 _role) {
        require(roles[_role][msg.sender], "not authorized");
        _;
    }

    constructor() {
        _setupCryptKeeper(CRYPTKEEPER, msg.sender);
        _setupCryptKeeper(REAPER, msg.sender);
        _setupCryptKeeper(ACCOUNTANT, msg.sender);
        _setupCryptKeeper(HADES, msg.sender);
    }

    function _grantRole(bytes32 _role, address _account) internal {
        if (!_hasRole(_role, _account)) {
            _roles[_role].members[_account] = true;
            emit GrantRole(_role, _account);
        }
    }

    function grantRole(bytes32 _role, address _account) public onlyRole(CRYPTKEEPER) {
        _grantRole(_role, _account);
    }

    function _revokeRole(bytes32 _role, address _account) internal {
         if (_hasRole(_role, _account)) {
            _roles[_role].members[_account] = false;
            emit RevokeRole(_role, _account);
        }
    }

    function revokeRole(bytes32 _role, address _account) public onlyRole(CRYPTKEEPER) {
        _revokeRole(_role, _account);
    }

    function _transferCrypt(bytes32 _role, address _account) internal {
        roles[CRYPTKEEPER][_account] = true;
        roles[CRYPTKEEPER][msg.sender] = false;
        emit TransferCrypt(_role, _account, msg.sender);    
    }

    function transferCrypt(bytes32 _role, address _account) public onlyRole(CRYPTKEEPER) {
        _transferCrypt(_role, _account);
    } 

    function _setupCryptKeeper(bytes32 _role, address _account) internal {
        roles[_role][_account] = true;
        emit CryptConfigured( _role, _account);
    }

    //function _addRole(bytes32 _role, address _account) internal {
    //    emit RoleAdded(_role, _account);
    //}

    function isReaper(address _account) public view returns (bool) {
        return _hasRole(REAPER, _account);
    }

    function isCryptKeeper(address _account) public view returns (bool) {
        return _hasRole(CRYPTKEEPER, _account);
    } 

    function isAccountant(address _account) public view returns (bool) {
        return _hasRole(ACCOUNTANT, _account);
    }

    function isHades(address _account) public view returns (bool) {
        return _hasRole(HADES, _account);
    }

    function _hasRole(bytes32 _role, address _account) internal view returns (bool) {
        return _roles[_role].members[_account];
    }

    function _checkRole(bytes32 _role, address _account) internal view {
        if (!_hasRole(_role, _account)) {
            revert(
                string(
                    abi.encodePacked(
                        "Sextons: account ",
                        _toHexString(uint160(_account), 20),
                        " is missing role ",
                        _toHexString(uint256(_role), 32)
                    )
                )
            );
        }
    } 

    function _toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return _toHexString(value, length);
    }

    function _toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "address invalid");
        return string(buffer);
    } 
}
