pragma solidity ^0.4.11;


contract Dragon {
    function transfer(address receiver, uint amount)returns(bool ok);
    function balanceOf( address _address )returns(uint256);
}

contract DragonCrowdsale {
    
  
    
    address public beneficiary;
    address public owner;
    address public charity;
    
    address public advisor;
    uint public advisorcut;
    uint public advisorTotal;
    bool public advisorset;
  
    uint public amountRaised; // Total Ether raised
    uint public tokensSold;   // total dragons sold
    uint public crowdsaleCounter; //keeps track of Crowdsale dragon token sales in order to change dragon pricing during sale 
    uint public deadline;         // crowdsale deadline is set when crowdsale begins
    uint public price;            // current price of Dragon token
    uint public preICOspecial;   // Number of tokens that will be sold in precrowdsale
    
    uint public maxTradeSize;
    
    
    uint public preCrowdsaleReserve;
    
    uint public precrowdsaleprice;
    uint public firstroundprice;
    uint public secondroundprice;
    uint public thirdroundprice;
    
    Dragon public tokenReward;
    mapping( address => uint256 ) public dragonBalance;  //keeps dragon token balance of participants from precrowdsale purchases
    mapping( address => uint256 ) public dragonLock;     //keeps track of when purchase was made during precrowdsale to prevennt early withdrawal
    mapping( address => bool )    public preICOparticipated; //keeps track of which address participated in precrowdsale
    
    bool public crowdSaleStart;
    bool public crowdSalePause;
    bool public crowdSaleClosed;
    
    enum Package { Zero, Bronze, Silver, Gold } // 3 different preico sale packages
    
    
    
    Package package;
    
    mapping ( uint => uint ) public packageAwards;
    mapping ( uint => uint ) public packageCharity;
    

   
    event FundTransfer(address participant, uint amount);

    modifier onlyOwner() {
        if (msg.sender != owner) {
            throw;
        }
        _;
    }

    function DragonCrowdsale() {
        
        beneficiary = msg.sender; //beneficiary is initially the contract deployer - change using transferBeneficiary method
        charity = msg.sender; //charity is initially the contract deployer - change using transferCharity method
        owner = msg.sender;// owner is initially the contract deployer
        advisor = 0x243098c1e16973c7e3e969c289c5b87808e359c1; //advisor address
        
        advisorTotal = 1667 ether; //amount to be sent off to advisor contract
        
        
                   
        precrowdsaleprice =.000000000033333333 ether; // preico dragon price
        firstroundprice  = .000000000083333333 ether;  // first round dragon price
        secondroundprice = .000000000100000000 ether; // second round dragon price
        thirdroundprice  = .000000000116686114 ether; // third round dragon price
        
        packageAwards[1]=   10800000000; // pre ico sale bronze package awards
        packageAwards[2]=  108800000000; // pre ico sale silver package awards
        packageAwards[3]= 1088800000000; // pre ico sale gold package awards
        
        packageCharity[1]=    800000000; // bronze package donation amount
        packageCharity[2]=   8800000000; // silver package donation amount
        packageCharity[3]=  88800000000; // gold package donation amount
        
        
        tokenReward = Dragon(  ); //HARD CODE DRAGON TOKEN HERE
        crowdSaleStart = false;
        preICOspecial = 3500000000000000;
        price = precrowdsaleprice;
        
        maxTradeSize = 20000 ether;
    }

    function () payable {
      sale();
    }

    function sale () payable {
        
        require(!crowdSaleClosed);
        require(!crowdSalePause);
        if ( crowdSaleStart) require( now < deadline );
        
        if ( msg.value > maxTradeSize && price != thirdroundprice ) throw;
 
        
        
        
        // only three purchase values acceptable for pre-ico packages
        if( msg.value != .3333333 ether && msg.value != 3.3333333 ether && msg.value != 33.3333333 ether && crowdSaleStart == false  ) throw;
       
        
        
        if ( !crowdSaleStart ) {
            
             if ( preICOparticipated[msg.sender] == true ) throw;
            
            if ( msg.value ==   .3333333 ether ) package = Package.Bronze;
            if ( msg.value ==  3.3333333 ether ) package = Package.Silver;
            if ( msg.value == 33.3333333 ether ) package = Package.Gold;
            preCrowdsale( package );
        } else {
            
            uint _award = msg.value / price;
            
            if ( (tokensSold + _award ) > 8500000000000000 ) throw;
           
            tokenReward.transfer( msg.sender, _award ); // what buyer purchases
            tokensSold += _award;
            crowdsaleCounter += _award;                                     
            if ( crowdsaleCounter > 1000000000000000 &&  crowdsaleCounter < 2500000000000000 ) price = secondroundprice;
            if ( crowdsaleCounter >= 2500000000000000 ) price = thirdroundprice;
            
        }
       
        
       
        amountRaised += msg.value;
        FundTransfer( msg.sender, msg.value );
        
        uint share = msg.value/10;
        
        if ( advisorcut < advisorTotal ) 
         { 
            uint foradvisor = share;
             
           if ( (advisorcut + share) > advisorTotal ) foradvisor = advisorTotal - advisorcut; 
             
           advisor.transfer ( foradvisor ); 
           advisorcut += foradvisor; 
           beneficiary.transfer( share * 9 ); 
           if ( foradvisor != share ) beneficiary.transfer( share - foradvisor ); 
         }
         else { beneficiary.transfer( share * 10 ); } 
        
        
        
        
        
    }
    
    

    function preCrowdsale( Package package )internal{
        
         
        //Bronze Package Award
         if ( package == Package.Bronze  && tokensSold < preICOspecial ) { 
        
            tokenReward.transfer( charity    , packageCharity[1] );  //charitable donation
            dragonBalance[ msg.sender ] += packageAwards[1];
            tokensSold +=  (packageCharity[1] + packageAwards[1]);
            preCrowdsaleReserve += packageAwards[1];
        }
        
        //Silver Package Award
        if ( package == Package.Silver  && tokensSold < preICOspecial ) { 
        
            tokenReward.transfer( charity    , packageCharity[2] );  // charitable donation
            dragonBalance[ msg.sender ] += packageAwards[2];
            tokensSold += ( packageCharity[2] + packageAwards[2] );
            preCrowdsaleReserve += packageAwards[2];
        }
        
        
        //Gold Package Award
        if ( package == Package.Gold  &&  tokensSold < preICOspecial ) { 
        
            tokenReward.transfer( charity    , packageCharity[3] );  // charitable donation
            dragonBalance[ msg.sender ] += packageAwards[3];
            tokensSold += (packageCharity[3] + packageAwards[3]);
            preCrowdsaleReserve += packageAwards[3];
        }
        
         preICOparticipated[ msg.sender ] = true; 
         dragonLock [ msg.sender ] = now + 90 days; //set a 90day freeze on Dragon withdrawals from contract
        
    }



    // Start this to initiate crowdsale - will run for 60 days
    function startCrowdsale() onlyOwner  {
        
        crowdSaleStart = true;
        deadline = now + 60 days;
        price = firstroundprice;
                
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
    
    function transferOwnership ( address _newowner ) onlyOwner {
        
        owner = _newowner;
        
    }
    
    // use this to set the crowdsale beneficiary address
    function transferBeneficiary ( address _newbeneficiary ) onlyOwner {
        
        beneficiary = _newbeneficiary;
        
    }
    
    // use this to set the charity address
    function transferCharity ( address _newcharity ) onlyOwner {
        
        charity = _newcharity;
        
    }
    
    //empty the crowdsale contract of Dragons and forward balance to beneficiary
    function withdrawCrowdsaleDragons() onlyOwner{
        
        uint net;
        uint256 balance = tokenReward.balanceOf(address(this));
        
        net = balance - preCrowdsaleReserve;
        
        tokenReward.transfer( beneficiary, net );
        
        
    }
    
    
    // Tokenholders who purchased in pre-sale will be able to withdraw their Dragons after 90 days have elapsed
    function withdrawDragons(){
        
        require (  now > dragonLock[ msg.sender ]);
        uint _amount = dragonBalance[ msg.sender ];
        dragonBalance[ msg.sender ] = 0;
        
        tokenReward.transfer( msg.sender, _amount ); // what buyer purchases
        preCrowdsaleReserve -= _amount;
        
        
    }
    
    
    // withdraw any Ether in the contract
    function withdrawEther() onlyOwner {
        
        beneficiary.send(this.balance);
        
    }
    
}
