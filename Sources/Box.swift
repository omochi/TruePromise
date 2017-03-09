//
//  Box.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//  Copyright © 2017年 omochimetaru. All rights reserved.
//

import Foundation

public class Box<T> {
    public init(value: T) {
        self.value = value
    }
    
    public var value: T
}
