// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "../lib/forge-std/src/Test.sol";
import {DeployMyToken} from "../script/DepoyMyToken.s.sol";
import {MyToken} from "../src/myToken.sol";


contract MyTokenTest is Test{
    MyToken public myToken;
    DeployMyToken public deployer;

    uint256 public constant STARTING_BALANCE = 100 ether;

    address _bob = makeAddr("bob");
    address _alice = makeAddr("alice");

    function setUp() public {
        deployer = new DeployMyToken();
        myToken = deployer.run();

        //owner should be the deployer
        vm.prank(address(msg.sender));
        //tranfer tokens to bob
        myToken.transfer(_bob,STARTING_BALANCE);
    }
    function testBobBalance() public {
        assertEq(STARTING_BALANCE, myToken.balanceOf(_bob));
    }
    function testAllowancesWorks() public {
        uint256 initialAllowance = 1000;

        //Bob approves Alice to spend tokens on her behalf
        vm.prank(_bob);
        myToken.approve(_alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(_alice);
        myToken.transferFrom(_bob, _alice, transferAmount);

        assertEq(myToken.balanceOf(_alice), transferAmount);
        assertEq(myToken.balanceOf(_bob), STARTING_BALANCE - transferAmount);
    } 
    
    function testTransfer() public{
        uint256 amount= 100;
        address recepient = address(0x1);
        vm.prank(msg.sender);
        myToken.transfer(recepient,amount);
        assertEq(myToken.balanceOf(recepient), amount);
    }

    function testBalanceAfterTransfer() public{
        uint256 amount= 100;
        address recepient = address(0x1);
        uint256 initialBalance = myToken.balanceOf(msg.sender);
        vm.prank(msg.sender);
        myToken.transfer(recepient, amount);
        assertEq(myToken.balanceOf(msg.sender), initialBalance - amount);
    }
    function testTransferFrom() public {
        uint256 amount = 100;
        address receiver= address(0x1);
        vm.prank(msg.sender);
        myToken.approve(address(this), amount);
        myToken.transferFrom(msg.sender,receiver,amount);
        assertEq(myToken.balanceOf(receiver), amount);
    }
}
