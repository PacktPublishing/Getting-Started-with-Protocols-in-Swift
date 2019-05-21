
// Section 2 – Video 2: Initialiser requirements

import Foundation


protocol P {
    init(string: String)
}

struct S : P {
    init(string: String) {
        
    }
}

class C {
    init() {
        // ...
    }
}

final class D : C, P {
    
    var i: Int
    
    override init() {
        i = 5
        super.init()
    }
    
    init(string: String) {
        i = 7
        super.init()
    }
}


// -- Failable initialiser requirements -- //

protocol JSONRepresentable {
    init(json: [String : Any]) throws
}

enum JSONParsingError : Error {
    case invalidFormat
}

extension JSONSerialization {
    
    static func parse<T : JSONRepresentable>(_ string: String, to type: T.Type) throws -> T {
        
        guard let data = string.data(using: .utf8),
            let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String : Any] else {
                
            throw JSONParsingError.invalidFormat
        }
        
        return try T(json: jsonObject)
    }
}

struct Person {
    var name: String
    var age: Int
}

extension Person : JSONRepresentable {
    
    init(json: [String : Any]) throws {
        
        guard let name = json["name"] as? String, let age = json["age"] as? Int else {
            throw JSONParsingError.invalidFormat
        }
        
        self.name = name
        self.age = age
    }
}


let personJSON = "{\"name\":\"foo\",\"age\":57}"
let person = try JSONSerialization.parse(personJSON, to: Person.self)

print(person)

