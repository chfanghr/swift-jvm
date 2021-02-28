//
//  File.swift
//
//
//  Created by 方泓睿 on 2021/2/25.
//

import Foundation
import Utilities

public let pathListSeparator = ":"

public protocol ClasspathEntry: AnyObject, CustomStringConvertible {
    func readClass(name: String) throws -> (Data, ClasspathEntry)
}

internal func createClasspathEntry(with logger: Logger, from path: String) -> ClasspathEntry? {
    if path.contains(pathListSeparator) {
        return CompositeEntry(with: logger, pathList: path)
    }

    if path.hasSuffix("*") {
        return WildcardEntry(with: logger, path: path)
    }

    if path.hasSuffix(".jar") || path.hasSuffix("jar".uppercased()) ||
        path.hasSuffix(".zip") || path.hasSuffix("zip".uppercased())
    {
        return ZipEntry(with: logger, path: path)
    }

    return DirEntry(with: logger, path: path)
}

public class ClasspathEntryBase{
    internal let logger: Logger
    
    public init(with logger: Logger){
        self.logger = logger
    }
}
