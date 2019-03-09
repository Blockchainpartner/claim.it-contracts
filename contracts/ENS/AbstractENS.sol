pragma solidity ^0.5.2;

interface AbstractENS {
    function owner(string calldata node) external view returns(address);
    function resolver(string calldata node) external view returns(address);
    function setOwner(string calldata node, address owner) external;
    function setResolver(string calldata node, address resolver) external;

    // Logged when the owner of a node assigns a new owner to a subnode.
    event NewOwner(string indexed node, string indexed label, address owner);

    // Logged when the owner of a node transfers ownership to a new account.
    event Transfer(string indexed node, address owner);

    // Logged when the resolver for a node changes.
    event NewResolver(string indexed  node, address resolver);
}
