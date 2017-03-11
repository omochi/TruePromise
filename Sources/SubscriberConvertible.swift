//
//  SubscriberConvertible.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/11.
//
//

import Foundation

public protocol SubscriberConvertible {
    associatedtype T
    func toSubscriber() -> Subscriber<T>
}
