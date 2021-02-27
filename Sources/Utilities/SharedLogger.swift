//
//  SharedLogger.swift
//  
//
//  Created by 方泓睿 on 2021/2/27.
//

import Foundation
@_exported import Logging

public class SharedLogger{
    private let loggerStorage: BoxImmutable<Logger>
    
    public init(label: String, factory: (String) -> LogHandler){
        loggerStorage = BoxImmutable(Logger(label: label, factory: factory))
    }
    
    public init(label: String){
        loggerStorage = BoxImmutable(Logger(label: label))
    }
    
    public var logger: Logger{
        loggerStorage.val
    }
}
