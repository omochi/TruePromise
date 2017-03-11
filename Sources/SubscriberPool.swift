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
    
    public func add(_ subscriber: @escaping Subscriber<T>) -> Disposer {
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
        let subscribers = self.subscribers
        for x in subscribers {
            x.value(value)
        }
    }
    
    private func unsubscribe(box: Box<Subscriber<T>>) {
        guard let index = subscribers.index(where: { $0 === box }) else {
            return
        }
        subscribers.remove(at: index)
    }
    
    private var subscribers: [Box<Subscriber<T>>] = []
}
