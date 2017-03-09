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
        subscribe_ = { promise.subscribe(subscriber: $0) }
        unsubscribeAll_ = { promise.unsubscribeAll() }
    }
    
    public func subscribe(subscriber: @escaping Handler<T>) -> Disposer {
        return subscribe_(subscriber)
    }
    
    public func unsubscribeAll() {
        unsubscribeAll_()
    }
    
    private let subscribe_: (@escaping Handler<T>) -> Disposer
    private let unsubscribeAll_: () -> Void
}

public extension Promise {
    public static func create(
        creator: (@escaping Handler<T>) -> Void
        ) -> Promise<T> {
        
        let promise = PromiseImpl<T>()
        
        let resolve: Handler<T> = { promise.resolve(value: $0) }
        
        creator(resolve)
        
        return Promise<T>(promise)
    }
    
    public static func tryCreate(
        creator: (@escaping Handler<T>, @escaping Handler<Error>) -> Void
        ) -> FailablePromise<T> {
        
        let promise = FailablePromiseImpl<T>()
        
        let success: Handler<T> = { promise.resolve(value: $0) }
        let failure: Handler<Error> = { promise.resolve(error: $0) }
        
        creator(success, failure)
        
        return FailablePromise<T>(promise)
    }
}
