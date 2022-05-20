// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./SafeMath.sol";

interface IERC20 {

    //returns quantity of all tokens
    function totalSupply() external view returns(uint256);

    //returns quantity of token in address
    function balanceOf(address account) external view returns(uint256);

    //returns tokens number that the spender will be able to spend on behalf of the owner
    function allowance(address owner, address spender) external view returns(uint256);

    //returns a boolean value resulting from the indicated operation
    function transfer(address recipient, uint256 amount) external returns(bool);

    //returns a boolean value with the result of the spending operation
    function approve(address spender, uint256 amount) external returns(bool);

    //returns a boolean value with the result of the operation of passing a number of tokens using allowance()
    function transferFrom(address sender, address recipient, uint256 amount) external returns(bool);

    //event emitted when a token transaction is performed
    event Transfer(address indexed from, address indexed to, uint256 value);

    //event emitted when an allowance is set with the allowance() method
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract ERC20Basic is IERC20 {

    //constants
    string public constant name = "MARTINEZCOIN";
    string public constant symbol = "MZC";
    uint8 public constant decimals = 8;

    //available events in interface (not necessary to implement in contract in 0.8.0)
    //event Transfer(address indexed from, address indexed to, uint256 tokens);
    //event Approval(address indexed owner, address indexed spender, uint256 tokens);

    //implements SafeMath v4.6.0 library for uint256
    using SafeMath for uint256;

    //storage objects and variables
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    uint256 totalSupply_;

    //constructor is public for testing
    constructor(uint256 initalSupply) public {
        totalSupply_ = initalSupply;
        balances[msg.sender] = totalSupply_;
    }

    //functions
    function totalSupply() public override view returns(uint256) {
        return totalSupply_;
    }

    function increaseTotalSupply(uint newTokensAmount) public {
        totalSupply_ += newTokensAmount;
        balances[msg.sender] += newTokensAmount;
    }

    function balanceOf(address tokenOwner) public override view returns(uint256) {
        return balances[tokenOwner];
    }

    function allowance(address owner, address delegate) public override view returns(uint256) {
        return allowed[owner][delegate];
    }

    function transfer(address recipient, uint256 numTokens) public override returns(bool) {
        require(numTokens <= balances[msg.sender],"Not suficient tokens to send");
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[recipient] = balances[recipient].add(numTokens);
        emit Transfer(msg.sender, recipient, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns(bool) {
        require(numTokens <= balances[owner],"Not suficient tokens to send");
        require(numTokens <= allowed[owner][msg.sender],"Not allowed tokens to send");

        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);

        emit Transfer(owner, buyer, numTokens);

        return true;
    }
}
