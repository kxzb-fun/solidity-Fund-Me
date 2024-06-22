// Get funds from users
// Withdraw funds
// Set a minmum fundinng value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts@1.1.1/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    // allow user to send $
    // have a minimun $ send

    uint256 public minimumUsd = 1e18;
    address[] public funders;
    mapping(address funder => uint256 amountFuned) public  addressToAmountFuned;

    function fund() public payable{
        // 1. how do we sent ETH to this contract
        // 1 ether = 1000000000000000000 wei = 1*10**18 wei = 1e18 wei
        // require(msg.value > 1e18, "Didn't send enough ETH");
        // require(msg.value > 1 ether, "Didn't send enough ETH");
        require(getConvertionRate(msg.value) >= minimumUsd, "Didn't send enough ETH");
        // msg.sender
        funders.push(msg.sender);
        addressToAmountFuned[msg.sender] =  addressToAmountFuned[msg.sender] + msg.value;
    }

    // function withdraw() public {

    // }

    function getPrice() public view  returns(uint256) {
        // from this url get address  https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1
        // address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (
            /* uint80 roundId */, 
            int256 answer, 
            /* uint256 startedAt */,
            /* uint256 updatedAt */, 
            /* uint80 answeredInRound */
         ) = priceFeed.latestRoundData();
        return uint256(answer * 1e10);
    }

    function getConvertionRate (uint256 ethAmount) public view returns(uint256) {
        // 1 ETH ?
        // 2000_1*10*18
        uint256 ethPrice = getPrice();
        //  2000_1*10*18 *  1*10*18 / 1*10*18
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        // $2000 = 1 ETH
        return ethAmountInUsd;
    }

    function getVersion() public view returns(uint256) {
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}
