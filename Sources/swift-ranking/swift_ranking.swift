
public protocol Rankable: Equatable {
  var rank: Int { get set }
}

public enum Ranking {
      
  public static func insert<
    Collection: RandomAccessCollection & RangeReplaceableCollection & MutableCollection
  >(
    element: Collection.Element,
    at index: Collection.Index,
    in collection: inout Collection
  ) where Collection.Element : Rankable, Collection.Index == Int {
    
    collection.sort { $0.rank < $1.rank }  
    
    uncheckedInsert(
      element: element,
      at: index,
      in: &collection
    )    
    
  } 
  
  public static func remove<
    Collection: RandomAccessCollection & RangeReplaceableCollection & MutableCollection
  >(  
    at index: Collection.Index,
    in collection: inout Collection
  ) -> Collection.Element where Collection.Element : Rankable, Collection.Index == Int {
    
    collection.sort { $0.rank < $1.rank }
    
    return uncheckedRemove(
      at: index,
      in: &collection
    )
  
  }
  
  public static func uncheckedMove<
    Collection: RangeReplaceableCollection & MutableCollection
  >(
    from fromIndex: Collection.Index,
    to toIndex: Collection.Index,
    in collection: inout Collection
  ) where Collection.Index == Int, Collection.Element : Rankable {
    
    let element = uncheckedRemove(at: fromIndex, in: &collection)
    uncheckedInsert(element: element, at: toIndex, in: &collection)
    
  }
  
  public static func uncheckedInsert<
    Collection: RangeReplaceableCollection & MutableCollection
  >(
    element: consuming Collection.Element,
    at index: Collection.Index,
    in collection: inout Collection
  ) where Collection.Index == Int, Collection.Element : Rankable {
    
    var from = Int.min / 2
    var to = Int.max / 2
    
    if index > 0 {
      from = collection[index.advanced(by: -1)].rank.advanced(by: 1)
    }
    if index < collection.count {
      to = collection[index].rank
    }
    
    guard from < to else {
      collection.insert(element, at: index)
      rank_balancing(collection: &collection)
      return
    }
    
    var modified = consume element
    let range: Range<Int> = from ..< to
    modified.rank = range.randomElement()!
    
    collection.insert(modified, at: index)
  } 
  
  public static func uncheckedRemove<
    Collection: RangeReplaceableCollection
  >(
    at index: Collection.Index,
    in collection: inout Collection
  ) -> Collection.Element where Collection.Index == Int, Collection.Element : Rankable {  
    return collection.remove(at: index)  
  } 
  
  public static func rank_balancing<Collection: MutableCollection>(collection: inout Collection) where Collection.Element: Rankable, Collection.Index == Int {
    
    let indices = collection.indices
    
    guard collection.isEmpty == false else {
      return
    }
    
    if collection.count == 1 {
      collection[0].rank = 0
      return
    }
    
    // balancing
    
    let count = collection.count    
    
    let offset = Int.min / 2
    let portion = Int.max / (count - 1)
    
    for index in indices {
      collection[index].rank = offset + portion * index
    }
  }
}

//
//public func rank<Collection: RandomAccessCollection>(
//  newCollection: Collection,
//  oldCollection: Collection
//) where Collection.Element : Rankable {
//  
//  var oldOrder = oldCollection.sorted { $0.rank < $1.rank }
//  
//  let newOrder = newCollection.map({ newValueItem in
//    oldOrder.first {
//      $0 == newValueItem
//    } ?? newValueItem
//  })
//  
//  let differences = newOrder.difference(from: oldOrder)
//  
//  func completelyRearrangeArray() {
//    let count = newOrder.count
//    switch count {
//    case 0:
//      return
//    case 1:
//      newOrder[0].rank = 0
//      return
//    default:
//      break
//    }
//    
//    let offset = Int.min / 2
//    let portion = Int.max / (count - 1)
//    
//    for index in 0 ..< count {
//      newOrder[index].rank = offset + portion * index
//    }
//  }
//  
//  for difference in differences {
//    switch difference {
//    case .remove(let offset, let element, _):
//      if !newOrder.contains(element) {
//        modelContext.delete(element)
//      }
//      oldOrder.remove(at: offset)
//    case .insert(let offset, let element, _):
//      if oldOrder.isEmpty {
//        element.rank = 0
//        oldOrder.insert(element, at: offset)
//        continue
//      }
//      
//      var from = Int.min / 2
//      var to = Int.max / 2
//      
//      if offset > 0 {
//        from = oldOrder[offset - 1].order + 1
//      }
//      if offset < oldOrder.count {
//        to = oldOrder[offset].rank
//      }
//      
//      guard from < to else {
//        completelyRearrangeArray()
//        return
//      }
//      
//      let range: Range<Int> = from ..< to
//      element.rank = range.randomElement()!
//      
//      oldOrder.insert(element, at: offset)
//    }
//  }
//  
//}
