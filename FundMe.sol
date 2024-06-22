// Get funds from users
// Withdraw funds
// Set a minmum fundinng value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FundMe {
    // allow user to send $
    // have a minimun $ send

    function fund() public payable{
        // 1. how do we sent ETH to this contract
        // 1 ether = 1000000000000000000 wei = 1*10**18 wei = 1e18 wei
        require(msg.value > 1e18, "Didn't send enough ETH");
        // require(msg.value > 1 ether, "Didn't send enough ETH");
    }

    // function withdraw() public {

    // }
}
