// SPDX-License-Identifier: MIT
pragma solidity 0.8;

/*
https://www.trade.gov/know-your-incoterms
The seven Incoterms® 2020 rules for any mode(s) of transport are: 
    EXW - Ex Works (insert place of delivery)
    FCA  - Free Carrier (Insert named place of delivery) 
    CPT  - Carriage Paid to (insert place of destination) 
    CIP -  Carriage and Insurance Paid To (insert place of destination)  
    DAP - Delivered at Place (insert named place of destination)  
    DPU - Delivered at Place Unloaded (insert of place of destination)  
    DDP - Delivered Duty Paid (Insert place of destination).  
    Note: the DPU Incoterms replaces the old DAT, with additional requirements for the seller to unload the goods from the arriving means of transport. 
The four Incoterms® 2020 rules for Sea and Inland Waterway Transport are: 
     FAS - Free Alongside Ship (insert name of port of loading) 
     FOB - Free on Board (insert named port of loading) 
     CFR - Cost and Freight (insert named port of destination) 
     CIF -  Cost Insurance and Freight (insert named port of destination) 
*/
import "hardhat/console.sol";
// console.log("Owner contract deployed by:", msg.sender);

contract SupplyChain {

    mapping(uint => mapping(address => bytes4)) buyer; // counter -> who -> insurance id
    mapping(uint => mapping(address => bytes4)) seller; // counter -> who -> insurance id
    mapping(uint => mapping(address => bytes4)) agent; // counter -> who -> insurance id
    mapping(uint => mapping(bytes16 => bool)) insure; // counter -> insurance papper id -> receive?
    uint private _counter;

    function exwTerm(address _buyer, address _seller, string memory _point) public returns (bool, bytes16 mo) {
        (uint id, bytes4 data) = exw(_buyer, _seller, _point);
        if(id > 0 && data != 0x00000000){
            insure[id][_insurNum(id,data)] = true;
            mo = _insurNum(id,data);
            return (true,mo);
        }
        return (false,0x0);
    }


    // --- logics --- \\

    // EXW - Ex Works (insert place of delivery)
    function exw(address _buyer, address _seller, string memory _point) private returns (uint, bytes4) {
        _counter += 1;
        agent[_counter][msg.sender] = _data(msg.sender, _counter);
        buyer[_counter][_buyer] = _data(_buyer, _counter);
        seller[_counter][_seller] = _data(_seller, _counter);
        return (_counter, _place(_point));
    }

    // FCA  - Free Carrier (Insert named place of delivery) 
    function fca(address _buyer, address _seller, string memory _point) private returns (uint, bytes4) {
        _counter += 1;
        agent[_counter][msg.sender] = _data(msg.sender, _counter);
        buyer[_counter][_buyer] = _data(_buyer, _counter);
        seller[_counter][_seller] = _data(_seller, _counter);
        return (_counter, _place(_point));
    }

    // CPT  - Carriage Paid to (insert place of destination) 
    function cpt(address _buyer, address _seller, string memory _point) private returns (uint, bytes4) {
        _counter += 1;
        agent[_counter][msg.sender] = _data(msg.sender, _counter);
        buyer[_counter][_buyer] = _data(_buyer, _counter);
        seller[_counter][_seller] = _data(_seller, _counter);
        return (_counter, _place(_point));
    }

    // CIP -  Carriage and Insurance Paid To (insert place of destination)  
    function cip(address _buyer, address _seller, string memory _point) private returns (uint, bytes4) {
        _counter += 1;
        agent[_counter][msg.sender] = _data(msg.sender, _counter);
        buyer[_counter][_buyer] = _data(_buyer, _counter);
        seller[_counter][_seller] = _data(_seller, _counter);
        return (_counter, _place(_point));
    }

    // DAP - Delivered at Place (insert named place of destination)  
    function dap(address _buyer, address _seller, string memory _point) private returns (uint, bytes4) {
        _counter += 1;
        agent[_counter][msg.sender] = _data(msg.sender, _counter);
        buyer[_counter][_buyer] = _data(_buyer, _counter);
        seller[_counter][_seller] = _data(_seller, _counter);
        return (_counter, _place(_point));
    }

    // DPU - Delivered at Place Unloaded (insert of place of destination)  
    function dpu(address _buyer, address _seller, string memory _point) private returns (uint, bytes4) {
        _counter += 1;
        agent[_counter][msg.sender] = _data(msg.sender, _counter);
        buyer[_counter][_buyer] = _data(_buyer, _counter);
        seller[_counter][_seller] = _data(_seller, _counter);
        return (_counter, _place(_point));
    }

    // DDP - Delivered Duty Paid (Insert place of destination) 
    function ddp(address _buyer, address _seller, string memory _point) private returns (uint, bytes4) {
        _counter += 1;
        agent[_counter][msg.sender] = _data(msg.sender, _counter);
        buyer[_counter][_buyer] = _data(_buyer, _counter);
        seller[_counter][_seller] = _data(_seller, _counter);
        return (_counter, _place(_point));
    }

    //  FAS - Free Alongside Ship (insert name of port of loading) 
    function fas(address _buyer, address _seller, string memory _point) private returns (uint, bytes4) {
        _counter += 1;
        agent[_counter][msg.sender] = _data(msg.sender, _counter);
        buyer[_counter][_buyer] = _data(_buyer, _counter);
        seller[_counter][_seller] = _data(_seller, _counter);
        return (_counter, _place(_point));
    }

    //  FOB - Free on Board (insert named port of loading) 
    function fob(address _buyer, address _seller, string memory _point) private returns (uint, bytes4) {
        _counter += 1;
        agent[_counter][msg.sender] = _data(msg.sender, _counter);
        buyer[_counter][_buyer] = _data(_buyer, _counter);
        seller[_counter][_seller] = _data(_seller, _counter);
        return (_counter, _place(_point));
    }

    //  CFR - Cost and Freight (insert named port of destination) 
    function cfr(address _buyer, address _seller, string memory _point) private returns (uint, bytes4) {
        _counter += 1;
        agent[_counter][msg.sender] = _data(msg.sender, _counter);
        buyer[_counter][_buyer] = _data(_buyer, _counter);
        seller[_counter][_seller] = _data(_seller, _counter);
        return (_counter, _place(_point));
    }

    //  CIF -  Cost Insurance and Freight (insert named port of destination) 
    function cif(address _buyer, address _seller, string memory _point) private returns (uint, bytes4) {
        _counter += 1;
        agent[_counter][msg.sender] = _data(msg.sender, _counter);
        buyer[_counter][_buyer] = _data(_buyer, _counter);
        seller[_counter][_seller] = _data(_seller, _counter);
        return (_counter, _place(_point));
    }


    // --- helpers --- \\
    function _data(address who, uint id) private pure returns (bytes4 data) {
        data = bytes4(keccak256(abi.encode(who, id)));
    }

    function _place(string memory _where) private pure returns (bytes4 data) {
        data = bytes4(keccak256(abi.encode(_where)));
    }

    function _insurNum(uint _id, bytes4 _target) private pure returns (bytes16 data) {
        data = bytes16(keccak256(abi.encode(_id, _target)));
    }

}
