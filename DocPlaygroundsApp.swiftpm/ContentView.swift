import SwiftUI

struct ContentView: View {
    typealias Item = Checklist.Item
    
    @Binding var document: ChecklistDocument
    
    @State private var editingItemID: Item.ID?
    @FocusState private var editingFieldFocused
    
    var body: some View {
        NavigationView { itemList }
    }
    
    private var sortedItems: [Binding<Item>] {
        $document.checklist.items.sorted(by: { a, b in b.wrappedValue.isDone })
    }
    
    private var itemList: some View {
        List(sortedItems) { $item in
            itemRowView(for: $item)
                .swipeActions(edge: .trailing) { 
                    Button(role: .destructive) {
                        withAnimation { document.delete(item) }
                    } label: {
                        Text("Delete")
                    }
                }
                .swipeActions(edge: .leading) { 
                    Button {
                        withAnimation { item.isDone.toggle() }
                    } label: {
                        if item.isDone {
                            Text("Undone")
                        } else {
                            Text("Done")
                        }
                    }
                    .tint(.accentColor)
                }
                .accessibilityRepresentation {
                    Toggle(item.title, isOn: $item.isDone)
                        .accessibilityHint(
                            item.isDone ? "Mark \"\(item.title)\" as undone" : "Mark \"\(item.title)\" as done"
                        )
                }
        }
        .toolbar { toolbarContents }
        .navigationTitle(document.title)
    }
    
    private func itemRowView(for item: Binding<Item>) -> some View {
        Group {
            HStack {
                checkbox(for: item)
                
                if editingItemID == item.id {
                    TextField("Item", text: item.title, onCommit: {
                        editingItemID = nil
                    })
                        .focused($editingFieldFocused)
                } else {
                    Text(item.wrappedValue.formattedTitle)
                        .onTapGesture {
                            editingItemID = item.id
                        }
                        .foregroundColor(item.wrappedValue.isDone ? .secondary : .primary)
                }
            }
        }
        .onChange(of: editingItemID) { newValue in
            editingFieldFocused = newValue != nil
        }
    }
    
    private func checkbox(for item: Binding<Item>) -> some View {
        Group {
            if item.wrappedValue.isDone {
                Image(systemName: "checkmark.square")
            } else {
                Image(systemName: "square")
            }
        }
        .foregroundColor(.accentColor)
        .onTapGesture {
            withAnimation {
                item.wrappedValue.isDone.toggle()
            }
        }
    }
    
    private var toolbarContents: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button {
                let newItem = Item(id: .init(), title: "", isDone: false)
                document.checklist.items.append(newItem)
                editingItemID = newItem.id
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

extension Checklist.Item {
    var formattedTitle: AttributedString {
        if isDone {
            return (try? AttributedString(markdown: "~~\(title)~~"))
            ?? AttributedString(title)
        } else {
            return AttributedString(title)
        }
    }
}
