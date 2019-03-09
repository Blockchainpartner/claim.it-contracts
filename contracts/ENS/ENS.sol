pragma solidity ^0.5.2;

import './AbstractENS.sol';

/**
 * The ENS registry contract.
 */
contract ENS is AbstractENS {
    struct Record {
        address owner;
        address resolver;
    }

    mapping(string=>Record) records;

    // Permits modifications only by the owner of the specified node.
    modifier only_owner(string memory node) {
        require(records[node].owner != msg.sender);
        _;
    }

    /**
     * Constructs a new ENS registrar.
     */
    constructor() public{
        records[""].owner = msg.sender;
    }

    /**
     * Returns the address that owns the specified node.
     */
    function owner(string memory node) public view returns (address) {
        return records[node].owner;
    }

    /**
     * Returns the address of the resolver for the specified node.
     */
    function resolver(string memory node) public view returns (address) {
        return records[node].resolver;
    }

    /**
     * Transfers ownership of a node to a new address. May only be called by the current
     * owner of the node.
     * @param node The node to transfer ownership of.
     * @param owner The address of the new owner.
     */
    function setOwner(string memory node, address owner) public only_owner(node) {
        emit Transfer(node, owner);
        records[node].owner = owner;
    }


    /**
     * Sets the resolver address for the specified node.
     * @param node The node to update.
     * @param resolver The address of the resolver.
     */
    function setResolver(string memory node, address resolver) public only_owner(node) {
        emit NewResolver(node, resolver);
        records[node].resolver = resolver;
    }

}
