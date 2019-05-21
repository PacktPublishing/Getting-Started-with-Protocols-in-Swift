
// Section 3 – Video 4: Where clauses in protocol extensions

// really just a stripped down version of the 
// standard library's Collection protocol.
protocol Container {
    
    associatedtype Element
    
    var count: Int { get }
    subscript(index: Int) -> Element { get }
}

extension Container where Element : Equatable {
    
    func contains(_ element: Element) -> Bool {
        
        for index in 0..<count {
            if self[index] == element {
                return true
            }
        }
        
        return false
    }
}

struct ArrayWrapper<Element> : Container {
    
    var elements: [Element]

    
    var count: Int {
        return elements.count
    }
    
    subscript(index: Int) -> Element {
        return elements[index]
    }
}

let a = ArrayWrapper(elements: ["foo", "bar", "baz"])

print(a.contains("baz")) // true
print(a.contains("qux")) // false


protocol P {}
struct S : P {}
class C : P {}




protocol JSONValue {
    var jsonValue: String { get }
}

extension JSONValue where Self : Integer {
    var jsonValue: String {
        // simply forward onto CustomStringConvertible's description
        return description
    }
}

extension Int  : JSONValue {}
extension UInt : JSONValue {}

print(67.jsonValue) // 67

extension Optional where Wrapped : JSONValue {
    var jsonValue: String {
        return self?.jsonValue ?? "null"
    }
}

struct JSONObject<Value : JSONValue> : JSONValue {
    
    var base: [String : Value]
    
    init(base: [String : Value]) {
        self.base = base
    }
    
    var jsonValue: String {
        
        let valuePairs = base.map{ "\($0.jsonValue):\($1.jsonValue)" }
        
        return "{\(valuePairs.joined(separator: ","))}"
    }
}

extension String : JSONValue {
    var jsonValue: String {
        // simply add quotation marks to the string.
        // (the debug description also does this, but that's somewhat of an implementation detail).
        return "\"\(self)\""
    }
}

print("hey".jsonValue) // "hey"

print(JSONObject(base: ["foo" : 67, "bar" : 78]).jsonValue) // {"bar":78,"foo":67}



extension Container where Element == JSONValue {
    
    var jsonValue: String {
        
        var result = ""
        
        for index in 0..<count {
            if index != 0 {
                result += ","
            }
            result += self[index].jsonValue
        }
        
        return "[\(result)]"
    }
}

let c = ArrayWrapper<JSONValue>(elements: ["foo", 56, "bar"])

print(c.jsonValue) // ["foo",56,"bar"]


