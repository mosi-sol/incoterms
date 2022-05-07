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
    mapping(uint => mapping(bytes16 => Types)) insureType; // counter -> insurance papper id -> term type?

    enum Types{
        EXW, FCA, CPT, CIP, DAP, DPU, DDP, FAS, FOB, CFR, CIF, NUN
    }
    Types rule;

    uint private _counter;

    function registerNewInsure(Types _type, address _buyer, address _seller, string memory _point) public virtual returns (bool, bytes16 mo, Types) {
        (uint id, bytes4 data) = terms(_buyer, _seller, _point);
        if(id > 0 && data != 0x00000000){
            mo = _insurNum(id,data);
            rule = _type;
            insure[id][mo] = true;
            insureType[id][mo] = rule;
            return (true,mo,rule);
        }
        return (false,0x0,Types.NUN);
    }


    // --- logics --- \\

    function terms(address _buyer, address _seller, string memory _point) private returns (uint, bytes4) {
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
