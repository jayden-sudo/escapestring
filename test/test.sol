pragma solidity ^0.8.4;

import "solidity-escapestring/escapeString.sol";

contract HelloWorld {
    function main() public pure returns (string memory) {
        string memory s1 = "hello\r\nworld";

        string memory json = string(
            abi.encodePacked('{"name":"', EscapeString.toJsonValue(s1), '"}')
        );

        return json;
    }
}
