pragma solidity ^0.5.0;

/* taking ideas from FirstBlood token */
contract SafeMath {
    /*
    /*
    /* solidity is on 0.5.0 */
    function safeAdd(uint256 x, uint256 y) public pure returns(uint256) {
      uint256 z = x + y;
      assert((z >= x) && (z >= y));
      return z;
    }

    function safeSubtract(uint256 x, uint256 y) public pure returns(uint256) {
      assert(x >= y);
      uint256 z = x - y;
      return z;
    }

    function safeMult(uint256 x, uint256 y) public pure returns(uint256) {
      uint256 z = x * y;
      assert((x == 0)||(z/x == y));
      return z;
    }
}

contract Token is SafeMath {
    // metadata
    string  public name = "US Forestry Token";
    string  public symbol = "USF";
    uint256 public totalSupply = 1000000000000000000000000000; // 1 billion tokens
    uint8   public decimals = 18;
    string  public version = 'version 1.0.0';

    // contracts
    address public ethFundDeposit;
    address public usfFundDeposit;

    // crowdsale parameters
    bool public isFinalized;
    uint256 public fundingStartBlock;
    uint256 public fundingEndBlock;
    uint256 public investmentMinimum = 1570000000000000000; // 1.57 ETH in WEI
    uint256 public constant usfFund = 900000000000000000000000000;  // 900m USF reserved for US Forestry Foundation use.
    // ToDo: set up the increasing exchange rate to increase every 500K tokens
    uint256 public constant tokenExchangeRate = 5000;// 5000 USF Tokens per ETH

    // Cap it at 1 Billion tokens
    uint256 public constant tokenCreationCap = 1000000000000000000000000000;

    // log the transfer function
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    // log the approval function
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    // log the mint function every time the contract mints tokens
    event CreateUSF(
        address indexed _to,
        uint256 _value
    );

    // log every refund if the sale fails
    event LogRefund(
        address indexed _to,
        uint256 _value
    );

    event Burn(
        address indexed _from,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public freezeOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor() public {
        // set the total supply
        balanceOf[msg.sender] = totalSupply;

        // todo: deposit founders, owners, partners shares

    }

    // ToDo: Add onlyOwner
    // @dev accepts ether and mints tokens to the msg.sender and uses the msg.value passed
    function createTokens(address _to, uint256 _value) public payable {
        require(isFinalized, 'Sale has been finalized!');
        require(block.number < fundingStartBlock, 'Sorry, you cannot cheat!');
        require(block.number > fundingEndBlock, 'Sorry, you cannot cheat!');
        require(msg.value == 0, 'You need money, silly...');

        //uint256 tokens =
        // make sure they have enough
        require(balanceOf[msg.sender] >= _value, 'not enough ether');
        balanceOf[msg.sender] += _value;
        emit CreateUSF(_to, _value);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, 'not enough ether');
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from], 'not enough ether');
        require(_value <= allowance[_from][msg.sender], 'over allowance');
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}



