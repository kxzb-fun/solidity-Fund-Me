// Get funds from users
// Withdraw funds
// Set a minmum fundinng value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { PriceConverter } from './PriceConverter.sol';

// Custom Errors in Solidity https://soliditylang.org/blog/2021/04/21/custom-errors/
error NotOwner();

contract FundMe {
    // allow user to send $
    // have a minimun $ send

    using PriceConverter for uint256;
    // Immutability and constants
    uint256 public constant MINIMUN_USD = 1e18;
    address[] public funders;
    mapping(address funder => uint256 amountFuned) public  addressToAmountFuned;

    address public immutable i_owner;
    // when contract init run this code
    constructor() {
       i_owner = msg.sender;
    }

    function fund() public payable{
        // 1. how do we sent ETH to this contract
        // 1 ether = 1000000000000000000 wei = 1*10**18 wei = 1e18 wei
        // require(msg.value > 1e18, "Didn't send enough ETH");
        // require(msg.value > 1 ether, "Didn't send enough ETH");
        // require(getConvertionRate(msg.value) >= MINIMUN_USD, "Didn't send enough ETH");
        require(msg.value.getConvertionRate() >= MINIMUN_USD, "Didn't send enough ETH");
        // msg.sender
        funders.push(msg.sender);
        addressToAmountFuned[msg.sender] =  addressToAmountFuned[msg.sender] + msg.value;
    }

    function withdraw() public onlyOwner {
        
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

    modifier onlyOwner () {
        // first solution
        // require(i_owner == msg.sender, "Must be owner!");
        // section solution
        if(i_owner == msg.sender) { revert NotOwner();}
        _;
    }

    // what happens if somebody send this contract ETH without calling the fund function?  
    // two  sepesceil function receive() fallback()
    receive() external payable  {
        fund();
    }

    fallback() external payable { 
        fund();
    }


}
