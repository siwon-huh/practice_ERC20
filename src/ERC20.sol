// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import './EIP712.sol';
contract ERC20 is EIP712("DREAM","DRM"){
    string public name;
    string public symbol;

    address private owner;
    bool isPause;

    // Task02
    mapping(address => mapping(address => uint256)) public map_owner_spender_allowance;
    mapping(address => uint) map_owner_nonce;
    uint256 init_time;
    constructor(string memory _name, string memory _symbol){
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
        isPause = false;
        init_time = block.timestamp;
    }

    function transfer(address _to, uint256 _value) public {
        require(!isPause);
    }

    function pause() public {
        require(msg.sender == owner);
        isPause = true;
    }

    function approve(address _spender, uint256 _value) public {}

    function transferFrom(address _from, address _to, uint256 _value) public {
        require(!isPause);
    }

    // Task02 starts
    function nonces(address _address) public returns(uint){
        return map_owner_nonce[_address];
    }

    function permit(address _owner, address _spender, uint256 _value, uint256 _deadline, uint8 _v, bytes32 _r, bytes32 _s) public {
        require(block.timestamp - init_time < 1 days);
        bytes32 structHash = keccak256(abi.encode(
            keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"),
            _owner,
            _spender,
            _value,
            map_owner_nonce[_owner],
            _deadline
        ));
        bytes32 hash = _toTypedDataHash(structHash);
        address signer = ecrecover(hash, _v, _r, _s);
        require(signer == _owner, "INVALID_SIGNER");

        map_owner_spender_allowance[_owner][_spender] = _value;
        map_owner_nonce[_owner] += 1;
    }

    function allowance(address _owner, address _spender) public returns (uint256) {
        return map_owner_spender_allowance[_owner][_spender];
    }
}