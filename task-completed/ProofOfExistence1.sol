// SPDX-License-Identifier:MIT

pragma solidity ^0.8.10;

contract ProofOfExistence1 {
      // state
      bytes32 public proof;

      // calculate and store the proof for a document
      // *transactional function*
      function notarize(string memory _document) public {
            proof = proofFor(_document);
      }

      // helper function to get a document's sha256
      // *read-only function*
      function proofFor(string memory _document) internal pure returns (bytes32) {
              return sha256(abi.encodePacked(_document));
      }

}

