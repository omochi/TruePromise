//
//  UnsubscribeAllEnable.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/10.
//
//

import Foundation

public protocol UnsubscribeAllEnable {
    func unsubscribeAll()
}

public extension UnsubscribeAllEnable {
    @discardableResult
    public func unsubscribeAll<When: Subscribable>(when: When) -> Disposer {
        return when.subscribe { _ in
            self.unsubscribeAll()
        }
    }
}
