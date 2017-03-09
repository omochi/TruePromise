//
//  Subscribable.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//  Copyright © 2017年 omochimetaru. All rights reserved.
//

import Foundation

public protocol Subscribable {
    associatedtype T
    
    func subscribe(handler: @escaping Handler<T>) -> Disposer
}
