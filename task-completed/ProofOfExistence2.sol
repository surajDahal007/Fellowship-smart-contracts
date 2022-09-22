//SPDX-License-Identifier:MIT

pragma solidity ^0.8.10;

contract ProofOfExistence2 {

  // state
  bytes32[] private proofs;

  // store a proof of existence in the contract state
  // *transactional function*
  function storeProof(bytes32 _proof) 
    internal
  {
    proofs.push(_proof);
  }

  // calculate and store the proof for a document
  // *transactional function*
  function notarize(string calldata document) 
    external 
  {
     bytes32 proof=proofFor(document);
     storeProof(proof);
  }

  // helper function to get a document's sha256
  // *read-only function*
  function proofFor(string memory document) 
    pure 
    internal 
    returns (bytes32) 
  {
   return sha256(abi.encodePacked(document));
  }

  // check if a document has been notarized
  // *read-only function*
  function checkDocument(string memory document) 
    public 
    view 
    returns (bool) 
  {
      bytes32 documentProof= proofFor(document);
      return (hasProof(documentProof));
      
  }

  // returns true if proof is stored
  // *read-only function*
  function hasProof(bytes32 _proof) 
    internal 
    view 
    returns (bool) 
  {

for(uint i=0;i<proofs.length;i++){
         if(_proof == (proofs[i]))
         return true;
     }
     return false;
}
}
