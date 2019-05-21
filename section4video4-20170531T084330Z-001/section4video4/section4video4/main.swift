
// Section 4 – Video 4: Equatable, Comparable & Hashable


// Equatable


// a given Person type with a mandatory first and last name,
// and optional age.
struct Person {
    
    var firstName: String
    var lastName: String
    
    var age: Int?
}

extension Person : Equatable {
    
    // simply return true if all the properties are equivalent.
    static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.firstName == rhs.firstName
            && lhs.lastName == rhs.lastName
            && lhs.age == rhs.age
    }
}

let people = [
    Person(firstName: "bob", lastName: "smith", age: 27),
    Person(firstName: "fred", lastName: "jacobson", age: nil),
    Person(firstName: "william", lastName: "eastbury", age: 56)
]


// we can now use various standard library methods defined in extensions with "where T : Equatable" constraints...

print(people.contains(Person(firstName: "bob", lastName: "smith", age: 27))) // true

print(people.contains(Person(firstName: "bob", lastName: "smith", age: nil))) // false

print(people.index(of: Person(firstName: "fred", lastName: "jacobson", age: nil)) as Any) // Optional(1)

// special == overload for arrays of Equatable elements (this will naturally be expressed as a part of Array's implementation
// once conditional conformance is implemented in Swift 4).
print(people == people)


// Comparable

enum DiceRoll : Int {
    case one = 1, two, three, four, five, six
}

extension DiceRoll : Comparable {
    
    static func < (lhs: DiceRoll, rhs: DiceRoll) -> Bool {
        // simply forward onto Int's Comparable implementation.
        return lhs.rawValue < rhs.rawValue
    }
}

// we can now use the various standard library comparison overloads...

print(DiceRoll.one < DiceRoll.five) // true

print(DiceRoll.two <= DiceRoll.four) // true

print(DiceRoll.four >= DiceRoll.three) // true

print(DiceRoll.four > DiceRoll.four) // false


// as well as methods defined in extensions with "where T : Comparable" constraints

let diceRolls: [DiceRoll] = [.six, .one, .three, .two]

print(diceRolls.sorted()) // [.one, .two, .three, .six]



// Hashable

struct Size {
    var width: Int
    var height: Int
}

extension Size : Hashable {
    
    static func ==(lhs: Size, rhs: Size) -> Bool {
        return lhs.width == rhs.width && lhs.height == rhs.height
    }
    
    var hashValue: Int {
        // simple hashValue algorithm using the overflow operators (preventing Swift from
        // trapping upon overflow).
        return width.hashValue &* 31 &+ height.hashValue
    }
}

// the overflow operators allow the value to "wrap around" past the maxiumum
print(UInt.max &+ 5) // 4


// by conforming to Hashable, we can now use our type in sets and dictionaries,
// as well allowing it to take part in other algorithms that use the hashValue to boost performance.

var points: Set = [Size(width: 2, height: 3), Size(width: 5, height: 2)]

print(points.contains(Size(width: 5, height: 2))) // true

print(points.insert(Size(width: 2, height: 3)))
// (inserted: false, memberAfterInsert: Point(x: 2, y: 3))

print(points.insert(Size(width: 6, height: 7)))
// (inserted: true, memberAfterInsert: Point(x: 6, y: 7))


let dict = [Size(width: 4, height: 5) : "foo"]

print(dict[Size(width: 4, height: 5)] as Any) // "foo"

