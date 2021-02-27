//
//  File.swift
//
//
//  Created by 方泓睿 on 2021/2/24.
//

import Foundation

public class JVM {
    let verboseMode: Bool

    public init(jreOption: String, cpOption: String, verboseMode: Bool = false) {
        self.verboseMode = verboseMode
    }

    public func start(mainClass: String, args: [String]) throws {
        print("main class: \(mainClass) args: \(args)")
    }
}

internal func measure<T>(_ job: @autoclosure () throws -> T, name: String = "") rethrows -> T {
    let begin = DispatchTime.now()
    let res = try job()
    let end = DispatchTime.now()
    let nanoInterval = end.uptimeNanoseconds - begin.uptimeNanoseconds
    let interval = Double(nanoInterval) / 1_000_000_000
    print("\(name): \(interval)s")
    return res
}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}
