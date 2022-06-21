// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@semaphore-protocol/contracts/interfaces/IVerifier.sol";
import "@semaphore-protocol/contracts/base/SemaphoreCore.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Auction  is SemaphoreCore, Ownable{
    
    // users are identified by a Merkle root.
    // The offchain Merkle tree contains the users' identity commitments.
    uint256 public users;

   uint public auction_no = 0;
   mapping(uint256 => Auction) public auctions;

   // The external verifier used to verify Semaphore proofs.
    IVerifier public verifier;

    constructor(uint256 _users, address _verifier) {
        users = _users;
        verifier = IVerifier(_verifier);
    }

   struct Bid {
       uint price;
       string secret;
   }

    struct Auction {
        string name;
        uint expire_date;
        bool active;
        Bid[] bids;
    }

    // Auction[] public auctions;

    function createAuction(string memory _name, uint _date) public {
        Auction storage a = auctions[auction_no];
        a.name = _name;
        a.expire_date = _date;
        a.active = true;
        
        auction_no++;
    }

    function getAuction(uint _index) public view returns (string memory name, uint expire_date, bool active, Bid[] memory bids) {
        Auction storage auction = auctions[_index];
        return (auction.name, auction.expire_date, auction.active, auction.bids);
    }

    //disable the auction
    function deactivate(uint _index) public {
        Auction storage auction = auctions[_index];
        auction.active = false;
    }

    function addBid(uint _index, uint _price, string memory _secret, uint256 _nullifierHash,
        uint256[8] calldata _proof) external onlyOwner {
        _verifyProof( _secret, users, _nullifierHash, users, _proof, verifier);    
         _saveNullifierHash(_nullifierHash);
        Auction storage auction = auctions[_index];
        auction.bids.push (Bid({
            price: _price,
            secret: _secret
        }));
    }

}
