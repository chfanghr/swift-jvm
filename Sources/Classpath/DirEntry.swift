//
//  File.swift
//
//
//  Created by 方泓睿 on 2021/2/25.
//

import Files
import Foundation

public class DirEntry {
    public let folder: Folder

    public init?(path: String) {
        guard let folder = try? Folder(path: path) else {
            return nil
        }
        self.folder = folder
    }

    internal init?(url: URL) {
        guard let folder = try? Folder(path: url.path) else {
            return nil
        }
        self.folder = folder
    }
}

extension DirEntry: ClasspathEntry {
    public func readClass(name: String) throws -> (Data, ClasspathEntry) {
        let file = try folder.file(named: name)
        let data = try file.read()
        return (data, self)
    }

    public var description: String {
        folder.path
    }
}
