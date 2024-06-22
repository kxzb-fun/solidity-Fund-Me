# Fund Me Introduction

Introduction to decentralized crowdfunding contract 'FundMe.sol', allowing users to send native blockchain cryptocurrency, with the owner being able to withdraw the funds. The lesson covers deploying on a testnet and handling transactions in Ethereum, Polygon, or Avalanche.

## Sending ETH through a function

### How Does the Transaction Work?

### Enabling Our Function to Accept Cryptocurrency

```sol
function fund() public payable{...}
```

### Holding Funds in Contract

Just as wallets hold funds, contracts can serve a similar role. Following deployment, a contract behaves almost identically to a wallet address. It can receive funds, interact with them, and as seen in our demo, the contract can amass a balance akin to a wallet.

### Transaction Value - The Message Value

```sol
msg.value
```

### Implementing Requirements for Transactions

```sol
require(msg.value > 1 ether, "Didn't send enough ETH");

```

### Reverting Transactions

If a user attempts to send less than the required amount, the transaction will fail and a message will be displayed. For instance, if a user attempts to send 1000 wei, which is significantly less than one ether (1 x 10^18 wei), the transaction will not proceed.

