//
//  Dispose.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//  Copyright © 2017年 omochimetaru. All rights reserved.
//

import Foundation

public class Disposer {
    public init(dispose: @escaping () -> Void) {
        self.dispose_ = dispose
    }
    
    public func dispose() {
        guard !disposed else {
            return
        }
        
        disposed = true
        dispose_()
    }
    
    public private(set) var disposed: Bool = false
    
    private var dispose_: () -> Void
}

