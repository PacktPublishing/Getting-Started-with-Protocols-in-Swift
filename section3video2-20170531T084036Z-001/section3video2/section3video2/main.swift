
// Section 3 – Video 2: Self requirements


protocol Interpolatable {
    func interpolated(to: Self, by: Double) -> Self
}

struct Point : Interpolatable {
    
    var x: Double
    var y: Double
    
    func interpolated(to other: Point, by ratio: Double) -> Point {
        return Point(x: x + (other.x - x) * ratio, y: y + (other.y - y) * ratio)
    }
}

let p = Point(x: 2, y: 3)
let p1 = Point(x: 4, y: 7)

print(p.interpolated(to: p1, by: 0.5)) // Point(x: 3.0, y: 5.0)



protocol Copyable {
    func copied() -> Self
}

class C : Copyable, CustomStringConvertible {
    
    var i: Int
    
    required init(i: Int) {
        self.i = i
    }
    
    func copied() -> Self {
        // call init(i:) on the dynamic metatype value.
        return type(of: self).init(i: i)
    }
    
    var description: String {
        return "C(i: \(i))"
    }
}


let c = C(i: 5)

// because Self is used as the return type in the protocol
// requirement, we can use Copyable as a type.
let c1: Copyable = c

// will simply return a Copyable
let c2 = c1.copied()

c.i = 7

print(c)  // C(i: 7)
print(c1) // C(i: 7)
print(c2) // C(i: 5)


final class C1 : Copyable {
    
    var i: Int
    
    // note the fact that init(i:) doesn't have to be required.
    init(i: Int) {
        self.i = i
    }
    
    func copied() -> C1 {
        return C1(i: i)
    }
}



// Self vs. self vs. type(of: self)

protocol P {
    static func requiredStaticMethod()
    func requiredInstanceMethod()
}

class D : P {}
class E : D {}

extension P {
    
    static func requiredStaticMethod() {
        print(Self.self) // print(self)
    }
    
    static func staticMethod() {
        print(Self.self) // print(self)
    }
    
    func instanceMethod() {
        print(Self.self) // print(type(of: self))
    }
    
    func requiredInstanceMethod() {
        print(Self.self) // print(type(of: self))
    }
}

E.staticMethod()             // E
E.requiredStaticMethod()     // E
E().instanceMethod()         // E
E().requiredInstanceMethod() // E

(E.self as D.Type).staticMethod()         // D
(E.self as D.Type).requiredStaticMethod() // D
(E() as D).instanceMethod()               // D
(E() as D).requiredInstanceMethod()       // D

(E.self as P.Type).staticMethod()         // E
(E.self as P.Type).requiredStaticMethod() // D
(E() as P).instanceMethod()               // E
(E() as P).requiredInstanceMethod()       // D

(E.self as D.Type as P.Type).staticMethod()         // E
(E.self as D.Type as P.Type).requiredStaticMethod() // D
(E() as D as P).instanceMethod()                    // D
(E() as D as P).requiredInstanceMethod()            // D


