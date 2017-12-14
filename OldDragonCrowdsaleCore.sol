pragma solidity ^0.4.11;



contract Dragon {
    function transfer(address receiver, uint amount)returns(bool ok);
    function balanceOf( address _address )returns(uint256);
}

contract PricingStructureContract{
    
    function precrowdsale( address tokenholder, uint value ) returns ( uint , uint);
    function crowdsale( address tokenholder, uint value  ) returns ( uint , uint);
    
}

contract DragonLock {
    
    function creditDragon ( address tokenholder, uint balance );
    function alreadyParticipated ( address _address ) returns ( bool );
    
    
}

contract DragonCrowdsaleCore {
    
    address public owner;
    address public beneficiary;
    address public charity;
    address public advisor;
    address public front;
    bool public advisorset;
    
    uint public tokensSold;
    uint public etherRaised;
    uint public presold;
    uint public presoldMax;
    
    uint public crowdsaleCounter;
    
    uint public deadline;
    
    uint public advisorTotal;
    uint public advisorCut;
    
    Dragon public tokenReward;
    address public DragonLockAddress; 
    DragonLock dragonlock;
    
    event ShowBool ( bool );
    
    
    PricingStructureContract public pricingstructure;
    bool public crowdSaleStarted;
    bool public crowdSaleClosed;
    bool public  crowdSalePause;
    
    modifier onlyOwner() {
        if (msg.sender != owner) {
            throw;
        }
        _;
    }
    
    modifier onlyFront() {
        if (msg.sender != front) {
            throw;
        }
        _;
    }


    
    
    
    function DragonCrowdsaleCore(){
        
        tokenReward = Dragon(  ); // Dragon Token Address
        owner = msg.sender;
        beneficiary = msg.sender;
        charity = msg.sender;
        advisor = msg.sender;
        crowdSaleStarted = false;
        advisorset = false;
        crowdSaleClosed = false;
        crowdSalePause = false;
        presold = 0;
        presoldMax = 3500000000000000;
        crowdsaleCounter = 0;
        
        advisorCut = 0;
        advisorTotal = 1667 ether;
    }
    
   
    // runs during precrowdsale
    function precrowdsale ( address tokenholder ) onlyFront payable {
        
        
      
        uint award;  // amount of dragons to credit to tokenholder
        uint donation; // donation to charity
        
        
      
        
             assert ( dragonlock.alreadyParticipated( tokenholder ) == false ) ;  
            ( award, donation ) = pricingstructure.precrowdsale( tokenholder , msg.value ); 
            
            
            dragonlock.creditDragon ( tokenholder , award );
            tokenReward.transfer ( charity , donation );
            presold += award;
            tokensSold  += donation;
            
            
         
        
       tokenReward.transfer ( DragonLockAddress , award );
       
       if ( advisorCut < advisorTotal ) { advisorSiphon();} 
       
        else 
          { beneficiary.transfer ( msg.value ); }
        
        
       etherRaised += msg.value; // tallies ether raised
       tokensSold  += award; // tallies total dragons sold
        
        
        
        
        
    }
    
    // runs when crowdsale is active
    function crowdsale ( address tokenholder  ) onlyFront payable {
        
        
        uint award;  // amount of dragons to send to tokenholder
        uint donation; // donation to charity
        ( award , donation ) = pricingstructure.crowdsale( tokenholder, msg.value ); 
         crowdsaleCounter += award;
        
        tokenReward.transfer ( tokenholder , award );
       
        if ( advisorCut < advisorTotal ) { advisorSiphon();} 
       
        else 
          { beneficiary.transfer ( msg.value ); }
        
        
       etherRaised += msg.value; // tallies ether raised
       tokensSold  += award; // taliles total dragons sold
        
        
        
    }
    
    
    // pays the advisor part of the incoming ether
    function advisorSiphon() internal {
        
         uint share = msg.value/10;
         uint foradvisor = share;
             
           if ( (advisorCut + share) > advisorTotal ) foradvisor = advisorTotal - advisorCut; 
             
           advisor.transfer ( foradvisor );  // advisor gets 10% of the incoming ether
           advisorCut += foradvisor; 
           beneficiary.transfer( share * 9 ); // the balance goes to the benfeciary
           if ( foradvisor != share ) beneficiary.transfer( share - foradvisor ); // if 10% of the incoming ether exceeds the total advisor is supposed to get , then this gives them a smaller share to not exceed max
        
        
        
    }
    
   
    
    // transfers ownership of the crowdsale contract
    function transferOwnership ( address _newowner ) onlyOwner {
        
        owner = _newowner;
        
    }
    
    // use this to set the crowdsale beneficiary address
    function transferBeneficiary ( address _newbeneficiary ) onlyOwner {
        
        beneficiary = _newbeneficiary;
        
    }
    
    // use this to set the charity address
    function transferCharity ( address _charity ) onlyOwner {
        
        charity = _charity;
        
    }
    
    // sets crowdsale address
    function setFront ( address _front ) onlyOwner {
        
        front = _front;
        
    }
    // sets advisors address
    function setAdvisor ( address _advisor ) onlyOwner {
        
        require ( advisorset == false );
        advisorset = true;
        advisor = _advisor;
        
    }
    
    // sets the presale dragon lock contract address
    function setDragonLockAddress ( address _dragonlockaddress ) onlyOwner {
        
        DragonLockAddress = _dragonlockaddress;
        dragonlock = DragonLock ( DragonLockAddress );
        
    }
        

    // sets the contract address to the dragon pricing scheme
    function setPricingStructure ( address _pricingstructure ) onlyOwner {
        
        pricingstructure = PricingStructureContract ( _pricingstructure );
        
    }    
    
    
    //empty the crowdsale contract of Dragons and forward balance to beneficiary
    function withdrawCrowdsaleDragons() onlyOwner{
        
        uint256 balance = tokenReward.balanceOf( address( this ) );
        tokenReward.transfer( beneficiary, balance );
        
        
    }
   
    
    
    
    
    
}
