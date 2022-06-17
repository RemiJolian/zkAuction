# zkAuction


## Proposal Overview

ZKAuction is a zero knowledge based blind auction that keeps the privacy of the bidders including their addresses and the bid amount. Each bidder deposits a small amount to encourage the bidder to come back and send multiple transactions/proofs. The system will have a time range in which bidders are allowed to send transactions. Once the time is over, the winning bid is exposed.

## Design

TODO


## Smart contract

The `Auction.sol` contract used to store auction information on chain. The `Auction` struct stores auction name, expiration date, and also takes array of struct `Bid` to store the encrypted price and the secret.

```javascript
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

mapping(uint256 => Auction) public auctions;
```

Link to the `Auction.sol` contract [here](https://github.com/RemiJolian/zkAuction/blob/main/contracts/Auction.sol).

## Circuit

Circuit for the BlindAuction:
https://github.com/RemiJolian/zkAuction/blob/main/contracts/circuits/auction.circom


## UI


## TODO
 -  Encrypt the price in the Auction.sol
 -  
