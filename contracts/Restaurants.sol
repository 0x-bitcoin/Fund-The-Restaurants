pragma solidity ^0.6.12;

contract Restaurants {
  string public name = "Restaurants";
  uint public restaurantCount = 0;
  mapping(uint => Restaurant) public restaurants;

  struct Restaurant {
    uint restaurantId;
    string name;
    string description;
    string location;
    string imageURL;
    uint donationNeeded;
    address payable owner;
  }

  event RestaurantCreated (
    uint restaurantId,
    string name,
    string description,
    string location,
    string imageURL,
    uint donationNeeded,
    address payable owner
  );

  event DonationForRestaurant (
    uint restaurantId,
    uint amount,
    uint donationNeeded,
    address from,
    address payable owner
  );

  function createRestaurant(string memory _name, string memory _description, string memory _location, string memory _imageURL, uint donationNeeded) public {
    restaurantCount++;

    restaurants[restaurantCount] = Restaurant(restaurantCount, _name, _description, _location, _imageURL, donationNeeded, msg.sender);
    emit RestaurantCreated(restaurantCount, _name, _description, _location, _imageURL, donationNeeded, msg.sender);
  }

  function donateETHToRestaurant(uint _restaurantId) public payable {
    Restaurant memory _restaurant = restaurants[_restaurantId];

    _restaurant.owner.transfer(msg.value);

    _restaurant.donationNeeded -= msg.value;
    restaurants[_restaurantId] = _restaurant;

    emit DonationForRestaurant(_restaurantId, msg.value, _restaurant.donationNeeded, msg.sender, _restaurant.owner);
  }
}