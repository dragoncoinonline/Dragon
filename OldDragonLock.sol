pragma solidity ^0.4.11;


contract Dragon {
    
    function transfer(address receiver, uint amount)returns(bool ok);
    function balanceOf( address _address )returns(uint256);

    
}


contract DragonCrowdsale {
    
    function beneficiary() returns ( address );
    
}


contract DragonLock {
    
    address public owner;
    Dragon public tokenreward; 
    address public dragoncrowdsalecore;
    
    mapping ( address => uint ) public dragonBalance;
    mapping ( address => bool ) public participated;
    
    uint public TimeLock;
 
    
    
    modifier onlyDragonCrowdsale () {
        if (msg.sender != dragoncrowdsalecore ) {
            throw;
        }
        _;
    }
    
    
    
    modifier onlyOwner () {
        if ( msg.sender != owner ) {
            throw;
        }
        _;
    }
    
    function DragonLock (){
        
        tokenreward = Dragon (   ); // dragon token address
        TimeLock = now + 90days;
        dragoncrowdsalecore =  // dragon crowdsalecore address
        owner = msg.sender;
        
    }
    
    
    
    
    function withdrawDragons(){
        
        require ( now > TimeLock );
        uint bal = dragonBalance [ msg.sender ];
        dragonBalance [ msg.sender ] = 0;
        tokenreward.transfer ( msg.sender , bal );
        
    }
    
    
    
    function creditDragon ( address tokenholder, uint amount ) onlyDragonCrowdsale {
        
        require ( participated [ tokenholder ] == false );
        participated [ tokenholder ] = true;
        dragonBalance [ tokenholder ] += amount;
        
    }
    
   
    
    function transferOwnership ( address _newowner ) onlyOwner {
        
        owner = _newowner;
        
    }
    
    function alreadyParticipated ( address _address ) returns ( bool ){
        
        return participated[ _address ];
        
    }
    
    
}
