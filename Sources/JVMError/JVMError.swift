//
//  JVMError.swift
//  
//
//  Created by 方泓睿 on 2021/2/27.
//

import Foundation

public enum JVMError: Error{
    case classFormatError
    case unsupportedClassVersionError
    case invalidConstantPoolIndex
}
