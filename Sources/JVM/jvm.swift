//
//  jvm.swift
//
//
//  Created by 方泓睿 on 2021/2/24.
//

import Foundation
import Classpath
@_exported import JVMError
import Utilities

public class JVM {
    public static var virtualMachines: [JVM] = []
    
    private(set) var classpathStorage: Classpath? = nil
    public var classpath: Classpath{
        guard let classpath = classpathStorage else{
            preconditionFailure()
        }
        return classpath
    }
    public var verboseMode: Bool {
        didSet{
            logger.logLevel = verboseMode ? .debug : .warning
            logger.info("verbose mode enabled")
        }
    }
    public let identifier: UUID
    private var logger: Logger
    public var id: UUID{
        identifier
    }
    
    public init?(jreOption: String, cpOption: String, verboseMode: Bool = false, vmIdentifier: UUID = UUID()) {
        self.identifier = vmIdentifier
        self.logger = Logger(label: "jvm")
        logger[metadataKey: "id"] = .stringConvertible(identifier)
        self.verboseMode = verboseMode
        logger.logLevel = verboseMode ? .debug : .warning
        
        logger.info("booting jvm", metadata: [
            "jreOption": .string(jreOption),
            "cpOption": .string(cpOption)
        ])
        
        do{
            self.classpathStorage = try measure(with: logger, name: "setting up classpath",
                                         Classpath(with: logger, jreOption: jreOption, cpOption: cpOption))
            logger.info("classpath setup succeeded", metadata: [
                "classpath": .stringConvertible(classpath)
            ])
        }catch{
            logger.critical("crashed due to classpath setup failure", metadata: [
                "error": .string(String(describing: error))
            ])
            return nil
        }
    }

    deinit {
        logger.info("exit")
    }
    
    public func start(mainClass: String, args: [String]) throws {
        do{
            logger.info("executing main class", metadata: [
                "mainClass": .string(mainClass),
                "args": .stringConvertible(args)
            ])
            logger.info("looking for main class")
            guard let mainClassData = measure(with: logger, name: "looking for main class",
                                              classpath[mainClass]) else{
                throw JVMError.ReflectiveOperationError.ClassNotFoundError(desiredClass: mainClass)
            }
            logger.info("main class look up successfully", metadata: [
                "mainClassData": .stringConvertible(mainClassData)
            ])
            logger.debug("main class data", metadata: [
                "data": .string(mainClassData.hexEncodedString())
            ])
        } catch {
            handleException(error)
        }
    }
    
    public func handleException(_ err: Error){
        logger.critical("unexpected error or unhandled exception", metadata: [
            "error": .stringConvertible(String(describing: err))
        ])
    }
}
