//
//  File.swift
//  DocPlaygroundsApp
//
//  Created by Guilherme Rambo on 28/12/21.
//

import Foundation
import UniformTypeIdentifiers
import SwiftUI

extension UTType {
    static let checklistDocument = UTType(
        exportedAs: "codes.rambo.sampleCode.ChecklistDocument",
        conformingTo: .json
    )
}

struct ChecklistDocument: FileDocument {
    
    let title: String
    var checklist: Checklist
    
    static var readableContentTypes: [UTType] = [.checklistDocument]
    
    init() {
        self.title = "Untitled"
        self.checklist = Checklist(id: .init(), items: [])
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        self.title = configuration.file.nameWithoutExtension
        self.checklist = try JSONDecoder().decode(Checklist.self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(checklist)
        let wrapper = FileWrapper(regularFileWithContents: data)
        return wrapper
    }
    
    mutating func delete(_ item: Checklist.Item) {
        guard let index = checklist.items.firstIndex(of: item) else {
            return
        }
        
        checklist.items.remove(at: index)
    }

}

extension FileWrapper {
    var nameWithoutExtension: String {
        guard let filename = filename else { return "Untitled" }
        
        // Dummy URL just to strip the file extension from the name
        // in a "correct" way.
        return URL(fileURLWithPath: "/")
            .appendingPathComponent(filename)
            .deletingPathExtension()
            .lastPathComponent
    }
}
