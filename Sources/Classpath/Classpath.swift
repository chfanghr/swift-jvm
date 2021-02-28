//
//  File.swift
//
//
//  Created by 方泓睿 on 2021/2/25.
//

import Files
import Foundation
import Utilities

public struct Classpath {
    public let bootClasspath: ClasspathEntry?
    public let extClasspath: ClasspathEntry?
    public let userClasspath: ClasspathEntry?

    public init(with logger: Logger, jreOption: String = "", cpOption: String = "") throws {
        let jreDir = Self.getJreDir(jreOption: jreOption)

        let jreLibPath = URL(fileURLWithPath: jreDir)
            .appendingPathComponent("lib")
            .appendingPathComponent("*")
            .path
        bootClasspath = WildcardEntry(path: jreLibPath)
        guard let _ = bootClasspath else {
            preconditionFailure("failed to unpack boot libs")
        }

        let jreExtPath = URL(fileURLWithPath: jreDir)
            .appendingPathComponent("lib")
            .appendingPathComponent("ext")
            .appendingPathComponent("*")
            .path
        extClasspath = WildcardEntry(path: jreExtPath)

        let userLibPath = cpOption.isEmpty ? "." : cpOption
        userClasspath = createClasspathEntry(from: userLibPath)
    }

    private static func getJreDir(jreOption: String) -> String {
        if !jreOption.isEmpty, exists(path: jreOption) {
            return jreOption
        }

        if exists(path: "./jre") {
            debugPrint("using local jre ./jre")
            return "./jre"
        }

        if let jh = ProcessInfo.processInfo.environment["JAVA_HOME"] {
            let jreDir = URL(fileURLWithPath: jh).appendingPathComponent("jre").path
            if let _ = try? Folder(path: jreDir) {
                return jreDir
            }
        }

        preconditionFailure("cannot find jre folder")
    }

    private static func exists(path: String) -> Bool {
        FileManager.default.fileExists(atPath: path)
    }

    public func readClass(name: String) throws -> (Data, ClasspathEntry) {
        let className = name + ".class"
        if let res = try? bootClasspath?.readClass(name: className) {
            return res
        }
        if let res = try? extClasspath?.readClass(name: className) {
            return res
        }
        if let res = try? userClasspath?.readClass(name: className) {
            return res
        }
        throw ClassNotFoundError()
    }

    public subscript(_ name: String) -> Data? {
        guard let (data, _) = try? readClass(name: name) else {
            return nil
        }
        return data
    }
}

extension Classpath: CustomStringConvertible {
    public var description: String {
        userClasspath?.description ?? ""
    }
}
