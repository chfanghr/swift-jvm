//
//  File.swift
//
//
//  Created by 方泓睿 on 2021/2/28.
//

import Foundation

public extension JVMError.VirtualMachineError {
    class InternalError: VirtualMachineError {}
    class UnknownError: VirtualMachineError {}
    class StackOverflowError: VirtualMachineError {}
}

public extension JVMError.VirtualMachineError.UnknownError {
    class JRENotFoundError: UnknownError {
        public init(file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
            super.init()
            detail = "JRE path cannot be detected"
            wrappedError = nil
            self.line = line
            self.column = column
            self.file = file
            self.function = function
        }
    }

    class JREBootClasspathClassesNotFoundError: UnknownError {
        public init(file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
            super.init()
            detail = "boot classes cannot be detected"
            wrappedError = nil
            self.line = line
            self.column = column
            self.file = file
            self.function = function
        }
    }
}
