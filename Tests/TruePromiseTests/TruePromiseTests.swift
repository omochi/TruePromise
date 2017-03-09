import XCTest
@testable import TruePromise

func delayInt(x: Int, delay: Double) -> Promise<Int> {
    return Promise<Int>.create { resolve in
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            resolve(x)
        }
    }
}

class TruePromiseTests: XCTestCase {
    
    func testOn() {
        let exp = expectation(description: "exp")
        
        delayInt(x: 3, delay: 1.0)
            .map { x -> Int in
                exp.fulfill()
                return x * 3
            }.end()
        
        waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    func testOnPromise() {
        let exp = expectation(description: "exp")
        
        delayInt(x: 3, delay: 1.0)
            .flatMap { x -> Promise<Int> in
                return delayInt(x: x * 2, delay: 1.0)
            }.map { x -> Int in
                exp.fulfill()
                return x * 3
            }.end()
        
        waitForExpectations(timeout: 3.0, handler: nil)
    }
}
