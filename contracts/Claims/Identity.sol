pragma solidity ^0.5.2;

import "./ERC725.sol";

contract Identity is ERC725 {

    uint256 constant OPERATION_CALL = 0;
    uint256 constant OPERATION_CREATE = 1;
    bytes32 constant KEY_OWNER = 0x0000000000000000000000000000000000000000000000000000000000000000;
    string PUB_KEY;

    mapping(bytes32 => bytes32) public store;


    constructor(address _owner) public {
        store[KEY_OWNER] = toBytes32(_owner);
    }


    modifier onlyOwner() {
        require(toBytes32(msg.sender) == store[KEY_OWNER], "only-owner-allowed");
        _;
    }

    function toAddress(bytes32 a) internal pure returns (address b){
        assembly {
            mstore(0, a)
            b := mload(0)
        }
        return b;
    }

    function toBytes32(address a) internal pure returns (bytes32 b){
        assembly {
            mstore(0, a)
            b := mload(0)
        }
        return b;
    }

    // ----------------
    // Public functions

    function getData(bytes32 _key) external view returns (bytes32 _value) {
        return store[_key];
    }

    function setData(bytes32 _key, bytes32 _value) external onlyOwner {
        store[_key] = _value;
        emit DataChanged(_key, _value);
    }

    function execute(uint256 _operationType, address _to, uint256 _value, bytes calldata _data) external onlyOwner {
        if (_operationType == OPERATION_CALL) {
            executeCall(_to, _value, _data);
        } else if (_operationType == OPERATION_CREATE) {
            address newContract = executeCreate(_data);
            emit ContractCreated(newContract);
        } else {
            // We don't want to spend users gas if parametar is wrong
            revert();
        }
    }

    // copied from GnosisSafe
    // https://github.com/gnosis/safe-contracts/blob/v0.0.2-alpha/contracts/base/Executor.sol
    function executeCall(address to, uint256 value, bytes memory data)
    internal
    returns (bool success)
    {
        uint dataLength = data.length;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            let x := mload(0x40)    // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
            let d := add(data, 32)  // First 32 bytes are the padded length of data, so exclude that
            success := call(
            sub(gas, 34710),      // 34710 is the value that solidity is currently emitting
            // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
            // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
            to,
            value,
            d,
            dataLength,           // Size of the input (in bytes) - this is what fixes the padding problem
            x,
            0                     // Output is ignored, therefore the output size is zero
            )
            switch success
            case 0 { revert(x, dataLength) }
            case 1 { return(x, dataLength) }
        }
    }

    // copied from GnosisSafe
    // https://github.com/gnosis/safe-contracts/blob/v0.0.2-alpha/contracts/base/Executor.sol
    function executeCreate(bytes memory data)
    internal
    returns (address newContract)
    {
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            newContract := create(0, add(data, 0x20), mload(data))
        }
    }
}