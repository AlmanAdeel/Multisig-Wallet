//// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {Multisig} from "src/multisig.sol";


contract DeployWallet is Script{
    function run() external {
        deploycontract();
    
    }

    function deploycontract() public returns(address[] memory,uint256,Multisig){
        address[] memory owners = new address[](3);
        owners[0] = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
        owners[1] = 0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc;
        owners[2] = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;
        uint256 required =2;
        vm.startBroadcast();
        Multisig multiSig = new Multisig(owners,required);
        vm.stopBroadcast();
        return(owners,required,multiSig);
    }
}