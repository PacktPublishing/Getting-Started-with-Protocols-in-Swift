
// Section 1 – Video 2: Defining and conforming to protocols



// protocol decleration
protocol YourProtocol : AnotherProtocol {
    
    // property requirements
    var gettableProperty: String { get }
    var gettableSettableProperty: Int { get set }
    
    // method requirements
    func someMethod(param: Double) -> String
    static func staticMethod() -> Float
    
    // subscript requirements
    subscript(gettable param: Int) -> String { get }
    subscript(gettableSettable param: Double) -> String { get set }
}

protocol AnotherProtocol {
    static var staticGettableProperty: [String] { get }
}

struct Foo : YourProtocol {
    
    static var staticGettableProperty: [String] = []

    // implement gettable property requirements as a read-write stored property.
    // the property has a setter, but this doesn't break the contract with the protocol –
    // that the property must have a getter.
    // we can make the setter private, and it won't affect the conformance to the protocol.
    var gettableProperty: String
    
    // implement gettable and settable property requirements as a read-write stored property.
    // the setter *is* required here, as the protocol requires it.
    var gettableSettableProperty: Int
    
    
    // impement method requirment normally
    func someMethod(param: Double) -> String {
        return String(param)
    }
    
    // implement static method requirement as a static method
    // (the only way it can be implemented here)
    static func staticMethod() -> Float {
        return 5
    }
    
    // implement gettable subscript as a read-only subscript
    subscript(gettable param: Int) -> String {
        return String(param)
    }
    
    // implement a gettable and settable subscript the only way it can be implemented,
    // as a read-write subscript.
    subscript(gettableSettable param: Double) -> String {
        get {
            return String(param)
        }
        set {
            print("new value: \(newValue)")
        }
    }
}

class Bar : YourProtocol {
    static var staticGettableProperty: [String] = []

    
    
    // implement gettable property requirement as a read-write computed property.
    // the addition of a setter is fine, as it doesn't break the contract with the
    // protocol – that the property must have a getter.
    var gettableProperty: String {
        get {
            return "foo"
        }
        set {
            print("new value: \(newValue)")
        }
    }
    
    // implement gettable and settable property requirement as a read-write
    // computed property.
    // the setter *must* be included, as the protocol requires the property
    // is settable.
    var gettableSettableProperty: Int {
        get {
            return 5
        }
        set {
            print("new value: \(newValue)")
        }
    }
    
    // implement static method requirement as a class method.
    // this method can be overriden by subclasses.
    static func staticMethod() -> Float {
        return 7
    }
    
    // implement gettable subscript as a read-write subscript
    // the addition of a setter is fine, as it doesn't break the contract with the
    // protocol – that the subscript must have a getter.
    subscript(gettable param: Int) -> String {
        get {
            return String(param)
        }
        set {
            print("new value: \(newValue)")
        }
    }
    
    // ...
    
    func someMethod(param: Double) -> String {
        return String(param)
    }
    
    subscript(gettableSettable param: Double) -> String {
        get {
            return String(param)
        }
        set {
            print("new value: \(newValue)")
        }
    }
}

