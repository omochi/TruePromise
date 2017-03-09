//
//  FailableBox.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//
//

import Foundation

public class FailableBox<T> {
    public init(value: T) {
        self.value = value
    }
    
    public init(error: Error) {
        self.error = error
    }
    
    public func get() throws -> T {
        guard let value = self.value else {
            throw error!
        }
        return value
    }

    private var value: T?
    private var error: Error?
}

