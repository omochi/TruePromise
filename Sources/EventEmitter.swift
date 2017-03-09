//
//  EventEmitter.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//
//

import Foundation

public class EventEmitter<T> : Subscribable, UnsubscribeAllEnable {
    internal init() {}
    
    public func subscribe(subscriber: @escaping Handler<T>) -> Disposer {
        fatalError("abstract method")
    }
    
    public func unsubscribeAll() {
        fatalError("abstract method")
    }
}
