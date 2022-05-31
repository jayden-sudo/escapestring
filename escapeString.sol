// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title EscapeString
 * @notice Escape a string
 * https://github.com/zhangshengjie/escapestring
 */
library EscapeString {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev encode a string to a json value string
     * @param input the string to encode
     * @return the encoded string
     */
    function toJsonValue(string memory input)
        internal
        pure
        returns (string memory)
    {
        string memory result = "";
        bytes memory bs = bytes(input);
        bytes memory bs_out = new bytes(bs.length * 6);
        uint256 bs_out_i = 0;
        uint8 code;
        bytes1 code_bytes1;
        for (uint256 i = 0; i < bs.length; i++) {
            code_bytes1 = bs[i];
            code = uint8(code_bytes1);
            if (code == 0) {
                break;
            }
            if (code <= 0x7 || code == 0xb || (code >= 0xe && code <= 0x1f)) {
                bs_out[bs_out_i] = 0x5c; //  '\'
                bs_out[bs_out_i + 1] = 0x75; // 'u'
                bs_out[bs_out_i + 2] = 0x30; // '0'
                bs_out[bs_out_i + 3] = 0x30; // '0'
                bs_out[bs_out_i + 4] = _HEX_SYMBOLS[code >> 4]; // hex digit
                bs_out[bs_out_i + 5] = _HEX_SYMBOLS[code & 0xf]; // hex digit
                bs_out_i += 6;
            } else if (code == 0x8) {
                bs_out[bs_out_i] = 0x5c; //  '\'
                bs_out[bs_out_i + 1] = 0x62; // 'b'
                bs_out_i += 2;
            } else if (code == 0x9) {
                bs_out[bs_out_i] = 0x5c; //  '\'
                bs_out[bs_out_i + 1] = 0x74; // 't'
                bs_out_i += 2;
            } else if (code == 0xa) {
                bs_out[bs_out_i] = 0x5c; //  '\'
                bs_out[bs_out_i + 1] = 0x6e; // 'n'
                bs_out_i += 2;
            } else if (code == 0xc) {
                bs_out[bs_out_i] = 0x5c; //  '\'
                bs_out[bs_out_i + 1] = 0x66; // 'f'
                bs_out_i += 2;
            } else if (code == 0xd) {
                bs_out[bs_out_i] = 0x5c; //  '\'
                bs_out[bs_out_i + 1] = 0x72; // 'r'
                bs_out_i += 2;
            } else if (code == 0x22) {
                bs_out[bs_out_i] = 0x5c; //  '\'
                bs_out[bs_out_i + 1] = 0x22; // '"'
                bs_out_i += 2;
            } else if (code == 0x5c) {
                bs_out[bs_out_i] = 0x5c; //  '\'
                bs_out[bs_out_i + 1] = 0x5c; // '\'
                bs_out_i += 2;
            } else {
                bs_out[bs_out_i] = code_bytes1;
                bs_out_i += 1;
            }
        }
        bytes memory bs_out_new = new bytes(bs_out_i);
        for (uint256 i = 0; i < bs_out_i; i++) {
            bs_out_new[i] = bs_out[i];
        }
        result = string(bs_out_new);
        return result;
    }
}
