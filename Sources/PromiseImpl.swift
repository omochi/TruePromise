//
//  PromiseImpl.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//  Copyright © 2017年 omochimetaru. All rights reserved.
//

import Foundation

public class PromiseImpl<T> : PromiseProtocol {
    public init() {}
    
    public init(value: T) {
        self.value = value
    }
    
    public func subscribe(subscriber: @escaping Handler<T>) -> Disposer {
        guard let value = self.value else {
            return subscribers.add(subscriber: subscriber)
        }
        
        subscriber(value)
        return Disposer {}
    }
    
    public func unsubscribeAll() {
        subscribers.clear()
    }
    
    public func resolve(value: T) {
        precondition(!resolved)
        
        self.value = value
        
        let pool = subscribers.copy()
        subscribers.clear()
        pool.send(value: value)
    }
    
    private var resolved: Bool {
        return value != nil
    }
    
    private var value: T?
    private let subscribers: SubscriberPool<T> = SubscriberPool()
}
