//
//  FailableProtocol.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//
//

import Foundation

public class FailablePromise<T> : FailablePromiseProtocol {
    public convenience init(error: Error) {
        self.init(FailablePromiseImpl(error: error))
    }
    
    public init<X: FailablePromiseProtocol>(_ promise: X) where X.T == T {
        subscribe_ = { promise.subscribe(subscriber: $0) }
        unsubscribeAll_ = { promise.unsubscribeAll() }
    }
    
    public func subscribe(subscriber: @escaping Handler<FailableBox<T>>) -> Disposer {
        return subscribe_(subscriber)
    }
    
    public func unsubscribeAll() {
        unsubscribeAll_()
    }
    
    private let subscribe_: (@escaping Handler<FailableBox<T>>) -> Disposer
    private let unsubscribeAll_: () -> Void
}
