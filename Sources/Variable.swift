//
//  Variable.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/10.
//
//

import Foundation

public class Variable<T> : Subscribable, UnsubscribeAllEnable {
    public init(value: T) {
        value_ = value
    }
    
    public var value: T {
        get {
            return value_
        }
        set {
            value_ = newValue
            
            subscribers.send(value: value_)
        }
    }
    
    public func subscribe(subscriber: @escaping Subscriber<T>) -> Disposer {
        return subscribers.add(subscriber)
    }
    
    public func unsubscribeAll() {
        subscribers.clear()
    }
    
    private var value_: T
    private let subscribers: SubscriberPool<T> = SubscriberPool()
}

public extension Variable {
    func on(subscriber: @escaping Subscriber<T>) {
        let _ = subscribe(subscriber: subscriber)
    }
}
