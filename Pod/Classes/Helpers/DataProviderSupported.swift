/*
  Copyright © 09/05/2016 Shaps

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
 */

import Foundation

/**
 *  Defines a type that all DataProvider items must conform to. This ensures we can perform sectioning, equality, etc...
 */
public protocol DataProviderSupported: KVCodable, Hashable { }

/**
 *  Adds KVC (get-only) to types conforming to this protocol
 */
public protocol KVCodable {
  
  /**
   Returns the value for the specified key
   
   - parameter key: The key to query
   
   - returns: The underlying value
   */
  func valueForKey(_ key : String) -> Any?
  
  /**
   Returns the value for the specified keyPath
   
   - parameter keyPath: The keyPath to query
   
   - returns: The underlying value
   */
  func valueForKeyPath(_ keyPath : String) -> Any?
  
}

extension KVCodable {
  
  /**
   Returns the value for the property identified by a given key.
   
   - parameter key: The key for the property
   
   - returns: The value for the property identified by key.
   */
  public func valueForKey(_ key: String) -> Any? {
    let mirror = Mirror(reflecting: self)
    
    for child in mirror.children {
      if child.label == key {
        return child.value
      }
    }
    
    return nil
  }
  
  /**
   Returns the value for the derived property identified by a given key path.
   
   - parameter keyPath: A key path of the form relationship.property (with one or more relationships); for example “person.name” or “person.address.street”
   
   - returns: The value for the derived property identified by keyPath.
   */
  public func valueForKeyPath(_ keyPath : String) -> Any? {
    let keys = keyPath.components(separatedBy: ".")
    
    guard keys.count > 0 else {
      return nil
    }
    
    var mirror = Mirror(reflecting: self)
    
    for key in keys {
//      var keyFound = false
      
      for child in mirror.children {
        if key == child.label {
//          keyFound = true
          
          if child.label == keys.last {
            return child.value
          } else {
            mirror = Mirror(reflecting: unwrap(child.value))
            break
          }
        }
      }
      
//      if !keyFound {
//        fatalError("KeyPath: \(keyPath) is not valid for key: \(key)")
//      }
    }

    return nil
  }
  
  /**
   Attempts to unwrap an optional type, so we can use reflect on it in valueForKeyPath:
   
   - parameter any: The type to unwrap
   
   - returns: The unwrapped type
   */
  private func unwrap(_ any: Any) -> Any {
    let mirror = Mirror(reflecting: any)
    if mirror.displayStyle != .optional {
      return any
    }
    
    if mirror.children.count == 0 { return NSNull() }
    let (_, some) = mirror.children.first!
    return some
    
  }
  
}
