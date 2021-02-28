//
//  File.swift
//  
//
//  Created by 方泓睿 on 2021/2/28.
//

import Foundation

extension JVMError.VirtualMachineError{
    public class InternalError: VirtualMachineError{}
    public class UnknownError: VirtualMachineError{}
    public class StackOverflowError: VirtualMachineError{}
}

extension JVMError.VirtualMachineError.UnknownError{
    public class JRENotFoundError: UnknownError{
        public init(file: String = #file, line: Int = #line, column: Int = #column, function: String = #function){
            super.init()
            self.detail = "JRE path cannot be detected"
            self.wrappedError = nil
            self.line = line
            self.column = column
            self.file = file
            self.function = function
        }
    }
    
    public class JREBootClasspathClassesNotFoundError: UnknownError{
        public init(file: String = #file, line: Int = #line, column: Int = #column, function: String = #function){
            super.init()
            self.detail = "boot classes cannot be detected"
            self.wrappedError = nil
            self.line = line
            self.column = column
            self.file = file
            self.function = function
        }
    }
}
