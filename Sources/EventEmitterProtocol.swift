//
//  EventEmitterProtocol.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//
//

import Foundation

public protocol EventEmitterProtocol : Subscribable, UnsubscribeAllEnable {
}

public extension EventEmitterProtocol {
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

