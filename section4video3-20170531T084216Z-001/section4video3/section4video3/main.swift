
// Section 4 – Video 3: Using protocols to refine extensions on generic types

import Foundation

// a protocol that reprents a numerical type (actually a stripped down version of the Numeric protocol to be introduced in Swift 4).
protocol Numeric : ExpressibleByIntegerLiteral {
    
    static func +(lhs: Self, rhs: Self) -> Self
    static func +=(lhs: inout Self, rhs: Self)
    
    static func -(lhs: Self, rhs: Self) -> Self
    static func -=(lhs: inout Self, rhs: Self)
    
    static func *(lhs: Self, rhs: Self) -> Self
    static func *=(lhs: inout Self, rhs: Self)
}

// conform a handfull of numeric types to Numeric (feel free to add more)
// they all already implement the requirements – so we don't have to implement any.
extension Int    : Numeric {}
extension UInt   : Numeric {}
extension Float  : Numeric {}
extension Double : Numeric {}


// A simple 2D vector with numeric components
struct Vector2<Component : Numeric> {
    
    // A (0, 0) vector
    static var zero: Vector2 {
        return Vector2(dx: 0, dy: 0)
    }
    
    // add two vectors together, component-wise.
    static func +(lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }
    
    // subtract one vector from another, component-wise (i.e lhs + (-rhs)).
    static func -(lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }
    
    // multiple a given vector by a scalar.
    static func *(lhs: Vector2, rhs: Component) -> Vector2 {
        return Vector2(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
    }
    
    var dx: Component
    var dy: Component
}

extension Vector2 {
    
    // apply a given transformation to both of the components of the vector.
    func map<T>(_ transform: (Component) throws -> T) rethrows -> Vector2<T> {
        return try Vector2<T>(dx: transform(dx), dy: transform(dy))
    }
}

// we can only negate a vector if the component type is signed (e.g we cannot negate a UInt vector).
extension Vector2 where Component : SignedNumber {
    
    func negated() -> Vector2 {
        // apply the unary - operator to both components of the vector,
        // i.e negate both components.
        return map(-)
    }
}

// we can only use floating-point operations on vectors where the components are floating-point numbers.
extension Vector2 where Component : FloatingPoint {
    
    // a (+inf, +inf) vector.
    static var infinity: Vector2 {
        return Vector2(dx: .infinity, dy: .infinity)
    }
    
    // the magnitude of a given vector.
    var magnitude: Component {
        return sqrt(dx * dx + dy * dy)
    }
}

extension Vector2 where Component == Double {
    
    // the direction of a given vector, in radians.
    // 0 corresponds to east – the angle increments in an anti-clockwise direction.
    var direction: Component {
        
        // for a negative dx, we need to add pi (180 degrees) onto the result.
        if dx < 0 {
            return .pi + atan(dy / dx)
        }
        
        return atan(dy / dx)
    }
    
    // the angle between two given vectors, in radians.
    func angle(to other: Vector2) -> Component {
        // simply get the difference in directions.
        return other.direction - direction
    }
}


let v = Vector2<Int>.zero

let v1 = Vector2(dx: 2.0, dy: 4.7)
let v2 = Vector2(dx: 6.7, dy: 9.1)

print(v1 + v2) // Vector2<Double>(x: 8.6999999999999993, y: 13.800000000000001)

print(v1.magnitude) // 5.10783711564885

print(v1.negated()) // Vector2<Double>(x: -2.0, y: -4.7000000000000002)


let v3 = Vector2<UInt>(dx: 2, dy: 6)

// print(v3.negated())

let v4 = Vector2<Float>.infinity


extension FloatingPoint {
    func radiansToDegrees() -> Self {
        return self * 180 / .pi
    }
}

let v5 = Vector2(dx: 50.0, dy: 50.0)
let v6 = Vector2(dx: -10.0, dy: 50.0)

print(v5.direction.radiansToDegrees())     // 45.0
print(v6.direction.radiansToDegrees())     // 101.30993247402
print(v5.angle(to: v6).radiansToDegrees()) // 56.3099324740202


// a simple stripped down version of the stdlib's Collection protocol.
protocol Container {
    
    associatedtype Element
    
    var count: Int { get }
    
    subscript(index: Int) -> Element { get }
}

// a container that interleaves elements from two other containers with the same element types.
// i.e for [1, 2, 3] & [4, 5, 6],
// interleaving gives [1, 4, 2, 5, 3, 6]
struct InterleavedContainer<C1 : Container, C2 : Container> : Container where C1.Element == C2.Element {
    
    // explicitly satisfy Container's Element associatedtype requirement.
    typealias Element = C1.Element
    
    var base1: C1
    var base2: C2
    
    init(_ base1: C1, _ base2: C2) {
        self.base1 = base1
        self.base2 = base2
    }
    
    var count: Int {
        return base1.count + base2.count
    }
    
    subscript(index: Int) -> Element {
        
        precondition(index >= 0 && index < count, "Index out of bounds")
        
        // half of the given index to subscript with – for two containers of equal length,
        // this corresponds to the index to access the given element with, using the parity
        // if the index to determine which to subscript.
        let halfIndex = index / 2
        
        // the minimum count of the two containers – we can only interleave up to this index.
        let minCount = min(base1.count, base2.count)
        
        // if we're beyond interleaving.
        if halfIndex >= minCount {
            
            // the index to subscript the larger container with,
            // note we're no longer using the halfIndex, as we must increment
            // in steps of 1.
            let offsetIndex = index - minCount
            
            // subscript the larger container.
            return (base1.count > base2.count) ? base1[offsetIndex] : base2[offsetIndex]
        }
        
        // otherwise interleave, using the parity of the index to determine which one to subscript.
        return (index % 2 == 0) ? base1[halfIndex] : base2[halfIndex]
    }
}

// Array already satisfies all the requirements of Container.
extension Array : Container {}

let interleavedInts = InterleavedContainer([1, 2, 3, 4], [5, 6, 7, 8, 9])

for index in 0..<interleavedInts.count {
    print(interleavedInts[index])
}

// 1
// 5
// 2
// 6
// 3
// 7
// 4
// 8
// 9


// we can extend InterleavedContainer such that the element type of the two
// containers is String (we only have to write one contraint in order to express this,
// as InterleavedContainer itself constrains C1.Element == C2.Element).
extension InterleavedContainer where C1.Element == String {
    
    func joined() -> String {
        
        var result = ""
        
        for index in 0..<count {
            result.append(self[index])
        }
        
        return result
    }
}

let interleavedStrings = InterleavedContainer(["foo", "qux"], ["baz"])

print(interleavedStrings.joined()) // foobazqux


// simple example of a class being able to be used as a generic constraint.
class C {
    var i: Int
    
    init(i: Int) {
        self.i = i
    }
}

class D : C {}


// we can extend InterleavedContainer such that the element type of the two
// containers must inherit from (or be) C.
extension InterleavedContainer where C1.Element : C {
    
    func printIValues() {
        for index in 0..<count {
            print(self[index].i)
        }
    }
}

let interleavedCs = InterleavedContainer([C(i: 1), C(i: 2)], [C(i: 3)])
let interleavedDs = InterleavedContainer([D(i: 4), D(i: 5)], [D(i: 6)])

interleavedCs.printIValues()
interleavedDs.printIValues()

// 1
// 3
// 2

// 4
// 6
// 5

