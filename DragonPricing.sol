pragma solidity ^0.4.11;




contract DragonCrowdsaleCore {
    
     function crowdsaleCounter() returns ( uint );
     function presold() returns ( uint );    
     function presoldMax() returns ( uint );
    
}


contract DragonPricing {
    
    address public dragoncrowdsalecoreaddress;
    DragonCrowdsaleCore dragoncrowdsalecore;
    
    uint public constant firstroundprice  = .000000000083333333 ether;
    uint public constant secondroundprice = .000000000100000000 ether;
    uint public constant thirdroundprice  = .000000000116686114 ether;
    
    uint public price;
    
    
    function DragonPricing() {
        
        dragoncrowdsalecoreaddress = 0xFf3F4bACc80f936145f21214342835073B1cC805; // dragon crowdsale core address
        dragoncrowdsalecore = DragonCrowdsaleCore ( dragoncrowdsalecoreaddress );
        price = firstroundprice;
        
        
    }
    
     modifier onlyDragonCrowdsaleCore () {
        if (msg.sender != dragoncrowdsalecoreaddress ) {
            throw;
        }
        _;
    }
    
    
    
    function crowdsale( address tokenholder, uint amount )  onlyDragonCrowdsaleCore returns ( uint , uint ) {
        
        uint award;
        uint donation = 0;
        return ( DragonAward ( amount ) ,donation );
        
    }
    
    
    function precrowdsale( address tokenholder, uint amount )  onlyDragonCrowdsaleCore returns ( uint, uint )  {
        
        uint award;
        uint donation;
        require ( presalePackage( amount ) == true );
        require ( dragoncrowdsalecore.presold() < dragoncrowdsalecore.presoldMax() );
        
        ( award, donation ) = DragonAwardPresale ( amount );
        
        return ( award, donation );
        
    }
    
    
    function presalePackage ( uint amount ) internal returns ( bool )  {
        
        if( amount != .3333333 ether && amount != 3.3333333 ether && amount != 33.3333333 ether  ) return false;
        return true;
   }
    
    
    function DragonAwardPresale ( uint amount ) internal returns ( uint , uint ){
        
        if ( amount ==   .3333333 ether ) return   (   10800000000 ,   800000000 );
        if ( amount ==  3.3333333 ether ) return   (  108800000000 ,  8800000000 );
        if ( amount == 33.3333333 ether ) return   ( 1088800000000 , 88800000000 );
    
    }
    
    
    
    function DragonAward ( uint amount ) internal returns ( uint  ){
        
        uint crowdsaleCounter  = dragoncrowdsalecore.crowdsaleCounter();
          
          
        if ( crowdsaleCounter > 1000000000000000 &&  crowdsaleCounter < 2500000000000000 ) price = secondroundprice;
        if ( crowdsaleCounter >= 2500000000000000 ) price = thirdroundprice;
          
        return ( amount / price );
          
    
    }
    
   
    
    
}
