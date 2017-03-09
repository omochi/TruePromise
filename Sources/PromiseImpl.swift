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
    
    public func subscribe(handler: @escaping Handler<T>) -> Disposer {
        guard let value = self.value else {
            let box = Box(value: handler)
            subscribers.append(box)
            return Disposer { [weak self] in
                self?.unsubscribe(box: box)
            }
        }
        
        handler(value)
        return Disposer {}
    }
    
    public func resolve(value: T) {
        precondition(!resolved)
        
        self.value = value
        
        let subscribers = self.subscribers
        self.subscribers.removeAll()
        
        for s in subscribers {
            s.value(value)
        }
    }
    
    private var resolved: Bool {
        return value != nil
    }
    
    private func unsubscribe(box: Box<(T) -> Void>) {
        guard let index = subscribers.index(where: { $0 === box }) else {
            return
        }
        subscribers.remove(at: index)
    }
    
    private var value: T?
    
    private var subscribers: [Box<(T) -> Void>] = []
}
