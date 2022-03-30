// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract BoyJoyOpen {  // dont ask me why this name
    
    struct Account {
        string nickName;
        address owner;
        uint8 level;
        uint8 microLevel;   //NEED to calculate <256!!
        address[10] listOut;  // i give a hand to sombody
        address[10] listIn;   // i am given a hand from sombody
        Account[] listOut_X;  // ?
        Account[] listIn_X;   // ?
        bool flagCheckLevel; // if  TRUE need to check own level
    }


    constructor() {
        owner = msg.sender;

    }

    modifier onlyOwner() {
        require(msg.sender == owner, "your are not owner")
        _; 
    }

    uint maxlenthIn = 10;  // why  10? NEED to  restrict to 2 , but at app you can add 10  
    uint maxlenthOut = 10;  // why  10?
    //uint counterOfAccounts = 0; //count how many aacounts created

    Account[] AccountList;
    //mapping (address => uint) ownerToAccaunt;
    //mapping (uint => address) accountToOwner; // may be delete this for short storage?
    mapping (string => address) NickToOwner;
    mapping (address => Account) addressToAccount; //NEED to change address to hash for cut storage size
    
    // we can storage here only hash from map, but map will be live on fronand app

    function createAccount (string memory _nickName) public {
        require(addressToAccount[msg.sender] == 0, "error createAccount"); // if your account dont exist
        address[] memory emptyList; //NEED to be recode?
        addressToAccount[msg.sender] = Account(_nickName, msg.sender, 0 , emptyList, emptyList, true);
                     
    }


    function addHand (address _hand) external { // NEED to cut call to addressToAccount or compiler will do it?
        require(addressToAccount[msg.sender] > 0, "error addHand"); // if your account  exist
        require(addressToAccount[_hand] > 0, "error addHand"); // if  account your hand exist
        require(addressToAccount[msg.sender].listOut.lenth < maxlenthOut, "error addHand");
        require(addressToAccount[_hand].listIn.lenth < maxlenthIn, "error addHand");
        
        addressToAccount[msg.sender].listOut.push(_hand);
        addressToAccount[_hand].listIn.push(msg.sender);

        //or this: ??
        addressToAccount[msg.sender].listOut_X.push(addressToAccount[_hand]);
        addressToAccount[_hand].listIn_X.push(addressToAccount[msg.sender]);

        
    }

    // function delHand {}
    // function addHandList {}
    
    // protect from buying trust
    function checklevel (address _owner, address _hand) external view returns (bool) {
        uint levelOfOwner = addressToAccount[_owner].level;
        uint levelOfHand = addressToAccount[_hand].level;
        return ((levelOfOwner-levelOfHand) == 1 || (levelOfOwner-levelOfHand) == 0 || (levelOfHand - levelOfOwner) == 1);

    }

    
    function calculateLevel (address _address) external view returns (uint8) {
        require(addressToAccount[_address] > 0, "error calculateLevel"); // if your account  exist
        uint8 myLevel = addressToAccount[_address].level;
        address[] myListIn = addressToAccount[_address].listIn;
        uint8 lenthListIn = myListIn.lenth;
        
        //or this??
        //Account[] myListIn_X = addressToAccount[_address].listIn;
       // uint8 lenthListIn_X = myListIn_X.lenth;

        
        uint8 i=0;
        uint8 maxLevel;
        while (i<lenthListIn){
            Account accIn = addressToAccount[myListIn[i]];
            // or this?
            //Account accIn_X = myListIn_X[i]
            
            if (checklevel(_address, addressIn)) {
               maxLevel = maxfunc(maxLevel, accIn.level); 
               // NEED to add second boll!!
               
            }
            i++;
        } 
         
        return maxLevel;
    }

    function updateLevel (address _address, uint8 _maxLevel) external {
        addressToAccount[_address].level = _maxLevel;
        addressToAccount[_address].flagCheckLevel = false;
        
    }

    function riseFlag(address _address) internal {
        address[] listOutOwner = addressToAccount[_address].listOut;
        uint8 lenthListOut = listOutOwner.lenth;
        uint8 j=0;
        while (j<lenthListOut) {
            addressToAccount[listOutOwner[j]].flagCheckLevel = true;
            j++;
        }
    }
    //NEED to change all contract to heap?
    

    /*
    function updateAcc(uint _flag, Acccount storage _acc, address _owner, uint _level, address[] memory _listOfHands) internal {
                
        if (_flag==1) {             // in case of creating new acc
            _acc.owner = _owner;
        }
        if (_flag==2) {             // in case of relevel
            _acc.level = uint8(_level);
        }
        if (_flag==3) {             // update hands
            _acc.listOfHands = _listOfHands;
        }
        
    } 
    */

}
