// Get funds from users
// Withdraw funds
// Set a minmum fundinng value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { PriceConverter } from './PriceConverter.sol';

contract FundMe {
    // allow user to send $
    // have a minimun $ send

    using PriceConverter for uint256;

    uint256 public minimumUsd = 1e18;
    address[] public funders;
    mapping(address funder => uint256 amountFuned) public  addressToAmountFuned;

    address public owner;
    // when contract init run this code
    constructor() {
       owner = msg.sender;
    }

    function fund() public payable{
        // 1. how do we sent ETH to this contract
        // 1 ether = 1000000000000000000 wei = 1*10**18 wei = 1e18 wei
        // require(msg.value > 1e18, "Didn't send enough ETH");
        // require(msg.value > 1 ether, "Didn't send enough ETH");
        // require(getConvertionRate(msg.value) >= minimumUsd, "Didn't send enough ETH");
        require(msg.value.getConvertionRate() >= minimumUsd, "Didn't send enough ETH");
        // msg.sender
        funders.push(msg.sender);
        addressToAmountFuned[msg.sender] =  addressToAmountFuned[msg.sender] + msg.value;
    }

    function withdraw() public {
        require(owner == msg.sender, "Must be owner!");
        for (uint256 funderIndex = 0; funderIndex <  funders.length; funderIndex++) {
            // get funders address
            address funder = funders[funderIndex];
            addressToAmountFuned[funder] = 0;
        }
        // reset array
        funders = new address[](0);
        // withdraw the funds
        // https://solidity-by-example.org/sending-ether/  transfer send call

        // transfer 
        // payable(msg.sender).transfer(address(this).balance);
        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send fail");
        // call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "call fail");

    }

}
