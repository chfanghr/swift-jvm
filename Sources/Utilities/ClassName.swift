//
//  File.swift
//
//
//  Created by 方泓睿 on 2021/2/28.
//

import Foundation

public func ClassName(of obj: AnyObject) -> String {
    String(describing: type(of: obj))
}
