pragma solidity ^0.5.16;
contract checker {
 
 address [] connected_devices;
 bytes32 miner = 0x8ea5947f4a057cd88cb5d0523bdb47efd3de8cd4ae45704b0c7d277e95dd17b7;    //this will vary upon network to network

 function check(bytes32 hash, bytes memory signature) public view returns (bool) {
     if(keccak256(abi.encodePacked(msg.sender)) == miner && keccak256(abi.encodePacked(recover(hash,signature))) == miner){
      return true;   
     }
     else{return false;}
 }
 
function addit(bytes32 hashadd, bytes memory signatureadd, address targetadd) public payable returns (int) {
     if(check(hashadd,signatureadd) == true){
         for (uint i=0; i<connected_devices.length; i++) {
         if(keccak256(abi.encodePacked(targetadd)) == keccak256(abi.encodePacked(connected_devices[i]))) {
             return 1;
         }
     }
         connected_devices.push(targetadd);
         connected_devices.length++;
         return 0;
     }
     else{return 2;}
 }
 
function dltit(bytes32 hashdlt, bytes memory signaturedlt, address targetdlt) public payable returns (int) {
     if(check(hashdlt,signaturedlt) == true){
         for (uint i=0; i<connected_devices.length; i++) {
         if(keccak256(abi.encodePacked(targetdlt)) == keccak256(abi.encodePacked(connected_devices[i]))) {
             connected_devices[i]=connected_devices[connected_devices.length-1];
             delete connected_devices[connected_devices.length-1];
             connected_devices.length--;
             return 0;
         }
     }
     }
     else{return 1;}
 }

  function recover(bytes32 hash, bytes memory signature)
    public
    pure
    returns (address)
  {
    bytes32 r;
    bytes32 s;
    uint8 v;
    bytes memory prefix = "\x19Ethereum Signed Message:\n32";
    bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));
    // Check the signature length
    if (signature.length != 65) {
      return (address(0));
    }

    // Divide the signature in r, s and v var*iables
    // ecrecover takes the signature parameters, and the only way to get them
    // currently is to use assembly.
    // solium-disable-next-line security/no-inline-assembly
    assembly {
      r := mload(add(signature, 0x20))
      s := mload(add(signature, 0x40))
      v := byte(0, mload(add(signature, 0x60)))
    }

    // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
    if (v < 27) {
      v += 27;
    }

    // If the version is correct return the signer address
    if (v != 27 && v != 28) {
      return (address(0));
    } else {
      // solium-disable-next-line arg-overflow
      return ecrecover(prefixedHash, v, r, s);    //another functio( heart of address recovery *)
    }
  }
 
function connectivity_check(bytes32 hashcnc, bytes memory signaturecnc, address targetcnc) public view returns (bool , bool) {
     bool requester_coneected= false;
     bool target_connected=  false;
     for (uint i=0; i<connected_devices.length; i++) {
         if(keccak256(abi.encodePacked(msg.sender)) == keccak256(abi.encodePacked(connected_devices[i])) || keccak256(abi.encodePacked(msg.sender)) == miner) {
             if(keccak256(abi.encodePacked(msg.sender)) == keccak256(abi.encodePacked(recover(hashcnc,signaturecnc)))){
                 requester_coneected=true;
             }
         }
     for (uint j=0; j<connected_devices.length; j++) {
     if(keccak256(abi.encodePacked(targetcnc)) == keccak256(abi.encodePacked(connected_devices[j]))) {
     target_connected=true;
         }
         }
     }
     return (requester_coneected, target_connected);
 }
}
