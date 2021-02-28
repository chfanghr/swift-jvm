//
//  File.swift
//  
//
//  Created by 方泓睿 on 2021/2/28.
//

import Foundation

extension JVMError.ReflectiveOperationError{
    public class ClassNotFoundError: ReflectiveOperationError{
        public init(desiredClass: String,
                                file: String = #file, line: Int = #line, column: Int = #column, function: String = #function){
            super.init()
            self.detail = "Class \(desiredClass) not found"
            self.wrappedError = nil
            self.line = line
            self.column = column
            self.file = file
            self.function = function
        }
    }
}
