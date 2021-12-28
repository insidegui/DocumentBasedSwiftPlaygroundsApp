//
//  File.swift
//  DocPlaygroundsApp
//
//  Created by Guilherme Rambo on 28/12/21.
//

import Foundation

struct Checklist: Identifiable, Hashable, Codable {
    struct Item: Identifiable, Hashable, Codable {
        let id: UUID
        var title: String
        var isDone: Bool
    }
    
    let id: UUID
    var items: [Item]
}
