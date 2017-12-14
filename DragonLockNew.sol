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
    address public dragoncrowdsale;
    
    mapping ( address => uint ) public dragonBalance;
   
    
    uint public TimeLock;
 
    
    
    modifier onlyDragonCrowdsale () {
        if (msg.sender != dragoncrowdsale ) {
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
        
        tokenreward = Dragon (  0x814f67fa286f7572b041d041b1d99b432c9155ee ); // dragon token address
        TimeLock = now + 90 days;
       
        owner = msg.sender;
        
    }
    
    
    
    
    function withdrawDragons(){
        
        require ( now > TimeLock );
        uint bal = dragonBalance [ msg.sender ];
        dragonBalance [ msg.sender ] = 0;
        tokenreward.transfer ( msg.sender , bal );
        
    }
    
    
    
    function creditDragon ( address tokenholder, uint amount ) onlyOwner {
        
      
        dragonBalance [ tokenholder ] += amount;
        
    }
    
   
    
    function transferOwnership ( address _newowner ) onlyOwner {
        
        owner = _newowner;
        
    }
    
    
   
    
    
}