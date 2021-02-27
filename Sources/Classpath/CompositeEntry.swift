//
//  File.swift
//
//
//  Created by 方泓睿 on 2021/2/25.
//

import Foundation

public struct ClassNotFoundError: Error {}

public class CompositeEntry {
    public var entries: [ClasspathEntry] = []

    public init() {}

    public init?(pathList: String) {
        for path in pathList.split(separator: Character(pathListSeparator)) {
            guard let entry = createClasspathEntry(from: String(path)) else {
                return nil
            }
            entries.append(entry)
        }
    }
}

extension CompositeEntry: ClasspathEntry {
    public func readClass(name: String) throws -> (Data, ClasspathEntry) {
        for entry in entries {
            if let res = try? entry.readClass(name: name) {
                let (data, _) = res
                return (data, self)
            }
        }
        throw ClassNotFoundError()
    }

    public var description: String {
        entries
            .map { $0.description }
            .joined(separator: pathListSeparator)
    }
}
