//
//  When.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/10.
//
//

import Foundation

public class When {
    public convenience init<S: Subscribable>(_ inner: S) {
        self.init(subscribe: { subscriber in
            inner.subscribe { (_: S.T) in
                subscriber()
            }
        })
    }
    
    public init(subscribe: @escaping (@escaping Handler<Void>) -> Disposer) {
        subscribe_ = subscribe
    }
    
    public func subscribe(subscriber: @escaping Handler<Void>) -> Disposer {
        return subscribe_(subscriber)
    }
    
    private let subscribe_: (@escaping Handler<Void>) -> Disposer
}
