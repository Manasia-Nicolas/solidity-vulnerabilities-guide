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
