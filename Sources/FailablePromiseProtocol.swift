//
//  FailablePromise.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//
//

import Foundation

public protocol FailablePromiseProtocol : FailableSubscribable, UnsubscribeAllEnable {
}

public extension FailablePromiseProtocol {
    public func map<U>(mapper: @escaping (T) -> U) -> FailablePromise<U> {
        let promise = FailablePromiseImpl<U>()
        
        let _ = subscribe(
            success: { (x: T) in
                let y = mapper(x)
                promise.resolve(value: y)
        },
            failure: { e in
                promise.resolve(error: e)
        })
        
        return FailablePromise(promise)
    }
    
    public func tryMap<U>(mapper: @escaping (T) throws -> U) -> FailablePromise<U> {
        let promise = FailablePromiseImpl<U>()
        
        let _ = subscribe(
            success: { (x: T) in
                do {
                    let y = try mapper(x)
                    promise.resolve(value: y)
                } catch let e {
                    promise.resolve(error: e)
                }
        },
            failure: { e in
                promise.resolve(error: e)
        })
        
        return FailablePromise<U>(promise)
    }
    
    public func tryFlatMap<U>(mapper: @escaping (T) -> Promise<U>) -> FailablePromise<U> {
        return tryMap(mapper: mapper).flatten()
    }
    
    public func tryFlatMap<U>(mapper: @escaping (T) throws -> FailablePromise<U>) -> FailablePromise<U> {
        return tryMap(mapper: mapper).flatten()
    }
    
    public func rescue(rescue: @escaping (Error) -> T) -> Promise<T> {
        let promise = PromiseImpl<T>()
        
        let _ = subscribe(
            success: { (x: T) in
                promise.resolve(value: x)
        },
            failure: { (e: Error) in
                let x = rescue(e)
                promise.resolve(value: x)
        })
        
        return Promise<T>(promise)
    }
    
    public func dispose(when: When) -> FailablePromise<T> {
        let promise = FailablePromiseImpl<T>()
        
        let diposerGroup = DisposerGroup()
        
        let d1 = subscribe(
            success: { (v: T) in
                promise.resolve(value: v)
        },
            failure: { e in
                promise.resolve(error: e)
        })
        diposerGroup.add(d1)
        
        let d2 = when.subscribe {
            diposerGroup.dispose()
        }
        diposerGroup.add(d2)
        
        return FailablePromise(promise)
    }
}

public extension FailablePromiseProtocol where T : PromiseProtocol {
    public func flatten() -> FailablePromise<T.T> {
        typealias U = T.T
        
        let promise = FailablePromiseImpl<U>()
        
        let _ = subscribe(
            success: { (prom: T) in
                let _ = prom.subscribe { x in
                    promise.resolve(value: x)
                }
        },
            failure: { e in
                promise.resolve(error: e)
        })
        
        return FailablePromise<U>(promise)
    }
}

public extension FailablePromiseProtocol where T : FailablePromiseProtocol {
    public func flatten() -> FailablePromise<T.T> {
        typealias U = T.T
        
        let promise = FailablePromiseImpl<U>()
        
        let _ = subscribe(
            success: { (prom: T) in
                let _ = prom.subscribe(
                    success: { (x: U) in
                        promise.resolve(value: x)
                },
                    failure: { e in
                        promise.resolve(error: e)
                })
        },
            failure: { e in
                promise.resolve(error: e)
        })
        
        return FailablePromise<U>(promise)
    }
}
