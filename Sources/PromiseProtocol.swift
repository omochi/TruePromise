//
//  PromiseProtocol.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//
//

import Foundation

public protocol PromiseProtocol : Subscribable {
}

public extension PromiseProtocol {
    public func end() {
    }
    
    public func map<U>(mapper: @escaping (T) -> U) -> Promise<U> {
        let promise = PromiseImpl<U>()
        
        let _ = subscribe { (x: T) in
            let y = mapper(x)
            promise.resolve(value: y)
        }
        
        return Promise<U>(promise)
    }
    
    public func tryMap<U>(mapper: @escaping (T) throws -> U) -> FailablePromise<U> {
        let promise = FailablePromiseImpl<U>()
        
        let _ = subscribe { (x: T) in
            do {
                let y = try mapper(x)
                promise.resolve(value: y)
            } catch let e {
                promise.resolve(error: e)
            }
        }
        
        return FailablePromise<U>(promise)
    }
    
    public func flatMap<U>(mapper: @escaping (T) -> Promise<U>) -> Promise<U> {
        return map(mapper: mapper).flatten()
    }
    
    public func tryFlatMap<U>(mapper: @escaping (T) throws -> FailablePromise<U>) -> FailablePromise<U> {
        return tryMap(mapper: mapper).flatten()
    }
    
    public func dispose<X : Subscribable>(when: X) -> Promise<T> {
        let promise = PromiseImpl<T>()
        
        let diposerGroup = DisposerGroup()
        
        let d1 = subscribe { (v: T) in
            promise.resolve(value: v)
        }
        diposerGroup.add(d1)
        
        let d2 = when.subscribe { (w: X.T) in
            diposerGroup.dispose()
        }
        diposerGroup.add(d2)
        
        return Promise(promise)
    }
    
}

public extension PromiseProtocol where T : PromiseProtocol {
    public func flatten() -> Promise<T.T> {
        typealias U = T.T
        
        let promise = PromiseImpl<U>()
        
        let _ = subscribe { (prom: T) in
            let _ = prom.subscribe { (x: U) in
                promise.resolve(value: x)
            }
        }
        
        return Promise<U>(promise)
    }
}
