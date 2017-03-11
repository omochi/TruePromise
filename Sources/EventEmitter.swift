//
//  EventEmitterImpl.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//
//

import Foundation

public class EventEmitter<T> : Subscribable, UnsubscribeAllEnable {
    public init() {}
    
    public func subscribe(subscriber: @escaping Subscriber<T>) -> Disposer {
        return subscribers.add(subscriber)
    }
    
    public func unsubscribeAll() {
        subscribers.clear()
    }
    
    public func emit(_ value: T) {
        subscribers.send(value: value)
    }
    
    public func emitLast(_ value: T) {
        emit(value)
        unsubscribeAll()
    }
    
    private var subscribers: SubscriberPool<T> = SubscriberPool()
}

public extension EventEmitter {
    func on(subscriber: @escaping Subscriber<T>) {
        let _ = subscribe(subscriber: subscriber)
    }
    
    func once(subscriber: @escaping Subscriber<T>) {
        let disposerGroup = DisposerGroup()
        
        let d = subscribe { (x: T) in
            disposerGroup.dispose()
            
            subscriber(x)
        }
        disposerGroup.add(d)
    }
}


