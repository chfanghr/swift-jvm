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
