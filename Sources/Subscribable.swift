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
    
    func subscribe(subscriber: @escaping Handler<T>) -> Disposer
}

public extension Subscribable {
    public func toWhen() -> When {
        return When(self)
    }
}
