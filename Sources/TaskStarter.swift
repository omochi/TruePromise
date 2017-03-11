//
//  TaskStarter.swift
//  TruePromise
//
//  Created by omochimetaru on 2017/03/11.
//
//

import Foundation

public class TaskStarter<T> {
    public init(start: @escaping (_ cancelWhen: EventEmitter<Void>) -> Promise<T>) {
        start_ = start
    }
    
    public func start() {
        cancel()
        
        let cancelEvent = EventEmitter<Void>()
        self.cancelEvent = cancelEvent
        
        start_(cancelEvent).map { [weak self] ret in
            self?.event.emit(ret)
            return
        }.end()
    }
    
    public func cancel() {
        guard let cancelEvent = cancelEvent else {
            return
        }
        cancelEvent.emit()
        self.cancelEvent = nil
    }
    
    private var start_: (_ cancelWhen: EventEmitter<Void>) -> Promise<T>
    
    private var cancelEvent: EventEmitter<Void>?
    private var event: EventEmitter<T> = EventEmitter<T>()
}
