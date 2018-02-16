//
//  EIP55.swift
//  EthereumKit
//
//  Created by yuzushioh on 2018/02/11.
//  Copyright © 2018 yuzushioh.
//

import Foundation
import CryptoSwift

// NOTE: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md

struct EIP55 {
    static func encode(_ data: Data) -> String {
        let address = data.hex
        let hash = address.data(using: .ascii)!.sha3(.keccak256).hex
        
        return zip(address, hash)
            .map { a, h -> String in
                switch (a, h) {
                case ("0", _), ("1", _), ("2", _), ("3", _), ("4", _), ("5", _), ("6", _), ("7", _), ("8", _), ("9", _):
                    return String(a)
                case (_, "8"), (_, "9"), (_, "a"), (_, "b"), (_, "c"), (_, "d"), (_, "e"), (_, "f"):
                    return String(a).uppercased()
                default:
                    return String(a).lowercased()
                }
            }
            .joined()
    }
}
