//
//  EventEmitter.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//
//

import Foundation

public class EventEmitter<T> : EventEmitterProtocol {
    public init<X: EventEmitterProtocol>(_ ee: X) where X.T == T {
        subscribe_ = { ee.subscribe(subscriber: $0) }
        unsubscribeAll_ = { ee.unsubscribeAll() }
    }
    
    public func subscribe(subscriber: @escaping Handler<T>) -> Disposer {
        return subscribe_(subscriber)
    }
    
    public func unsubscribeAll() {
        unsubscribeAll_()
    }
    
    private let subscribe_: (@escaping Handler<T>) -> Disposer
    private let unsubscribeAll_: () -> Void
}
