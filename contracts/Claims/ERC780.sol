pragma solidity ^0.5.2;

interface ERC780 {
    event ClaimSet(address indexed issuer, address indexed subject, bytes32 indexed key, bytes32 value);
    event ClaimRemoved(address indexed issuer, address indexed subject, bytes32 indexed key);

    function setClaim(address subject, bytes32 key, bytes32 value) external;
    function setSelfClaim(bytes32 key, bytes32 value) external;
    function getClaim(address issuer, address subject, bytes32 key) external view returns(bytes32);
    function removeClaim(address issuer, address subject, bytes32 key) external;
}
