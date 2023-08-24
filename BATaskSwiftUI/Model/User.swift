//
//  User.swift
//  BATaskSwiftUI
//
//  Created by Tomas Sungaila on 8/24/23.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
}
