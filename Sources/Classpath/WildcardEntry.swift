//
//  File.swift
//
//
//  Created by 方泓睿 on 2021/2/25.
//

import Files
import Foundation

public class WildcardEntry: CompositeEntry {
    init?(path: String) {
        super.init()

        let baseDirPath = String(path.dropLast())
        guard let baseDir = try? Folder(path: baseDirPath) else {
            return nil
        }
        for file in baseDir.files {
            let path = file.path
            if path.hasSuffix(".jar") || path.hasSuffix("jar".uppercased()) {
                if let zipEntry = ZipEntry(path: path) {
                    entries.append(zipEntry)
                }
            }
        }
    }
}
