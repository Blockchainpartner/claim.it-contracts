pragma solidity ^0.5.4; 
interface ERC735 {
    event ClaimApprovalToggled(bytes32 indexed claimId, bytes32 indexed topic, uint256 scheme, address indexed issuer, bytes32 signature, bytes32 data, string uri);
    event ClaimAdded(bytes32 indexed claimId, bytes32 indexed topic, uint256 scheme, address indexed issuer, bytes32 signature, bytes32 data, string uri);
    event ClaimRemoved(bytes32 indexed claimId, bytes32 indexed topic, uint256 scheme, address indexed issuer, bytes32 signature, bytes32 data, string uri);
    event ClaimChanged(bytes32 indexed claimId, bytes32 indexed topic, uint256 scheme, address indexed issuer, bytes32 signature, bytes32 data, string uri);
    struct Claim {
        bytes32 topic;
        uint256 scheme;
        address issuer; // msg.sender
        bytes32 signature; // this.address + topic + data
        bytes32 data;
        string uri;
        bool recipientApproval;
        
        // Test it out for parent-child claim relationship
        bytes32 parentClaimId;
        bool isValid;
    }
    function getClaim(bytes32 _claimId) external view returns(bytes32 topic, uint256 scheme, address issuer, bytes32 signature, bytes32 data, string memory uri);
    function getClaimIdsByTopic(bytes32 _topic) external view returns(bytes32[] memory claimIds);
    function addClaim(bytes32 _topic, uint256 _scheme, bytes32 _signature, bytes32 _data, string calldata _uri) external returns (bytes32 claimRequestId);
    function changeClaim(bytes32 _claimId, bytes32 _topic, uint256 _scheme, address _issuer, bytes32 _signature, bytes32 _data, string calldata _uri) external returns (bool success);
    function removeClaim(bytes32 _claimId) external returns (bool success);
    function toggleApprovaleClaim(bytes32 _claimId) external returns (bool success);
}
