//
//  JVMException.swift
//  
//
//  Created by 方泓睿 on 2021/2/28.
//

import Foundation

extension JVMError.LinkageError{
    public class ClassFormatError: LinkageError{}
    public class UnsupportedClassVersionError: LinkageError{}
}

