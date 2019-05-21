
// Section 1 – Video 5: Using protocols as types

import Foundation
import CoreGraphics

protocol Polygon {
    
    static var numberOfSides: Int { get }
    
    var area: Double { get }
    var perimeter: Double { get }
}

extension Polygon {
    
    /// The units of perimeter per unit area.
    var surfaceAreaRatio: Double {
        return perimeter / area
    }
}

struct Triangle : Polygon {
    
    static let numberOfSides = 3
    
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
    
    static let numberOfSides = 4
    
    var area: Double {
        return Double(width) * Double(height)
    }
    
    var perimeter: Double {
        return Double(width) * 2 + Double(height) * 2
    }
}

func takesAPolygon(polygon: Polygon) {/* ... */}

func returnsAPolygon() -> Polygon {
    return CGRect.zero
}


var arbitraryPolygon: Polygon

arbitraryPolygon = Triangle(sideLengthA: 4, sideLengthB: 5, sideLengthC: 6)
arbitraryPolygon = CGRect(x: 0, y: 0, width: 5, height: 7)

var polygons: [Polygon] = [
    arbitraryPolygon,
    Triangle(sideLengthA: 7, sideLengthB: 8, sideLengthC: 3),
    CGRect(x: 0, y: 0, width: 50, height: 2)
]

for polygon in polygons {
    print("Perimeter: \(polygon.perimeter), Area: \(polygon.area), Ratio: \(polygon.surfaceAreaRatio), Number of Sides: \(type(of: polygon).numberOfSides)")
}

// Perimeter: 24.0,  Area: 35.0,             Ratio: 0.685714285714286, Number of Sides: 4
// Perimeter: 18.0,  Area: 10.3923048454133, Ratio: 1.73205080756888,  Number of Sides: 3
// Perimeter: 104.0, Area: 100.0,            Ratio: 1.04,              Number of Sides: 4


// - Protocol Composition - //

protocol Moveable {
    var speed: Double { get set }
}

protocol GroundVehicle {
    static var numberOfWheels: Int { get }
}

struct Car : Moveable, GroundVehicle {
    static let numberOfWheels = 4
    var speed: Double
}

struct Bicycle : Moveable, GroundVehicle {
    static let numberOfWheels = 2
    var speed: Double
}

struct Airplane : Moveable {
    var speed: Double
}

let groundVehicles: [Moveable & GroundVehicle] = [
    Car(speed: 50),
    Bicycle(speed: 2),
     //Airplane(speed: 300) // illegal – Airplane is not a ground vehicle!
]

for vehicle in groundVehicles {
    print("Speed: \(vehicle.speed), Number of wheels: \(type(of: vehicle).numberOfWheels)")
}

// Speed: 50.0, Number of wheels: 4
// Speed: 2.0,  Number of wheels: 2


// - Protocol Composition with AnyObject - //

protocol SomeProtocol {
    func doSomething()
}

class SomeClass : SomeProtocol {
    func doSomething() {/* ... */}
}

class SomeOtherClass {
    weak var weakSomeProtocol: (SomeProtocol & AnyObject)?
}

let c = SomeOtherClass()
let c1 = SomeClass()
c.weakSomeProtocol = c1


// - Existential metatypes - //

let groundVehicleTypes: [(GroundVehicle & Moveable).Type] = [Car.self, Bicycle.self]

for groundVehicleType in groundVehicleTypes {
    print("Number of wheels: \(groundVehicleType.numberOfWheels)")
}

// Number of wheels: 4
// Number of wheels: 2


// - Protocol Casting - //


// the use of Any here is purely for demonstration – generally, you should avoid using it
// as a type wherever possible.
let unknown: Any = Car(speed: 67)

if let moveable = unknown as? Moveable {
    print("It's Moveable, and its speed is: \(moveable.speed)")
} else {
    print("Not Moveable")
}

// It's Moveable, and its speed is: 67.0
