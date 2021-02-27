//
//  SharedLogger.swift
//  
//
//  Created by 方泓睿 on 2021/2/27.
//

import Foundation
import os

public class SharedLogger{
    private let loggerStorage: BoxImmutable<Logger>
    
    public init(subsystem: String, category: String){
        loggerStorage = BoxImmutable(Logger(subsystem: subsystem, category: category))
    }
    
    public init(){
        loggerStorage = BoxImmutable(Logger())
    }
    
    public var logger: Logger{
        loggerStorage.val
    }
}
