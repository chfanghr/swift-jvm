//
//  JVMException.swift
//
//
//  Created by 方泓睿 on 2021/2/28.
//

import Foundation

public extension JVMError.LinkageError {
    class ClassFormatError: LinkageError {}
    class UnsupportedClassVersionError: LinkageError {}
}
