// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import '@openzeppelin/contracts/access/Ownable.sol';

contract RewardsSystem is Ownable {

    mapping(address => uint256) public permissions;


    modifier hasPermission(address wallet)
    {
        require(permissions[wallet] > 0, "The wallet doesn't have permission to withdraw");
        _;
    }

    function addPermission(address wallet, uint256 amount) public payable onlyOwner
    {
        uint256 total = amount * 1e18;
        require(msg.value == total, "Invalid deposit amount");
        permissions[wallet] += total;
    }

    function removePermission(address wallet) public onlyOwner
    {
        permissions[wallet] = 0;
    }

    function withdrawAdmin() public onlyOwner
    {
        uint256 balance = address(this).balance;
        require(balance > 0, "Contract has no Ether to withdraw.");

        payable(msg.sender).transfer(balance);
    }

    function withdraw() public hasPermission(msg.sender)
    {
        uint256 amount = permissions[msg.sender];
        require(address(this).balance >= amount, "Insufficient contract balance");
        permissions[msg.sender] = 0; // Remove permission after withdrawal
        payable(msg.sender).transfer(amount);
    }

    function hasPermissionToWithdraw(address wallet) public view returns (bool)
    {
        return permissions[wallet] > 0;
    }

    function WalletRewards(address wallet) public view returns (uint256)
    {
        return permissions[wallet];
    }
}