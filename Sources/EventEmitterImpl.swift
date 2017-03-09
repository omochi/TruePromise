//
//  EventEmitterImpl.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//
//

import Foundation

public class EventEmitterImpl<T> : EventEmitter<T> {
    public override init() {}
    
    public override func subscribe(subscriber: @escaping Handler<T>) -> Disposer {
        return subscribers.add(subscriber: subscriber)
    }
    
    public override func unsubscribeAll() {
        subscribers.clear()
    }
    
    public func emit(value: T) {
        subscribers.send(value: value)
    }
    
    public func emitLast(value: T) {
        emit(value: value)
        unsubscribeAll()
    }
    
    private var subscribers: SubscriberPool<T> = SubscriberPool()
}

public extension EventEmitterImpl {
    public func on(handler: @escaping Handler<T>) {
        let _ = subscribe { (x: T) in
            handler(x)
        }
    }
    
    public func once(handler: @escaping Handler<T>) {
        let disposerGroup = DisposerGroup()
        
        let d = subscribe { (x: T) in
            disposerGroup.dispose()
            
            handler(x)
        }
        disposerGroup.add(d)
    }
}
