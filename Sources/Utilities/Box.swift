//
//  Box.swift
//  
//
//  Created by 方泓睿 on 2021/2/27.
//

import Foundation

public class Box<T>{
    public var val: T
    
    public init(_ val: T){
        self.val = val
    }
}

public class BoxImmutable<T>{
    public let val: T
    
    public init(_ val: T){
        self.val = val
    }
}


