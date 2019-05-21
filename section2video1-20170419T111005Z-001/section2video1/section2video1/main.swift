
// Section 2 – Video 1: Mutating requirements and class-bound protocols

import Foundation

/// Simple protocol for a random Int generator.
protocol RandomGeneratorProtocol {
    mutating func next() -> Int
}

/// A random Int generator that generates Ints in the range 0 ..< upperBound.
struct RandomGenerator : RandomGeneratorProtocol {
    
    let upperBound: UInt32
    
    init(upperBound: UInt32) {
        self.upperBound = upperBound
    }
    
    func next() -> Int {
        // assuming 64 bit platform, Int.max == Int64.max > UInt32.max
        return Int(arc4random_uniform(upperBound))
    }
}

let random = RandomGenerator(upperBound: 65)

print(random.next())
print(random.next())
print(random.next())


/// A random Int generator that generates Ints in the range 0 ..< upperBound,
/// where the same Int won't be repeated twice in a row.
struct RandomNonRepeatingGenerator : RandomGeneratorProtocol {
    
    let upperBound: UInt32
    private var previous: Int?
    
    init(upperBound: UInt32) {
        precondition(upperBound > 1, "Non-inclusive upper bound for a non-repeating random generator must be greater than 1")
        self.upperBound = upperBound
    }
    
    mutating func next() -> Int {
        
        let next: Int
        
        if let previous = previous {

            // if there's a previous value, then get a new random Int in the range 0 ..< (upperBound - 1),
            // 'shifting up' by 1 if it's equal or greater than the value not to repeat.
            let random = Int(arc4random_uniform(upperBound - 1))
            next = (random >= previous) ? random + 1 : random
            
        } else {
            // otherwise, first time generating – just generate a new random Int in the range 0 ..< upperBound.
            next = Int(arc4random_uniform(upperBound))
        }
        
        previous = next
        return next
    }
}

var nonRepeatingRandom: RandomGeneratorProtocol = RandomNonRepeatingGenerator(upperBound: 2)

print(nonRepeatingRandom.next())
print(nonRepeatingRandom.next())
print(nonRepeatingRandom.next())



// -- Mutating getters and nonmutating setters -- //

protocol CopiesOnWrite {
    var hasUniqueBuffer: Bool { mutating get }
}

class FakeArrayBuffer<Element> {
    
    var contents: [Element]
    
    init(contents: [Element]) {
        self.contents = contents
    }
}

struct FakeArray<Element> : CopiesOnWrite {
    
    private var buffer: FakeArrayBuffer<Element>
    
    init(_ array: [Element]) {
        self.buffer = FakeArrayBuffer(contents: array)
    }
    
    var contents: [Element] {
        get {
            return buffer.contents
        }
        set {
            if !hasUniqueBuffer {
                // if we don't have a unique view onto the buffer,
                // make a copy of it.
                buffer = FakeArrayBuffer(contents: newValue)
            } else {
                // otherwise, we can mutate directly.
                buffer.contents = newValue
            }
        }
    }
    
    var hasUniqueBuffer: Bool {
        mutating get {
            return isKnownUniquelyReferenced(&buffer)
        }
    }
}

var a = FakeArray(["foo", "bar", "baz"])

print(a.hasUniqueBuffer, a.contents)
// true ["foo", "bar", "baz"]

var a1 = a // now both a1 and a have a view onto the FakeArrayBuffer

print(a.hasUniqueBuffer, a.contents, a1.contents)
// false ["foo", "bar", "baz"] ["foo", "bar", "baz"]

a1.contents.append("qux") // force a copy of the FakeArrayBuffer

print(a.hasUniqueBuffer, a.contents, a1.contents)
// true ["foo", "bar", "baz"] ["foo", "bar", "baz", "qux"]



// -- Class-bound protocols -- //

protocol FooDelegate : class {
    func somethingHappened()
}

class Foo {
    weak var delegate: FooDelegate?
    
    func receieveSomeEvent() {
        
        // ...
        
        delegate?.somethingHappened()
    }
}

class Bar : FooDelegate {
    
    func somethingHappened() {
        print("Something happened!")
    }
}

let b = Bar()
let f = Foo()

f.delegate = b
f.receieveSomeEvent()

// b prints: Something happened!


@objc protocol P {
    var value: Int { get set }
}

class C : P {
    var value = 0
}

class C1 : P {
    var value = 0
}

let array: [P] = [C(), C1(), C1(), C()]

for element in array {
    element.value += 5
}



