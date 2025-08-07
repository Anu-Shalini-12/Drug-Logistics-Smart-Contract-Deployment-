// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DrugLogistics {

    enum Role { None, Manufacturer, Supplier, Distributor, Pharmacy, Consumer }
    enum DrugStatus { Manufactured, InTransit, DeliveredToPharmacy, Sold }

    struct Drug {
        uint id;
        string name;
        address manufacturer;
        address currentOwner;
        DrugStatus status;
        string location;
        uint timestamp;
        address[] history;
    }

    mapping(address => Role) public roles;
    mapping(uint => Drug) public drugs;
    mapping(uint => bool) public drugExists;

    address public admin;

    event DrugRegistered(uint indexed id, string name, address manufacturer);
    event StatusUpdated(uint indexed id, DrugStatus status, string location, address updatedBy);
    event OwnershipTransferred(uint indexed id, address from, address to);
    event DrugVerified(uint indexed id, string name, DrugStatus status, string location, address currentOwner);
    event RoleAssigned(address user, Role role);

    modifier onlyRole(Role _role) {
        require(roles[msg.sender] == _role, "Unauthorized: Invalid Role");
        _;
    }

    modifier onlyInvolved(uint _id) {
        require(drugExists[_id], "Drug does not exist");
        require(
            msg.sender == drugs[_id].currentOwner,
            "Unauthorized: Not current owner"
        );
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this");
        _;
    }

    constructor() {
        admin = msg.sender;
        roles[msg.sender] = Role.Manufacturer;
    }

    // Admin assigns roles to users
    function assignRole(address _user, Role _role) public onlyAdmin {
        roles[_user] = _role;
        emit RoleAssigned(_user, _role);
    }

    // Manufacturer registers a new drug
    function registerDrug(uint _id, string memory _name, string memory _location) public onlyRole(Role.Manufacturer) {
        require(!drugExists[_id], "Drug ID already exists");

        address[] memory history;
        drugs[_id] = Drug({
            id: _id,
            name: _name,
            manufacturer: msg.sender,
            currentOwner: msg.sender,
            status: DrugStatus.Manufactured,
            location: _location,
            timestamp: block.timestamp,
            history: history
        });

        drugs[_id].history.push(msg.sender);
        drugExists[_id] = true;

        emit DrugRegistered(_id, _name, msg.sender);
    }

    // Allowed transfer paths
    function isValidNextRole(Role current, Role next) internal pure returns (bool) {
        if (current == Role.Manufacturer && next == Role.Supplier) return true;
        if (current == Role.Supplier && next == Role.Distributor) return true;
        if (current == Role.Distributor && next == Role.Pharmacy) return true;
        return false;
    }

    // Transfer ownership to next valid role
    function transferDrug(uint _id, address _to) public onlyInvolved(_id) {
        Role senderRole = roles[msg.sender];
        Role receiverRole = roles[_to];

        require(receiverRole != Role.None, "Recipient must have a valid role");
        require(isValidNextRole(senderRole, receiverRole), "Invalid transfer order");

        drugs[_id].currentOwner = _to;
        drugs[_id].history.push(_to);

        emit OwnershipTransferred(_id, msg.sender, _to);
    }

    // Update drug status and location
    function updateStatus(uint _id, DrugStatus _status, string memory _location)
        public
        onlyInvolved(_id)
    {
        drugs[_id].status = _status;
        drugs[_id].location = _location;
        drugs[_id].timestamp = block.timestamp;

        emit StatusUpdated(_id, _status, _location, msg.sender);
    }

    // For consumers or any public verification
    function verifyDrug(uint _id)
        public
        view
        returns (
            string memory name,
            DrugStatus status,
            string memory location,
            address currentOwner
        )
    {
        require(drugExists[_id], "Invalid Drug ID");

        Drug memory drug = drugs[_id];
        return (drug.name, drug.status, drug.location, drug.currentOwner);
    }

    // Full details including movement history
    function getDrugDetails(uint _id)
        public
        view
        returns (
            string memory name,
            address manufacturer,
            address currentOwner,
            DrugStatus status,
            string memory location,
            uint timestamp,
            address[] memory history
        )
    {
        require(drugExists[_id], "Drug not found");

        Drug memory drug = drugs[_id];
        return (
            drug.name,
            drug.manufacturer,
            drug.currentOwner,
            drug.status,
            drug.location,
            drug.timestamp,
            drug.history
        );
    }

    // View user's role
    function getRole(address _user) public view returns (Role) {
        return roles[_user];
    }

    // Get numeric status value
    function getDrugStatus(uint _id) public view returns (uint) {
        require(drugExists[_id], "Invalid Drug ID");
        return uint(drugs[_id].status);
    }
}
