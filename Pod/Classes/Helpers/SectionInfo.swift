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

import CoreData

/**
 *  An instance conforming to this protocol, can provide sectioning info to a DataProvider
 */
public protocol SectionInfo: Hashable {
  
  /// The underlying items data type
  associatedtype DataType
  
  /* Name of the section
  */
  var name: String { get }
  
  /* Title of the section (used when displaying the index)
  */
  var indexTitle: String? { get }
  
  /* Number of objects in section
  */
  var numberOfItems: Int { get }
  
  /* Returns the items associated with this section
  */
  var items: [DataType] { get }
  
  /**
   Initializes this sectio with the specified title
   
   - parameter name: The name associated with this section
   
   - returns: A newly configured section
   */
  init(name: String)
  
}

/// A default implementation of SectionInfo
public final class DataProviderSectionInfo<T: DataProviderSupported>: SectionInfo {
  
  /// The underlying items data type
  public typealias DataType = T
  
  /* Name of the section
   */
  public internal(set) var name: String
  
  /* Title of the section (used when displaying the index)
   */
  public internal(set) var indexTitle: String?
  
  /* Number of objects in section
   */
  public var numberOfItems: Int {
    return items.count
  }
  
  /* Returns the items associated with this section
   */
  public internal(set) var items = [DataType]()
  
  /**
   Initializes this sectio with the specified title
   
   - parameter name: The name associated with this section
   
   - returns: A newly configured section
   */
  public required init(name: String) {
    self.name = name
  }
  
  /// The Hashable requirement
  public var hashValue: Int {
    return name.hash
  }
  
}

/**
 Returns true if lhs.name == rhs.name
 
 - parameter lhs: The first section
 - parameter rhs: The second section
 
 - returns: True if lhs.name == rhs.name
 */
public func ==<T>(lhs: DataProviderSectionInfo<T>, rhs: DataProviderSectionInfo<T>) -> Bool {
  return lhs.name == rhs.name
}

extension Array where Element: SectionInfo {

  /**
   Returns true, if the the array contains the specified element, false otherwise
   
   - parameter element: The element to query
   
   - returns: True, if the array contains the element, false otherwise
   */
  func contains(element: Element) -> Bool {
    if let _ = indexOf(element) {
      return true
    }
    
    return false
  }
  
}