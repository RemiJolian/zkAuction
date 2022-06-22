pragma circom 2.0.3;

include "../node_modules/circomlib/circuits/poseidon.circom";

template HighestBid (n) {

    signal input blindedBids[n];

    // secret, value, and address
    signal input bids[n][3];

    signal output highestBid[2];
    signal output validBid[n];

    component hashes[n];
    var highestVal = 0;
    var highestBid = 0;
    
    for (var i = 0; i < n; i++) {
      hashes[i] = Poseidon(3);
      hashes[i].inputs[0] <== bids[i][0];
      hashes[i].inputs[1] <== bids[i][1];
      hashes[i].inputs[2] <== bids[i][2];

      if (hashes[i].out == blindedBids[i]) {

        log(bids[i][0] );
        
        if (bids[i][0] > highestVal) {
          highestVal = bids[i][0];
          highestBid = blindedBids[i];
        }
      }
      //valid bid = 1 else 0
      validBid[i] <== hashes[i].out == blindedBids[i];

    }
    log(highestVal);

  highestBid[0] <== highestVal;
  highestBid[1] <== highestBid;

}

component main { public [ blindedBids ] } = HighestBid(4);
