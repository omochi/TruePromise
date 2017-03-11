//
//  FailablePromise.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//
//

import Foundation

public protocol FailablePromiseProtocol : FailableSubscribable {
}

public extension FailablePromiseProtocol {
    func map<U>(mapper: @escaping (T) -> U) -> FailablePromise<U> {
        let builder = FailablePromiseBuilder<U>()
        
        let _ = subscribe(
            success: { (x: T) in
                let y = mapper(x)
                builder.resolve(value: y)
        },
            failure: { e in
                builder.resolve(error: e)
        })
        
        return builder.promise
    }
    
    func tryMap<U>(mapper: @escaping (T) throws -> U) -> FailablePromise<U> {
        let builder = FailablePromiseBuilder<U>()
        
        let _ = subscribe(
            success: { (x: T) in
                do {
                    let y = try mapper(x)
                    builder.resolve(value: y)
                } catch let e {
                    builder.resolve(error: e)
                }
        },
            failure: { e in
                builder.resolve(error: e)
        })
        
        return builder.promise
    }
    
    public func tryFlatMap<U>(mapper: @escaping (T) -> Promise<U>) -> FailablePromise<U> {
        return tryMap(mapper: mapper).flatten()
    }
    
    public func tryFlatMap<U>(mapper: @escaping (T) throws -> FailablePromise<U>) -> FailablePromise<U> {
        return tryMap(mapper: mapper).flatten()
    }
    
    func recover(recover: @escaping (Error) -> T) -> Promise<T> {
        let builder = PromiseBuilder<T>()
        
        let _ = subscribe(
            success: { (x: T) in
                builder.resolve(value: x)
        },
            failure: { (e: Error) in
                let x = recover(e)
                builder.resolve(value: x)
        })
        
        return builder.promise
    }
}

public extension FailablePromiseProtocol where T : PromiseProtocol {
    public func flatten() -> FailablePromise<T.T> {
        typealias U = T.T
        
        let builder = FailablePromiseBuilder<U>()
        
        let _ = subscribe(
            success: { (prom: T) in
                let _ = prom.subscribe { x in
                    builder.resolve(value: x)
                }
        },
            failure: { e in
                builder.resolve(error: e)
        })
        
        return builder.promise
    }
}

public extension FailablePromiseProtocol where T : FailablePromiseProtocol {
    func flatten() -> FailablePromise<T.T> {
        typealias U = T.T
        
        let builder = FailablePromiseBuilder<U>()
        
        let _ = subscribe(
            success: { (prom: T) in
                let _ = prom.subscribe(
                    success: { (x: U) in
                        builder.resolve(value: x)
                },
                    failure: { e in
                        builder.resolve(error: e)
                })
        },
            failure: { e in
                builder.resolve(error: e)
        })
        
        return builder.promise
    }
}
