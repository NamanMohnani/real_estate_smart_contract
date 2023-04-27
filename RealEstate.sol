// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./SafeMath.sol";
// importing local SafeMath library to avoid overflow


contract RealEstate{

    using SafeMath for uint256;

    // blue print of a Property
    struct Property{
        uint256 price;
        address owner;
        bool forSale;
        string name;
        string description;
        string location;
    }

    mapping (uint256 => Property) public properties;
    // to keep track of multiple properties

    uint256[] public property_ids;
    // array to store all the property_id (unit256)

    event PropertySold(uint256 property_id);

    function listPropertyForSale(uint256 _propertyId, uint256 _price, string memory _name, string memory _description, string memory _location) public {

        Property memory new_property = Property({price: _price, owner: msg.sender, forSale: true, name: _name, description: _description, location: _location});
        // assigning properties of new_property as taken from the user

        properties[_propertyId] = new_property; 
        // mapping function

        property_ids.push(_propertyId);
        // pushing this id in uint256 array
    }   

    function buyProperty(uint256 _propertyId) public payable{

        Property storage current_property = properties[_propertyId];
        // Property from array according to it's id (uint256)

        require(current_property.forSale==true, "Property not for sale"); 
        require(current_property.price <= msg.value, "isufficient funds");
        // basic condition to continue buyin properties

        current_property.owner = msg.sender;
        // new owner = sender
        current_property.forSale = false;
        // the property will no longer be for sale

        payable(current_property.owner).transfer(current_property.price);
        // executing transaction

        emit PropertySold(_propertyId);
        // event wil take place
    }




}