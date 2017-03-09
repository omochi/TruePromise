//
//  EventEmitterImpl.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//
//

import Foundation

public class EventEmitterImpl<T> : EventEmitterProtocol {
    public init() {}
    
    public func subscribe(subscriber: @escaping Handler<T>) -> Disposer {
        return subscribers.add(subscriber: subscriber)
    }
    
    public func unsubscribeAll() {
        subscribers.clear()
    }
    
    public func emit(value: T) {
        let pool = subscribers.copy()
        pool.send(value: value)
    }
    
    public func emitLast(value: T) {
        emit(value: value)
        unsubscribeAll()
    }
    
    private var subscribers: SubscriberPool<T> = SubscriberPool()
}
