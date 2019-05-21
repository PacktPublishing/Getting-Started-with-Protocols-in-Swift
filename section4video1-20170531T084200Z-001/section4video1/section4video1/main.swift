
// Section 4 – Video 1: Introduction to Generics

import Foundation


func pickRandom<T>(_ lhs: T, _ rhs: T) -> T {
    return arc4random_uniform(2) == 0 ? lhs : rhs
}

// T is inferred to be Int, therefore (Int, Int) -> Int
let i = pickRandom(5, 7)


// T is inferred to be String, therefore (String, String) -> String
let str = pickRandom("foo", "bar")


// using @autoclosure to prevent the argument that isn't chosen from being evaluated.
func pickRandom2<T>(_ lhs: @autoclosure () -> T, _ rhs: @autoclosure () -> T) -> T {
    return arc4random_uniform(2) == 0 ? lhs() : rhs()
}


func printStaticType<T>(of: T) {
    print(T.self)
}

printStaticType(of: "foo")     // String
printStaticType(of: 67.8)      // Double
printStaticType(of: 67 as Any) // Any


struct CollectionOfTwo<Element> {
    var first: Element
    var second: Element
}

// explicitly satisfy Element with String
let c = CollectionOfTwo<String>(first: "foo", second: "bar")

// inferred to be a CollectionOfTwo<Double>
let c1 = CollectionOfTwo(first: 12.0, second: 57.3)

// inferred to be an Array<Int>
let a = [1, 2, 3]


extension CollectionOfTwo {
    
    // inferred to return a CollectionOfTwo<Element>.
    func swapped() -> CollectionOfTwo {
        return CollectionOfTwo(first: second, second: first)
    }
}


let c3 = CollectionOfTwo(first: "bar", second: "baz")

// illegal – even though String is a subtype of Any, CollectionOfTwo<String> is not a subtype of CollectionOfTwo<Any>.
// let c4: CollectionOfTwo<Any> = c3

// you need to re-box it
let c5 = CollectionOfTwo<Any>(first: c3.first, second: c3.second)


class Box<Element> {
    var element: Element
    
    init(element: Element) {
        self.element = element
    }
}

// we cannot convert a Box<String> to a Box<Any> – doing so
// would allow us to assign an Int to a String property.
let b = Box(element: "foo")

// let bAny: Box<Any> = b
// bAny.element = 56



// compiler does implicit conversion for arrays.
// this is safe because of the value semantics.
let a1 = [1, 2, 3]
let a2: [Any] = a1

// implicit conversions also happen for sets...
let a3: Set = [4, 5, 6]
let a4: Set<AnyHashable> = a3

// and dictionaries...
let d1 = ["foo" : 5]
let d2: [String : Any] = d1




