//
//  ReadonlyVariable.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/10.
//
//

import Foundation

public class ReadonlyVariable<T> : Subscribable, UnsubscribeAllEnable {
    internal init() {}
    
    public var value: T {
        get {
            fatalError("abstract")
        }
    }
    
    public func subscribe(subscriber: @escaping Handler<T>) -> Disposer {
        fatalError("abstract")
    }
    
    public func unsubscribeAll() {
        fatalError("abstract")
    }
}
