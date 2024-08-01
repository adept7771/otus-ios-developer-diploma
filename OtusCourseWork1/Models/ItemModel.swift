import Foundation

struct Item {
    let id: Int
    let name: String
    let description: String
}

class ItemModel {
    func fetchItems() -> [Item] {
        return [
            Item(id: 1, name: "Item 1", description: "Description for Item 1"),
            Item(id: 2, name: "Item 2", description: "Description for Item 2"),
            Item(id: 3, name: "Item 3", description: "Description for Item 3")
        ]
    }
}
