//
//  File.swift
//  
//
//  Created by 方泓睿 on 2021/2/28.
//

import Foundation

extension Data {
    public struct HexEncodingOptions: OptionSet {
        public let rawValue: Int
        public static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
        public init(rawValue: Int){
            self.rawValue = rawValue
        }
    }

    public func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: "\(format) ", $0) }.joined()
    }
}

