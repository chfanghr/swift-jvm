//
//  File.swift
//
//
//  Created by 方泓睿 on 2021/2/25.
//

import Foundation
import Utilities
import JVMError

public class CompositeEntry: ClasspathEntryBase {
    public var entries: [ClasspathEntry] = []

    public override init(with logger: Logger){
        super.init(with: logger)
    }
    
    public init?(with logger: Logger, pathList: String) {
        super.init(with: logger)
        
        for path in pathList.split(separator: Character(pathListSeparator)) {
            if let entry = createClasspathEntry(with: logger, from: String(path)) {
                logger.info("adding entry", metadata: [
                    "entry": .stringConvertible(entry)
                ])
                entries.append(entry)
                continue
            }
            logger.warning("failed to create entry", metadata: [
                "path": .stringConvertible(path)
            ])
        }
    }
}

extension CompositeEntry: ClasspathEntry {
    public func readClass(name: String) throws -> (Data, ClasspathEntry) {
        logger.info("looking for class", metadata: [
            "name": .string(name)
        ])
        for entry in entries {
            if let res = try? entry.readClass(name: name) {
                let (data, _) = res
                return (data, self)
            }
            logger.info("class not found", metadata: [
                "entry": .stringConvertible(entry)
            ])
        }
        throw JVMError.ReflectiveOperationError.ClassNotFoundError(desiredClass: name)
    }

    public var description: String {
        entries
            .map { $0.description }
            .joined(separator: pathListSeparator)
    }
}
