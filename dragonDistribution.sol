pragma solidity ^ 0.4.11;


contract Dragon {
    function transfer( address _to, uint256 _amount )returns(bool ok);
}


contract DragonDistributions {
    

    address public dragon;
    uint256 public clock;
    address public prime;
    address public film;
    
    mapping ( address => uint256 ) public  balanceOf;
    mapping ( address => bool ) public  distributionOne;
    mapping ( address => bool ) public  distributionTwo;
    mapping ( address => bool ) public  distributionThree;
    mapping ( address => bool ) public  advisors;
   
    uint256 public awardAmount       =  45000000000000;
    uint256 public awardAmountPrime  = 100000000000000;
    
    
    
    
    
    function DragonDistributions () {
        
        dragon = ; // Hard code Dragon address
        prime = ; prime Advisor Address
        film = 0xdFCf69C8FeD25F5150Db719BAd4EfAb64F628d31;// filmmaker address
        
        clock = now;
        
        balanceOf[ film ] = awardAmount + 2500000000000; // award amount plus film maker
        balanceOf[ 0x74Fc8fA4F99b6c19C250E4Fc6952051a95F6060D ] = awardAmount;
        balanceOf[ 0xCC3c6A89B5b8a054f21bCEff58B6429447cd8e5E ] = awardAmount;
        
        balanceOf[ prime ] = awardAmountPrime;
        
        advisors [ film ] = true;
        advisors [ 0x74Fc8fA4F99b6c19C250E4Fc6952051a95F6060D ] = true;
        advisors [ 0xCC3c6A89B5b8a054f21bCEff58B6429447cd8e5E ] = true;
        
        
        
        
    }
    
     modifier onlyPrime() {
        if (msg.sender != prime) {
            throw;
        }
        _;
    }

    modifier onlyFilm() {
        if ( msg.sender != film ) {
            throw;
        }
        _;
    }


    function withdrawDragons()
    {
        uint256 total = 0;
        
        require ( advisors[msg.sender] == true );
        
        Dragon drg = Dragon ( dragon );
        
        if ( distributionOne[ msg.sender ] == false ){
            distributionOne[ msg.sender ] = true;
            total += 15000000000000;
            balanceOf[ msg.sender ] -= 15000000000000; 
            
        }
        
        if ( distributionTwo[ msg.sender ] == false && now > clock + 3 minutes ){
            
            
            distributionTwo[ msg.sender ] = true;
            total += 15000000000000;
            balanceOf[ msg.sender ] -= 15000000000000; 
            
        }
        
        if ( distributionThree[ msg.sender ] == false && now > clock + 5 minutes ){
            distributionThree[ msg.sender ] = true;
            total += 15000000000000;
            balanceOf[ msg.sender ] -= 15000000000000; 
            
        }
        
        
        drg.transfer ( msg.sender, total);
        
        
    } 
    
    
    function withdrawDragonsPrime() onlyPrime {
        
         uint _amount = balanceOf[ prime ];
         balanceOf[ prime ] = 0; 
         Dragon drg = Dragon ( dragon );
         drg.transfer ( prime , _amount );
 
    }
    
    function withdrawDragonsFilm() onlyFilm {
        
         uint _amount = balanceOf[ film ];
         balanceOf[ film ] -= 2500000000000; 
         Dragon drg = Dragon ( dragon );
         drg.transfer ( film , _amount );
 
    }
    
}