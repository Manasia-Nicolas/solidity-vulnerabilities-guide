/*
Delegatecall is a low-level function that lets one contract execute code from another contract in the context of the caller’s storage, msg.sender, and msg.value.
If used right, delegatecall is an usefull function. The problem is when an user has much more power and he can controls the data and the lib (this is called delegatecall injection)
*/

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Vulnarable {
    address public lib;
    function setLib(address _lib) public {
        lib = _lib;
    }
    function forward(bytes memory data) public {
        (bool succes, ) = lib.delegatecall(data);
        require(succes);
    }

}
