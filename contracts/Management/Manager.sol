//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {Sextons} from "contracts/AccessControl/Sextons.sol";

//Reaper Treasury Interface
interface IReaperTreasury {
    function withdrawFTM(address _to, uint256 _amount) external; 
    function withdrawTokens(address _token, address _to, uint256 _amount) external;
    function setAccountant(address _addr) external;
}

//Spookyswap Interface 
interface ISalesManager {
    function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external;
    function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint256 deadline) external; 
    function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address path, address to, uint256 deadline) external;
    function swapTokensForExactTokens(uint256 amountIn, uint256 amountOutMin, address path, address to, uint256 deadline) external;
}

contract Manager is Sextons {
    address spooky = 0xF491e7B69E4244ad4002BC14e878a34207E38c29;
    address treasury = 0x0e7c5313E9BB80b654734d9b7aB1FB01468deE3b;
    address remitter = 0xa68EdaE6eA103A03021B08C4c56eb9263a93CD64;
    address multisig = 0x111731A388743a75CF60CCA7b140C58e41D83635;
    address USDC = 0x04068DA6C83AFCFA0e13ba15A6696662335D5B75;
    
    struct Withdrawal {
        uint amount;
        address token;
        uint timestamp;
        bool verified;
    }
     
    mapping (uint => Withdrawal) public withdrawals;

    uint counter = 0;
    
    event withdrawal(address to, uint amount, address token, uint timestamp);
    event sellToken(address to, uint amount, address token, uint timestamp);
    event multisigFunded(address to, uint amount, address token, uint timestamp);
    event remitterFunded(address to, uint amount, address token, uint timestamp);

    //Treasury functions
    function withdrawalFTM(address _to, uint _amount) public onlyRole(REAPER) {
        IReaperTreasury(treasury).withdrawFTM(_to, _amount);
    }

    function withdrawTokens(address _token, address _to, uint256 _amount) public onlyRole(REAPER) {
        IReaperTreasury(treasury).withdrawTokens(_token, _to, _amount);
    }
    
    //Liquidity creation functions
    function createSpookyLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint256 deadline) public onlyRole(REAPER) {
        ISalesManager(spooky).addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin, to, deadline);
    }
           
    //Fund Remitter
    function _sendUSDCToRemitter(address _token, uint _amount) internal {   
        withdrawals[counter] = Withdrawal(_amount, remitter, block.timestamp, false);
        counter++;
        IERC20(_token).transfer(remitter, _amount);    
    }

    function sendUSDCToRemitter(address _token, uint _amount) external onlyRole(REAPER) {
        _sendUSDCToRemitter(_token, _amount);
        emit remitterFunded(remitter, _amount, _token, block.timestamp);
    }

    //Sends ANY Token to Byte Mason Multisig
    function _sendANYToken(address _token, uint _amount) internal {   
        withdrawals[counter] = Withdrawal(_amount, multisig, block.timestamp, false);
        counter++;
        IERC20(_token).transfer(multisig, _amount);
    }

    function sendANYToken(address _token, uint _amount) external onlyRole(REAPER) {
        _sendANYToken(_token, _amount);
        emit multisigFunded(multisig, _amount, _token, block.timestamp);
    }
    
    //Get Withdrawals log
    function getAllWithdrawals() external view returns (Withdrawal[] memory) {   
       
    }   

}


