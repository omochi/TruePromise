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
    func map<U>(mapper: @escaping (T) -> U) -> Promise<U> {
        let builder = PromiseBuilder<U>()
        
        let _ = subscribe { (x: T) in
            let y = mapper(x)
            builder.resolve(value: y)
        }
        
        return builder.promise
    }
    
    func tryMap<U>(mapper: @escaping (T) throws -> U) -> FailablePromise<U> {
        let builder = FailablePromiseBuilder<U>()
        
        let _ = subscribe { (x: T) in
            do {
                let y = try mapper(x)
                builder.resolve(value: y)
            } catch let e {
                builder.resolve(error: e)
            }
        }
        
        return builder.promise
    }
    
    func flatMap<U>(mapper: @escaping (T) -> Promise<U>) -> Promise<U> {
        return map(mapper: mapper).flatten()
    }
    
    func tryFlatMap<U>(mapper: @escaping (T) throws -> FailablePromise<U>) -> FailablePromise<U> {
        return tryMap(mapper: mapper).flatten()
    }
}

public extension PromiseProtocol where T == Void {
    func end() {
    }
}

public extension PromiseProtocol where T : PromiseProtocol {
    func flatten() -> Promise<T.T> {
        typealias U = T.T
        
        let builder = PromiseBuilder<U>()
        
        let _ = subscribe { (prom: T) in
            let _ = prom.subscribe { (x: U) in
                builder.resolve(value: x)
            }
        }
        
        return builder.promise
    }
}
