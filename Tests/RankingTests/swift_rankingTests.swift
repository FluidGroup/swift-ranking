import Testing
@testable import Ranking

struct Item: Rankable {
  var rank: Int = 0
  var value: String
}

@Test func example() async throws {
  
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
}

@Test func rebalance() {
  var source = [Item(rank: 0, value: "0"), Item(rank: 1, value: "1"), Item(rank: 2, value: "2")]
  
  Ranking.insert(element: Item(value: "A"), at: 1, in: &source)
  
  #expect(source.map(\.value) == ["0", "A", "1", "2"])
}
