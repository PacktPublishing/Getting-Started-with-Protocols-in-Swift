
// Section 4 – Video 2: Using protocols with generics

import Foundation

protocol P {}
protocol P2 {}

struct S : P, P2 {}

// constraining a generic placeholder to P and P2 using a where clause.
func foo<T : P>(_ t: T) where T : P2 {
    print(t)
}

// using protocol composition to constrain a generic placeholder.
func foo2<T : P & P2>(_ t: T) {
    print(t)
}


let s = S()

// both of these are legal because S conforms to P and P2.
// try removing the conformance to one of the protocols.
foo(s)
foo2(s)

// a protocol that represents a type that can randomly generate an element
protocol RandomGeneratorProtocol {
    associatedtype Element
    func next() -> Element
}
 

/// A random Int generator that generates Ints in the range 0 ..< upperBound.
struct RandomIntGenerator : RandomGeneratorProtocol {
    
    // explicitly satisfy the associatedtype Element with Int.
    typealias Element = Int
    
    var upperBound: UInt32
    
    func next() -> Int {
        // assuming 64 bit platform, Int.max == Int64.max > UInt32.max
        return Int(arc4random_uniform(upperBound))
    }
}

extension Array {
    
    // an initialiser that takes a given concrete RandomGeneratorProtocol-conforming type as input, along with the number of elements to generate.
    // additionally, a where clause is used in order to ensure that the generator has the same element type as the array to construct.
    init<Generator : RandomGeneratorProtocol>(generator: Generator, count: Int) where Generator.Element == Element {
        self = (0..<count).map { _ in generator.next() }
    }
}


let randomInts = Array(generator: RandomIntGenerator(upperBound: 20), count: 5)

print(randomInts) // [15, 5, 0, 14, 5]


// a protocol that represents a type that can be created from a given JSON object – represented as a [String : Any] dictionary.
protocol JSONObjectConvertible {
    init(json: [String : Any]) throws
}

enum JSONParsingError : Error {
    case invalidFormat
}

extension JSONSerialization {
    
    // we're taking a given JSON string as input, with a given metatype to construct a new instance from.
    static func parseJSONObject<T : JSONObjectConvertible>(_ string: String, to type: T.Type) throws -> T {
        
        // encode given string as UTF-8, then pass onto JSONSerialization to get a JSON object.
        guard let data = string.data(using: .utf8),
            let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String : Any] else {
                
                throw JSONParsingError.invalidFormat
        }
        
        // forward onto the initialiser requirement defined in the conforming type.
        return try type.init(json: jsonObject)
    }
}

struct Person {
    var name: String
    var age: Int
}

extension Person : JSONObjectConvertible {
    
    init(json: [String : Any]) throws {
        
        // simply attempt to get the property values, throwing an error if they don't exist, or are
        // of incorrect type.
        guard let name = json["name"] as? String, let age = json["age"] as? Int else {
            throw JSONParsingError.invalidFormat
        }
        
        self.name = name
        self.age = age
    }
}


let personJSON = "{\"name\":\"foo\",\"age\":57}"
let person = try JSONSerialization.parseJSONObject(personJSON, to: Person.self)

print(person) // Person(name: "foo", age: 57)


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
    
    var dx: Component
    var dy: Component
}

let v = Vector2<Int>.zero

let v1 = Vector2(dx: 2.0, dy: 4.7)
let v2 = Vector2(dx: 6.7, dy: 9.1)

print(v1 + v2) // Vector2<Double>(x: 8.6999999999999993, y: 13.800000000000001)



// A random generator for doubles in a given range.
struct RandomDoubleGenerator : RandomGeneratorProtocol {
    
    var range: ClosedRange<Double>
    
    init(range: ClosedRange<Double>) {
        self.range = range
    }
    
    init(range: Range<Double>) {
        
        precondition(!range.isEmpty, "Cannot generate a random Double in an empty range")
        
        // if we're being initialised with a Range (non-inclusive of upper bound),
        // we need to get the next Double down from the upper bound in order to express as
        // a ClosedRange (inclusive of upper bound).
        self.range = range.lowerBound ... range.upperBound.nextDown
    }
    
    func next() -> Double {
        return range.lowerBound + (range.upperBound - range.lowerBound) * (Double(arc4random()) / Double(UInt32.max))
    }
}

let randomDoubles = RandomDoubleGenerator(range: 0 ... 2.5)

print(randomDoubles.next())
print(randomDoubles.next())
print(randomDoubles.next())

// 0.715384545204086
// 0.75567842013102
// 1.84668450542881


struct RandomVector2Generator<Component : Numeric> : RandomGeneratorProtocol {
    
    // simply store the generating functions from the given generators.
    private let nextDX: () -> Component
    private let nextDY: () -> Component
    
    // we're taking two (possibly different) random generator types as parameters, so long as their element types match.
    init<T : RandomGeneratorProtocol, U : RandomGeneratorProtocol>(dx: T, dy: U) where T.Element == Component, U.Element == Component {
        nextDX = dx.next
        nextDY = dy.next
    }
    
    func next() -> Vector2<Component> {
        // simply call the stored functions from the generators.
        return Vector2(dx: nextDX(), dy: nextDY())
    }
}

let doubleVectorGenerator = RandomVector2Generator(dx: RandomDoubleGenerator(range: 0 ... 6.7), dy: RandomDoubleGenerator(range: -5.5 ... 2.5))

let randomDoubleVectors = Array(generator: doubleVectorGenerator, count: 5)

print(randomDoubleVectors)

// [
//   Vector2<Double>(dx: 1.4441179988077186, dy: 2.4270571525970137),
//   Vector2<Double>(dx: 5.4246387601421775, dy: -1.695799314462533),
//   Vector2<Double>(dx: 3.7523783817543603, dy: -0.31651483355474497),
//   Vector2<Double>(dx: 3.176448211091675, dy: 2.3237985763288567),
//   Vector2<Double>(dx: 6.0427710873640077, dy: -1.4373554484772857)
// ]


let intVectorGenerator = RandomVector2Generator(dx: RandomIntGenerator(upperBound: 50), dy: RandomIntGenerator(upperBound: 100))

let randomIntVectors = Array(generator: intVectorGenerator, count: 5)

print(randomIntVectors)

// [
//   Vector2<Int>(dx: 1, dy: 26),
//   Vector2<Int>(dx: 37, dy: 11),
//   Vector2<Int>(dx: 12, dy: 83),
//   Vector2<Int>(dx: 4, dy: 33),
//   Vector2<Int>(dx: 41, dy: 31)
// ]


