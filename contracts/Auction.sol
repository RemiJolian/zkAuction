// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Auction {
   uint public auction_no = 0;
   mapping(uint256 => Auction) public auctions;

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

    function addBid(uint _index, uint _price, string memory _secret) public {
        Auction storage auction = auctions[_index];
        auction.bids.push (Bid({
            price: _price,
            secret: _secret
        }));
    }

}
