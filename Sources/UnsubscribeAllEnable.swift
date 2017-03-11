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
    func unsubscribeAll<W: Subscribable>(when: W) -> Disposer {
        return when.subscribe { _ in
            self.unsubscribeAll()
        }
    }
}
