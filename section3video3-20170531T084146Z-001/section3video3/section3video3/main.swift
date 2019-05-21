
// Section 3 – Video 3: Operator Requirements


protocol P {
    static func +(lhs: Self, rhs: Self) -> Self
    static func +=(lhs: inout Self, rhs: Self)
}

extension P {
    static func +(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs
        lhs += rhs
        return lhs
    }
}

struct S : P {
    
    static func +=(lhs: inout S, rhs: S) {
        lhs.i += rhs.i
    }
    
    var i: Int
}

var s  = S(i: 5)
let s1 = S(i: 7)

let s2: S = s + s1 // S(i: 12)




let a = [1, 2, 3]
let b = a + [4, 5, 6]
print(b) // [1, 2, 3, 4, 5, 6]

var strA = "hello "
strA += "world!"
print(strA) // hello world!



protocol Numeric : ExpressibleByIntegerLiteral {
    
    static func +(lhs: Self, rhs: Self) -> Self
    static func +=(lhs: inout Self, rhs: Self)
    
    static func -(lhs: Self, rhs: Self) -> Self
    static func -=(lhs: inout Self, rhs: Self)
    
    static func *(lhs: Self, rhs: Self) -> Self
    static func *=(lhs: inout Self, rhs: Self)
}

extension Double : Numeric {}
extension Float  : Numeric {}
extension Int    : Numeric {}

extension Sequence where Iterator.Element : Numeric {
    func sum() -> Iterator.Element {
        // we can pass the operator into reduce, as operators
        // are functions in Swift.
        return reduce(0, +)
    }
    
    func product() -> Iterator.Element {
        return reduce(1, *)
    }
}

let array = [1, 2, 3, 4, 5]
print(array.sum()) // 15
print(array.product()) // 120

let set: Set = [6, 7, 8]
print(set.sum()) // 21
print(set.product()) // 336




