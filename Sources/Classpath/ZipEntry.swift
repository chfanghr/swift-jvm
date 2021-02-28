//
//  File.swift
//
//
//  Created by 方泓睿 on 2021/2/25.
//

import Files
import Foundation
import Zip
import Utilities
import JVMError

public class ZipEntry: ClasspathEntryBase {
    public let path: String
    private let dir: Folder

    private static var firstTime = true

    private static func createTempFolder() throws -> URL {
        let userTmpDir = FileManager.default.temporaryDirectory
        let userTmpFolder = try Folder(path: userTmpDir.path)
        let newTmpFolder = try userTmpFolder.createSubfolder(named: UUID().uuidString)
        return newTmpFolder.url
    }

    public init?(with logger: Logger, path: String) {
        if Self.firstTime {
            Zip.addCustomFileExtension("jar")
            Zip.addCustomFileExtension("jar".uppercased())
            Self.firstTime = false
        }

        guard let tmpUrl = try? Self.createTempFolder(),
              let file = try? File(path: path),
              let _ = try? Zip.unzipFile(file.url, destination: tmpUrl, overwrite: false, password: nil),
              let tmpDir = try? Folder(path: tmpUrl.path)
        else {
            return nil
        }

        self.path = path
        dir = tmpDir
        super.init(with: logger)
    }

    deinit {
        try! dir.delete()
    }
}

extension ZipEntry: ClasspathEntry {
    public func readClass(name: String) throws -> (Data, ClasspathEntry) {
        guard let file = try? dir.file(named: name),
              let data = try? file.read() else{
            throw JVMError.ReflectiveOperationError.ClassNotFoundError(desiredClass: name)
        }
        return (data, self)
    }

    public var description: String {
        path
    }
}
