//
//  Promise.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//  Copyright © 2017年 omochimetaru. All rights reserved.
//

import Foundation

public class Promise<T> : PromiseProtocol {    
    public convenience init(value: T) {
        self.init(PromiseImpl(value: value))
    }
    
    public init<X: PromiseProtocol>(_ promise: X) where X.T == T {
        self.subscribe_ = { handler in
            promise.subscribe(handler: handler)
        }
    }
    
    public func subscribe(handler: @escaping Handler<T>) -> Disposer {
        return subscribe_(handler)
    }
    
    public static func create(
        creator: (@escaping Handler<T>) -> Void
        ) -> Promise<T> {
        
        let promise = PromiseImpl<T>()
        
        let resolve: Handler<T> = { promise.resolve(value: $0) }
        
        creator(resolve)
        
        return Promise<T>(promise)
    }
    
    private let subscribe_: (@escaping Handler<T>) -> Disposer
}
