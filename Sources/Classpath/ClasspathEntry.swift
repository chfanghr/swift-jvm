//
//  File.swift
//
//
//  Created by 方泓睿 on 2021/2/25.
//

import Foundation

public let pathListSeparator = ":"

public protocol ClasspathEntry: AnyObject, CustomStringConvertible {
    func readClass(name: String) throws -> (Data, ClasspathEntry)
}

internal func createClasspathEntry(from path: String) -> ClasspathEntry? {
    if path.contains(pathListSeparator) {
        return CompositeEntry(pathList: path)
    }

    if path.hasSuffix("*") {
        return WildcardEntry(path: path)
    }

    if path.hasSuffix(".jar") || path.hasSuffix("jar".uppercased()) ||
        path.hasSuffix(".zip") || path.hasSuffix("zip".uppercased())
    {
        return ZipEntry(path: path)
    }

    return DirEntry(path: path)
}
