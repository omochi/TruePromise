//
//  FailablePromiseImpl.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//
//

import Foundation

public class FailablePromise<T> : FailablePromiseProtocol {
    public init() {}
    
    public init(error: Error) {
        inner.resolve(value: FailableBox<T>(error: error))
    }
    
    public func subscribe(subscriber: @escaping Subscriber<FailableBox<T>>) -> Disposer {
        return inner.promise.subscribe(subscriber: subscriber)
    }
    
    fileprivate func resolve(value: T) {
        inner.resolve(value: FailableBox<T>(value: value))
    }

    fileprivate func resolve(error: Error) {
        inner.resolve(value: FailableBox<T>(error: error))
    }
    
    private let inner: PromiseBuilder<FailableBox<T>> = PromiseBuilder<FailableBox<T>>()
}

public class FailablePromiseBuilder<T> {
    public init() {}

    public func resolve(value: T) {
        promise.resolve(value: value)
    }
    
    public func resolve(error: Error) {
        promise.resolve(error: error)
    }
    
    public let promise: FailablePromise<T> = FailablePromise<T>()
}
