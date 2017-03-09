//
//  DisposerGroup.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/09.
//  Copyright © 2017年 omochimetaru. All rights reserved.
//

import Foundation

public class DisposerGroup {
    public func add(_ disposer: Disposer) {
        if disposed {
            disposer.dispose()
        } else {
            disposers.append(disposer)
        }
    }
    
    public func dispose() {
        guard !disposed else {
            return
        }
        disposed = true
        let disposers = self.disposers
        self.disposers.removeAll()
        for x in disposers {
            x.dispose()
        }
    }
    
    private var disposed: Bool = false
    private var disposers: [Disposer] = []
}
