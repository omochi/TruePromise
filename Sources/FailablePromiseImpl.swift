//
//  FailablePromiseImpl.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//
//

import Foundation

public class FailablePromiseImpl<T> : FailablePromiseProtocol {
    public func subscribe(handler: @escaping Handler<FailableBox<T>>) -> Disposer {
        return inner.subscribe(handler: handler)
    }
    
    public func resolve(value: T) {
        inner.resolve(value: FailableBox<T>(value: value))
    }

    public func resolve(error: Error) {
        inner.resolve(value: FailableBox<T>(error: error))
    }
    
    private let inner: PromiseImpl<FailableBox<T>> = PromiseImpl()
}