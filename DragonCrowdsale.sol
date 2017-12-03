pragma solidity ^0.4.11;



contract DragonCrowdsaleCore {
    
    function crowdsale( address _address )payable;
    function precrowdsale( address _address )payable;
}

contract DragonCrowdsale {
    
    address public owner;
    
    
   
    bool public crowdSaleStarted;
    bool public crowdSaleClosed;
    bool public  crowdSalePause;
    
    uint public deadline;
    
    DragonCrowdsaleCore core;
    
    
    
    
    modifier onlyOwner() {
        if (msg.sender != owner) {
            throw;
        }
        _;
    }

    
    
    
    function DragonCrowdsale(){
        
        crowdSaleStarted = false;
        crowdSaleClosed = false;
        crowdSalePause = false;
        owner = msg.sender;
        
    }
    
    // fallback function to receive all incoming ether funds and then forwarded to the DragonCrowdsaleCore contract 
    function () payable {
        
        require ( crowdSaleClosed == false && crowdSalePause == false  );
        
        if ( crowdSaleStarted ) { 
            require ( now < deadline );
            core.crowdsale.value( msg.value )( msg.sender); 
            
        } 
        else
        { core.precrowdsale.value( msg.value )( msg.sender); }
       
    }
    
    
   
    // Start this to initiate crowdsale - will run for 60 days
    function startCrowdsale() onlyOwner  {
        
        crowdSaleStarted = true;
        deadline = now + 60 days;
       
                
    }

    //terminates the crowdsale
    function endCrowdsale() onlyOwner  {
        
        
        crowdSaleClosed = true;
    }

    //pauses the crowdsale
    function pauseCrowdsale() onlyOwner {
        
        crowdSalePause = true;
        
        
    }

    //unpauses the crowdsale
    function unpauseCrowdsale() onlyOwner {
        
        crowdSalePause = false;
        
        
    }
    
    // set the dragon crowdsalecore contract
    function setCore( address _core ) onlyOwner {
        
        core = DragonCrowdsaleCore( _core );
        
    }
    
    function transferOwnership( address _address ) onlyOwner {
        
        owner =  _address ;
        
    }
    
    
    
    
    
    
    
}
