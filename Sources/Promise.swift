//
//  PromiseImpl.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//  Copyright © 2017年 omochimetaru. All rights reserved.
//

import Foundation

public class Promise<T> : PromiseProtocol {
    public init() {}
    
    public init(value: T) {
        self.value = value
    }
    
    public func subscribe(subscriber: @escaping Subscriber<T>) -> Disposer
    {
        guard let value = self.value else {
            return subscribers.add(subscriber)
        }
        
        subscriber(value)
        return Disposer {}
    }
    
    fileprivate func resolve(value: T) {
        precondition(!resolved)
        
        self.value = value
        
        subscribers.send(value: value)
        subscribers.clear()
    }
    
    private var resolved: Bool {
        return value != nil
    }
    
    private var value: T?
    private let subscribers: SubscriberPool<T> = SubscriberPool()
}

public class PromiseBuilder<T> {
    public init() {}
    
    public func resolve(value: T) {
        promise.resolve(value: value)
    }
    
    public let promise: Promise<T> = Promise<T>()
}

public extension Promise {
    static func create(
        creator: (@escaping Subscriber<T>) -> Void
        ) -> Promise<T> {
        
        let builder = PromiseBuilder<T>()
        
        creator({ builder.resolve(value: $0) })
        
        return builder.promise
    }
    
}
