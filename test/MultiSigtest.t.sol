//// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Test,console} from "forge-std/Test.sol";
import {Multisig} from 'src/multisig.sol';
import {DeployWallet} from "script/DeployMultiSig.s.sol";

contract TestMultisig is Test{
    Multisig public multisig;
    address public constant nonowner = 0x90F79bf6EB2c4f870365E785982E1f101E93b906;
    uint256 public required;
    address[] public _owners;
    address public PERSON = makeAddr("person");
    

    event Submit(uint256 indexed txId);

    function setUp() external{
        DeployWallet deployer = new DeployWallet();
        (_owners,required,multisig) = deployer.deploycontract();
    }

    function testOnlyOwnerCanCallTheSubmitFunctionElseItreverts() public {
        vm.prank(nonowner);
        vm.expectRevert();
        multisig.submit(PERSON,2 ether,'');
        console.log("you are not the owner");
    }

    function testOnlyOwnerCanCallSubmit() public {
        vm.prank(_owners[1]);
        multisig.submit(PERSON,2 ether,'');
        console.log("hey it works");
        (address to ,uint256 value,bool exectuted ) = multisig.getSpecificTransactionReport(0);
        assertEq(to,PERSON);
        assertEq(value,2 ether);
        assertEq(exectuted,false);
    }

    function testEventEmitsWhenSumbitIsCalled() public {
        vm.expectEmit(true,false,false,false);
        uint256 length = multisig.getTransactionCount();
        emit Submit(length);
        vm.prank(_owners[1]);
        multisig.submit(PERSON,2 ether,'');
        
    }
    function testOwnerCanApproveTransaction() public {
        // Submit a transaction
        vm.prank(_owners[1]);
        multisig.submit(PERSON, 2 ether, "");

        // Approve the transaction
        vm.prank(_owners[0]);
        multisig.approve(0);

        // Check that the approval is recorded
        assertTrue(multisig.approved(0, _owners[0]));
    }

    function testNonOwnerCannotApproveTransaction() public {
        // Submit a transaction
        vm.prank(_owners[1]);
        multisig.submit(PERSON, 2 ether, "");

        // Attempt to approve the transaction as a non-owner
        address nonOwner = address(0x1234567890123456789012345678901234567890);
        vm.prank(nonOwner);
        vm.expectRevert("not owner");
        multisig.approve(0);
    }

    function testOwnerCannotApproveTransactionTwice() public {
        // Submit a transaction
        vm.prank(_owners[1]);
        multisig.submit(PERSON, 2 ether, "");

        // Approve the transaction once
        vm.prank(_owners[0]);
        multisig.approve(0);

        // Attempt to approve the transaction again
        vm.prank(_owners[0]);
        vm.expectRevert("txId already approved");
        multisig.approve(0);
    }

    function testGetApprovalCount() public {
        // Submit a transaction
        vm.prank(_owners[1]);
        multisig.submit(PERSON, 2 ether, "");

        // Approve the transaction by two owners
        vm.prank(_owners[0]);
        multisig.approve(0);

        vm.prank(_owners[1]);
        multisig.approve(0);

        // Check the approval count
        uint256 approvalCount = multisig.getApprovelCount(0);
        assertEq(approvalCount, 2);
    }

    // Test that a transaction can be executed if the required number of approvals is met
    function testExecuteTransaction() public {
        // Submit a transaction
        vm.prank(_owners[1]);
        multisig.submit(PERSON, 2 ether, "");

        // Approve the transaction by the required number of owners
        vm.prank(_owners[0]);
        multisig.approve(0);

        vm.prank(_owners[1]);
        multisig.approve(0);
        vm.deal(address(multisig),2 ether);
        // Execute the transaction
        vm.prank(_owners[2]);
        multisig.execute(0);

        // Check that the transaction is executed
        (, , bool executed) = multisig.getSpecificTransactionReport(0);
        assertTrue(executed);
    }

    // Test that a transaction cannot be executed if the required number of approvals is not met
    function testCannotExecuteTransactionWithoutEnoughApprovals() public {
        // Submit a transaction
        vm.prank(_owners[1]);
        multisig.submit(PERSON, 2 ether, "");

        vm.prank(_owners[0]);
        multisig.approve(0);

        // Attempt to execute the transaction
        vm.prank(_owners[1]);
        vm.expectRevert("approvels not fullfilled");
        multisig.execute(0);
    }

    // Test that a transaction cannot be executed twice
    function testCannotExecuteTransactionTwice() public {
        vm.prank(_owners[1]);
        multisig.submit(PERSON, 2 ether, "");

        // Approve the transaction by the required number of owners
        vm.prank(_owners[0]);
        multisig.approve(0);

        vm.prank(_owners[1]);
        multisig.approve(0);

        vm.deal(address(multisig),2 ether);
        vm.prank(_owners[2]);
        multisig.execute(0);

        // Attempt to execute the transaction again
        vm.prank(_owners[2]);
        vm.expectRevert();
        multisig.execute(0);
    }

    // Test that the txExist modifier works correctly
    function testTxExistModifier() public {
        // Attempt to approve a non-existent transaction
        vm.prank(_owners[0]);
        vm.expectRevert();
        multisig.approve(999); // txId 999 does not exist
    }





}