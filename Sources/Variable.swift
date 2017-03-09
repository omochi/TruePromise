//
//  Variable.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/10.
//
//

import Foundation

public class Variable<T> : ReadonlyVariable<T> {
    public init(value: T) {
        value_ = value
    }
    
    public override var value: T {
        get {
            return value_
        }
        set {
            value_ = newValue
            
            subscribers.send(value: value_)
        }
    }
    
    public override func subscribe(subscriber: @escaping Handler<T>) -> Disposer {
        return subscribers.add(subscriber: subscriber)
    }
    
    public override func unsubscribeAll() {
        subscribers.clear()
    }
    
    private var value_: T
    private let subscribers: SubscriberPool<T> = SubscriberPool()
}
