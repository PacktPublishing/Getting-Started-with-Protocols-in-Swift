
// Section 2 – Video 3: Optional protocol requirements

import Foundation

class C : NSObject {}

@objc protocol FooDelegate {
    func somethingHappened()
    @objc optional func somethingElseHappened(param: C)
}

class Foo {
    weak var delegate: FooDelegate?
    
    func eventTriggered() {
        delegate?.somethingHappened()
        delegate?.somethingElseHappened?(param: C())
    }
}

class Bar : FooDelegate {
    
    func somethingHappened() {
        print("Something happened!")
    }

}

let f = Foo()
let b = Bar()
f.delegate = b

f.eventTriggered()

// Something happened!
// Something else happened!





