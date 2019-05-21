
// Coding Exercise 1: Generic programming with protocols

import Foundation

protocol Number {
    //
    // What operations are common to all numeric types (and share the same semantics)?
    //
    // Compare the requirements you think of with:
    // - In Swift 3: The Numeric protocol described in https://github.com/apple/swift-evolution/blob/master/proposals/0104-improved-integers.md#numeric
    // - In Swift 4: The Standard Library Numeric protocol
}


// Why doesn't the following compile?
// What modification(s) do we need to make in order to allow it to?
//
func square<T>(_ value: T) -> T {
    return value * value
}


// Could we make the below function generic to work across all signed number types?
// (i.e Double, Float, Int, Int64, Int32, Int16, Int8, etc.)
//
// Is there a standard library protocol we can use to describe a signed number type?
// If not, what requirements should such a protocol include?
//
func sameSign(_ lhs: Int, _ rhs: Int) -> Bool {
    return (lhs < 0 && rhs < 0) || (lhs >= 0 && rhs >= 0)
}

print(sameSign(5, -4))  // false
print(sameSign(-1, -9)) // true
print(sameSign(7, 6))   // true


// Why doesn't the following compile?
// What modification(s) do we need to make in order to allow it to?
//
func pickRandom<T, U, V>(_ lhs: T, rhs: U) -> V {
    return arc4random_uniform(2) == 0 ? lhs : rhs
}

// The below LinkedList only works for String elements
// Could we make it generic?
// If so, do we put the generic placeholder on LinkedList, Node, or both?
//
struct LinkedList : Sequence {
    
    class Node {
        
        var element: String
        var next: Node?
        
        init(element: String) {
            self.element = element
        }
    }
    
    private var head: Node?
    private var tail: Node?
    
    mutating func append(_ newElement: String) {
        
        let newNode = Node(element: newElement)
        
        if let tail = tail {
            tail.next = newNode
        } else {
            head = newNode
        }
        
        tail = newNode
    }
    
    // Here we're implementing Sequence's makeIterator() requirement
    // in order to iterate over the elements.
    //
    // Could we conform LinkedList to Collection? Take a look at the documentation
    // for the Collection protocol and have a go.
    //
    func makeIterator() -> AnyIterator<String> {
        var head = self.head
        return AnyIterator {
            defer { head = head?.next }
            return head?.element
        }
    }
}

// Once LinkedList is generic, how do we construct a new instance with a given concrete type satisfying the placeholder?
// Could we make LinkedList have an initialiser that takes a *Sequence* (not just Array!) of elements, and constructs
// a new linked list with those elements? What constraint(s) (if any) would this initialiser need?
//
var linkedList = LinkedList()
linkedList.append("foo")
linkedList.append("bar")

for element in linkedList {
    print(element)
}



