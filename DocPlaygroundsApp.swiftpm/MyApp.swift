import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: ChecklistDocument()) { config in
            ContentView(document: config.$document)
        }
    }
}
