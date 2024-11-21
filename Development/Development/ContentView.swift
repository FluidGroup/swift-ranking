//
//  ContentView.swift
//  Development
//
//  Created by Muukii on 2024/11/21.
//

import SwiftUI
import Ranking

struct ContentView: View {
  var body: some View {
    Book()
  }
}

#Preview {
  ContentView()
}

#if DEBUG

  private struct Item: Rankable, Identifiable {

    var id: String = UUID().uuidString
    var name: String
    var rank: Int

  }

  private struct Book: View {

    @State var items: [Item] = []
    @State var count: Int = 0

    var body: some View {
      NavigationView {
        VStack {
          HStack {
            List {
              ForEach(items) { item in
                HStack {
                  Text("\(item.rank)")
                  Text(item.name)
                }
              }
              .onMove { set, index in
                print(set, index)
                Ranking.uncheckedMove(from: set.first!, to: index, in: &items)
              }
              .onDelete { set in
                print(set)
                Ranking.remove(at: set.first!, in: &items)
              }

            }
            .environment(\.editMode, .constant(.active))
          }
          Button("Add") {
            let number = count
            count += 1
            Ranking.insert(element: .init(name: "\(number)", rank: 0), at: 0, in: &items)
          }
          
          Button("Append") {
            let number = count
            count += 1
            Ranking.append(element: .init(name: "\(count)", rank: 0), in: &items)
          }
          
        }
        .onAppear {

        }

      }

    }

  }

  import SwiftUI
  @available(iOS 17, *)
  #Preview {
    Book()
  }

  #Preview {
    DemoContentView()
  }

  struct DemoContentView: View {

    @State private var numbers: [Int] = [1, 2, 3, 4, 5]

    var body: some View {

      VStack {

        List {
          ForEach(numbers, id: \.self) { number in
            Text(String(number))
          }
          .onMove(perform: moveRow)
          .onDelete(perform: removeRow)
        }

        EditButton()
          .padding()
      }
    }

    private func moveRow(from source: IndexSet, to destination: Int) {
      numbers.move(fromOffsets: source, toOffset: destination)   
    }    

    private func removeRow(from source: IndexSet) {
      numbers.remove(atOffsets: source)
    }
  }

#endif
