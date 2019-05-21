
// Section 3 – Video 1: Associatedtype Requirements

import Foundation


protocol RandomGeneratorProtocol {
    associatedtype Element
    func next() -> Element
}

/// A random Int generator that generates Ints in the range 0 ..< upperBound.
struct RandomIntGenerator : RandomGeneratorProtocol {
    
    // explicitly satisfy the associatedtype Element with Int.
    typealias Element = Int
    
    let upperBound: UInt32
    
    init(upperBound: UInt32) {
        self.upperBound = upperBound
    }
    
    func next() -> Int {
        // assuming 64 bit platform, Int.max == Int64.max > UInt32.max
        return Int(arc4random_uniform(upperBound))
    }
}

/// An RGB color with components in the range 0 to 1.
struct RGBColor {
    var red: Double, green: Double, blue: Double
}

struct RandomColorGenerator : RandomGeneratorProtocol {
    
    // implicitly satisfy the associatedtype Element with RGBColor.
    func next() -> RGBColor {
        
        let random = { Double(arc4random()) / Double(UInt32.max) }
        
        return RGBColor(red: random(), green: random(), blue: random())
    }
}

protocol Vector {
    
    associatedtype Component : FloatingPoint
    
    static var componentCount: Int { get }
    
    subscript(i: Int) -> Component { get set }
}

struct Vector2 : Vector {
    
    static let componentCount = 2
    
    var x: Double
    var y: Double
    
    subscript(i: Int) -> Double {
        get {
            switch i {
            case 0:
                return x
            case 1:
                return y
            default:
                fatalError("Index out of bounds")
            }
        }
        set {
            switch i {
            case 0:
                x = newValue
            case 1:
                y = newValue
            default:
                fatalError("Index out of bounds")
            }
        }
    }
}


extension Vector {
    var magnitude: Component {
        
        let componentSquareSum = (0 ..< type(of: self).componentCount)
            .lazy
            .map { self[$0] * self[$0] } // lazily apply a mapping that squares the elements
            .reduce(0, +)                // sum the elements
        
        return sqrt(componentSquareSum)
    }
}

let v = Vector2(x: 3, y: 4)
print(v.magnitude) // 5.0


protocol Container {
    associatedtype Element
    subscript(index: Int) -> Element { get }
}

extension Array : Container {}


// let a: Container = [1, 2, 3]










func foo<C : Container>(_ t: C) {
    print(t[0])
}

foo([2, 3, 4])







