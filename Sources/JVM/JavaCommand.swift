//
//  JavaCommand.swift
//
//
//  Created by 方泓睿 on 2021/2/24.
//

import ArgumentParser
import Foundation

public struct JavaCommand: ParsableCommand {
    public static let configuration =
        CommandConfiguration(commandName: "java")

    @Flag(name: [.customLong("version"),
                 .customLong("version", withSingleDash: true),
                 .customLong("showversion", withSingleDash: true),
                 .customLong("show-version")], help: "Print product version and exit.")
    public var showVersion = false

    @Flag(name: [.short, .customLong("verbose")], help: "Enable verbose output.")
    public var verboseMode = false

    @Option(name: [.customLong("Xjre", withSingleDash: true)],
            help: ArgumentHelp(
                "JRE path of directories and zip/jar files.",
                valueName: "paths",
                shouldDisplay: false
            ))
    public var jreOption: String = ""

    @Option(name: [.customLong("cp", withSingleDash: true), .customLong("class-path")],
            help: ArgumentHelp(
                "Class search path of directories and zip/jar files.",
                discussion: " A `:` separated list of directories, each directory is a directory of modules.",
                valueName: "paths"
            ))
    public var classPath: String = ""

    @Argument(help: "Name of main class to be executed.")
    public var `class`: String

    @Argument(help: "Arguments for main method.")
    public var args: [String] = []

    public mutating func run() throws {
        let jvm = JVM(jreOption: jreOption, cpOption: classPath, verboseMode: verboseMode)
        precondition(jvm != nil, "jvm initialization failure")
        try jvm!.start(mainClass: self.class, args: args)
    }

    public init() {}
}
