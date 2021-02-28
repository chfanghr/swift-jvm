//
//  Measure.swift
//  
//
//  Created by 方泓睿 on 2021/2/28.
//

import Foundation
import Dispatch
@_exported import Logging

public func measure<T>(with logger: Logger, name: String? = nil,
                       _ task: @autoclosure () throws -> T) rethrows -> T{
    let taskName = name != nil ? name! : "<unknown task>"
    logger.info("measure: running task")
    let begin = DispatchTime.now()
    let retVal = try task()
    let end = DispatchTime.now()
    let nanoInterval = end.uptimeNanoseconds - begin.uptimeNanoseconds
    let interval = Double(nanoInterval) / 1_000_000_000
    
    defer{
        logger.info("measure: task done",
                    metadata: [
                        "task": .string(taskName),
                        "time": .stringConvertible(interval)
                    ])
    }
    
    return retVal
}
