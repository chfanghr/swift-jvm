//
//  File.swift
//
//
//  Created by 方泓睿 on 2021/2/25.
//

import Files
import Foundation
import Utilities
import JVMError

public class DirEntry: ClasspathEntryBase{
    public let folder: Folder

    public init?(with logger: Logger, path: String) {
        guard let folder = try? Folder(path: path) else {
            logger.warning("cannot create directory entry", metadata: [
                "path": .stringConvertible(path)
            ])
            return nil
        }
        self.folder = folder
        super.init(with: logger)
    }

    internal init?(with logger: Logger, url: URL) {
        guard let folder = try? Folder(path: url.path) else {
            logger.warning("cannot create directory entry", metadata: [
                "url": .stringConvertible(url)
            ])
            return nil
        }
        self.folder = folder
        super.init(with: logger)
    }
}

extension DirEntry: ClasspathEntry {
    public func readClass(name: String) throws -> (Data, ClasspathEntry) {
        guard let file = try? folder.file(named: name),
              let data = try? file.read() else{
            logger.warning("cannot read class from directory entry", metadata: [
                "folder": .stringConvertible(folder),
                "name": .string(name)
            ])
            throw JVMError.ReflectiveOperationError.ClassNotFoundError(desiredClass: name)
        }
        return (data, self)
    }

    public var description: String {
        folder.path
    }
}
