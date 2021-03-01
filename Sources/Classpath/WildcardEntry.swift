//
//  File.swift
//
//
//  Created by 方泓睿 on 2021/2/25.
//

import Files
import Foundation
import Utilities

public class WildcardEntry: CompositeEntry {
    init?(with logger: Logger, path: String) {
        super.init(with: logger)

        let baseDirPath = String(path.dropLast())
        logger.info("detecting jar files in base path", metadata: [
            "baseDirPath": .string(baseDirPath),
        ])
        guard let baseDir = try? Folder(path: baseDirPath) else {
            logger.warning("base path does not exist or cannot access", metadata: [
                "baseDirPath": .string(baseDirPath),
            ])
            return nil
        }
        for file in baseDir.files {
            let path = file.path
            if path.hasSuffix(".jar") || path.hasSuffix("jar".uppercased()) {
                logger.info("decompressing jar file", metadata: [
                    "filePath": .string(path),
                ])
                if let zipEntry = ZipEntry(with: logger, path: path) {
                    entries.append(zipEntry)
                }
            }
        }
    }
}
