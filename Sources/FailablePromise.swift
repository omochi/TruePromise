//
//  FailableProtocol.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//
//

import Foundation

public class FailablePromise<T> : FailablePromiseProtocol {
    public init<X: FailablePromiseProtocol>(_ promise: X) where X.T == T {
        self.subscribe_ = { handler in
            promise.subscribe(handler: handler)
        }
    }
    
    public func subscribe(handler: @escaping Handler<FailableBox<T>>) -> Disposer {
        return subscribe_(handler)
    }
    
    private let subscribe_: (@escaping Handler<FailableBox<T>>) -> Disposer
}
