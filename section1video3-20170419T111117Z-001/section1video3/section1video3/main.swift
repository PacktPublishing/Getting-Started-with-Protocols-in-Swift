
// Section 1 – Video 3: Extending protocols


// -- Conforming to Sequence -- //

/// Sequence of positive event Ints from 0.
/// e.g 0, 2, 4, 6, ...
struct PositiveEvenIntegerSequence : Sequence {
    
    func makeIterator() -> AnyIterator<Int> {
        
        var i = 0
        
        return AnyIterator {
            // defer block to increment the number after returning it.
            defer {
                i += 2
            }
            return i
        }
    }
}

let evens = PositiveEvenIntegerSequence()

for element in evens.prefix(3) {
    print(element)
}

// 0
// 2
// 4


let evensAboveTwelve = evens.lazy
    .filter { $0 > 12 }
    .prefix(10)
    .map(String.init)
    .joined(separator: " ")

print(evensAboveTwelve) // 14 16 18 20 22 24 26 28 30 32


let evensAboveAndBelowTen = evens.prefix(10).split(separator: 10).map(Array.init)

print(evensAboveAndBelowTen) // [[0, 2, 4, 6, 8], [12, 14, 16, 18]]



// -- Defining your own protocol extensions -- //

protocol YourProtocol {
    
    func someMethod(param: Int) -> Double
    
    func anotherMethod()
}

extension YourProtocol {
    
    // provide a default implementation for someMethod(param:)
    func someMethod(param: Int) -> Double {
        return Double(param + 20)
    }
}

struct Foo : YourProtocol {
    
    // we don't have to implement the someMethod(param:) requirement,
    // as the protocol extension has already done so!
    
    
    // we must still implement anotherMethod(),
    // as we didn't provide a default implementation for it.
    func anotherMethod() {
        // ...
    }
}

print(Foo().someMethod(param: 57)) // 77.0



extension YourProtocol {
    
    static func staticMethod() {
        print("called static method")
    }
    
    static var someConstant: Int {
        return 42
    }
    
    func sayHello() {
        anotherMethod()
        print("hello!")
    }
    
    var foo: String = ""
    
    var baz: Double {
        get {
            
            // use type(of: self) to get the dynamic metatype of self –
            // this can be used to access static extension implementations or protocol requirements
            let c = type(of: self).someConstant
            
            return someMethod(param: c)
        }
        set {
            print("baz's setter called with: \(newValue)")
        }
    }
    
    subscript(param: Int) -> String {
        return "subscript called with: \(param)"
    }
}

Foo.staticMethod() // called static method

// create instance of Foo to access instance protocol extension implementations
var f = Foo()

print(f.baz)       // 62.0
f.baz = 7          // baz's setter called with: 7.0
print(f[5])        // subscript called with: 5


