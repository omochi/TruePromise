//
//  FailableSubscribable.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//
//

import Foundation

public protocol FailableSubscribable {
    associatedtype T
    
    func subscribe(subscriber: @escaping Subscriber<FailableBox<T>>) -> Disposer
}

public extension FailableSubscribable {
    public func subscribe(success: @escaping Subscriber<T>,
                          failure: @escaping Subscriber<Error>) -> Disposer
        
    {
        return subscribe { box in
            do {
                let x = try box.get()
                success(x)
            } catch let e {
                failure(e)
            }
        }
    }
}
