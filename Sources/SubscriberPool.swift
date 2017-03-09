//
//  SubscriberPool.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//
//

import Foundation

public class SubscriberPool<T> {
    public init() {}
    
    public init(_ pool: SubscriberPool<T>) {
        subscribers = pool.subscribers
    }
    
    public func copy() -> SubscriberPool<T> {
        return SubscriberPool<T>(self)
    }
    
    public func add(subscriber: @escaping Handler<T>) -> Disposer {
        let box = Box(value: subscriber)
        subscribers.append(box)
        return Disposer { [weak self, weak box] in
            guard let `self` = self,
                let box = box else {
                return
            }
            self.unsubscribe(box: box)
        }
    }
    
    public func clear() {
        subscribers.removeAll()
    }
    
    public func send(value: T) {
        for x in subscribers {
            x.value(value)
        }
    }
    
    private func unsubscribe(box: Box<Handler<T>>) {
        guard let index = subscribers.index(where: { $0 === box }) else {
            return
        }
        subscribers.remove(at: index)
    }
    
    private var subscribers: [Box<Handler<T>>] = []
}
