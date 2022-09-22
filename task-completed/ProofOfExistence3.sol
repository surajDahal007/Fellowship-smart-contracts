//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract ProofOfExistence3 {

  mapping (bytes32 => bool) private proofs;
  
  // store a proof of existence in the contract state
  function storeProof(bytes32 _proof) 
    internal 
  {
     proofs[_proof]=true;
  }
  
  // calculate and store the proof for a document
  function notarize(string memory _document) 
    public 
  { 
    bytes32 proof=proofFor(_document);
    storeProof(proof);
  }
  
  // helper function to get a document's keccak256 hash
  function proofFor(string memory _document) 
    pure 
    private 
    returns (bytes32 proof) 
  {
    proof=keccak256(abi.encodePacked(_document));
    return proof;
  }
  
  // check if a document has been notarized
  function checkDocument(string memory _document) 
    public 
    view 
    returns (bool) 
  {
     bytes32 documentProof=proofFor(_document);
     return hasProof(documentProof);
  }

  // returns true if proof is stored
  function hasProof(bytes32 _proof) 
    internal 
    view 
    returns(bool) 
  {
     if(proofs[_proof])
     return true;
     else 
     return false;      

  }
}
