//
//  main.swift
//
//
//  Created by 方泓睿 on 2021/2/24.
//

import Foundation
import JVM
import LogDog

LoggingSystem.bootstrap{ label in
    let sink = LogSinks.BuiltIn.medium.suffix("\n")
    return SugarLogHandler(label: label, sink: sink, appender: TextLogAppender.stdout)
}

JavaCommand.main()

