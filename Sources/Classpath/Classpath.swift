//
//  File.swift
//
//
//  Created by 方泓睿 on 2021/2/25.
//

import Files
import Foundation
import JVMError
import Utilities

public struct Classpath {
    public let bootClasspath: ClasspathEntry?
    public let extClasspath: ClasspathEntry?
    public let userClasspath: ClasspathEntry?

    public init(with logger: Logger, jreOption: String = "", cpOption: String = "") throws {
        let jrePath = try Self.detectJREpath(with: logger, jreOption: jreOption)
        logger.info("jre path detection succeeded", metadata: [
            "jrePath": .string(jrePath),
        ])

        let jreLibPath = URL(fileURLWithPath: jrePath)
            .appendingPathComponent("lib")
            .appendingPathComponent("*")
            .path
        logger.info("find all basic classes in jre", metadata: [
            "jreLibPath": .string(jreLibPath),
        ])
        bootClasspath = WildcardEntry(with: logger, path: jreLibPath)
        guard let _ = bootClasspath else {
            logger.critical("cannot find basic classes from boot classpath")
            throw JVMError.VirtualMachineError.UnknownError.JREBootClasspathClassesNotFoundError()
        }

        let jreExtPath = URL(fileURLWithPath: jrePath)
            .appendingPathComponent("lib")
            .appendingPathComponent("ext")
            .appendingPathComponent("*")
            .path
        logger.info("find all external classes in jre", metadata: [
            "jreExtPath": .string(jreExtPath),
        ])
        extClasspath = WildcardEntry(with: logger, path: jreExtPath)

        let userLibPath = cpOption.isEmpty ? "." : cpOption
        userClasspath = createClasspathEntry(with: logger, from: userLibPath)
    }

    private static func detectJREpath(with logger: Logger, jreOption: String) throws -> String {
        logger.info("getting jre path", metadata: [
            "jreOption": .string(jreOption),
        ])
        if !jreOption.isEmpty {
            logger.info("checking user provided jre path")
            if exists(path: jreOption) {
                return jreOption
            }
            logger.warning("user provided jre path does not exist or cannot access")
        }

        if exists(path: "./jre") {
            logger.info("using jre in working directory")
            return "./jre"
        }

        if let jh = ProcessInfo.processInfo.environment["JAVA_HOME"] {
            let jreDir = URL(fileURLWithPath: jh).appendingPathComponent("jre").path
            if let _ = try? Folder(path: jreDir) {
                logger.info("using jre path defined by $JAVA_HOME")
                return jreDir
            }
        }

        throw JVMError.VirtualMachineError.UnknownError.JRENotFoundError()
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
        throw JVMError.ReflectiveOperationError.ClassNotFoundError(desiredClass: name)
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
