
// Section 2 – Video 4: Stored properties in protocol extensions

import Foundation

protocol P : class {
    // ...
}

// caseless enumeration to simply act as a namespace for the static properties for the keys of our associated objects.
fileprivate enum _AssociatedKeys {
    
    // typed as Never? to indicate that their value is irrelevant.
    // it's only their location in static memory that is important.
    static var foo: Never?
    static var bar: Never?
}

extension P {
    
    var foo: String! {
        get {
            return objc_getAssociatedObject(self, &_AssociatedKeys.foo) as? String
        }
        set {
            objc_setAssociatedObject(self, &_AssociatedKeys.foo,
                                     newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var bar: Int! {
        get {
            return objc_getAssociatedObject(self, &_AssociatedKeys.bar) as? Int
        }
        set {
            objc_setAssociatedObject(self, &_AssociatedKeys.bar,
                                     newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

class C : P {
    
}

let c = C()
c.foo = "hey"
c.bar = 7

print(c.foo, c.bar) // 7 hey



