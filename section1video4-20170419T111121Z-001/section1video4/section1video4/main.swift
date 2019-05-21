
// Section 1 – Video 4: Why use protocols?


// The use of value types to prevent unintended sharing

import Foundation

class Foo {
    var importantArray: [String] = ["foo", "bar", "baz"]
}

class Bar {
    
    var lessImportantArray: [String] = []
    
    func mutateData() {
        lessImportantArray.append("irrelevant string")
    }
}

let f = Foo()
let b = Bar()
b.lessImportantArray = f.importantArray

// everything's fine, until...
b.mutateData()

print(f.importantArray) // !!

// (
//     foo,
//     bar,
//     baz,
//     "irrelevant string"
// )



extension Sequence {
    
    func count(where predicate: (Iterator.Element) throws -> Bool) rethrows -> Int {
        
        var count = 0
        
        for element in self where try predicate(element) {
            count += 1
        }
        
        return count
    }
}

let array = [1, 2, 4, 1, 3]
print(array.count { $0 == 1 }) // 2


let dict = [1 : "foo", 2 : "foo", 3 : "bar", 4 : "foo"]
print(dict.count { $0.value == "foo" }) // 3


let str = "Hello world!"
print(str.characters.count { $0 == "!" }) // 1


// Retroactive conformance

protocol Polygon {
    var area: Double { get }
    var perimeter: Double { get }
}

struct Triangle : Polygon {
    
    var sideLengthA: Double
    var sideLengthB: Double
    var sideLengthC: Double
    
    var area: Double {
        // using Heron's formula
        let s = perimeter * 0.5
        return sqrt(s * (s - sideLengthA) * (s - sideLengthB) * (s - sideLengthC))
    }
    
    var perimeter: Double {
        return sideLengthA + sideLengthB + sideLengthC
    }
}

extension CGRect : Polygon {
    var area: Double {
        return Double(width) * Double(height)
    }
    
    var perimeter: Double {
        return Double(width) * 2 + Double(height) * 2
    }
}

