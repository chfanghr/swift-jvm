//
//  JVMError.swift
//
//
//  Created by 方泓睿 on 2021/2/27.
//

import Foundation
import Utilities

public class JVMError: Error, CustomStringConvertible {
    public init(detail: String? = nil, wrappedError: Error? = nil,
                file: String = #file, line: Int = #line, column: Int = #column, function: String = #function)
    {
        self.detail = detail
        self.wrappedError = wrappedError
        self.line = line
        self.column = column
        self.file = file
        self.function = function
    }

    public internal(set) var line: Int
    public internal(set) var column: Int
    public internal(set) var file: String
    public internal(set) var function: String
    public internal(set) var detail: String?
    public internal(set) var wrappedError: Error?

    public var description: String {
        let className = ClassName(of: self)
        let position = "@\(file):\(function):\(line):\(column)"
        let head = "\n\(className)\(position)\n"
        guard let detail = detail else {
            return head
        }
        let withDetail = "detail: \(head)\t\(detail)\n"
        guard let wrappedError = wrappedError else {
            return withDetail
        }
        return "\(withDetail)\t\(wrappedError)\n"
    }
}

public extension JVMError {
    class VirtualMachineError: JVMError {}
    class LinkageError: JVMError {}
    class ReflectiveOperationError: JVMError {}
}
