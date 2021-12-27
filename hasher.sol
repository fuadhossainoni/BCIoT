pragma solidity ^0.5.16;
contract checker {
function getaddress(address input) public view returns (bytes32) {
     bytes32 a = keccak256(abi.encodePacked(input));   
     returns a;
     }
}