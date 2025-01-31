//
//  Location.swift
//  BucketList
//
//  Created by Danut Popa on 31.01.2025.
//

import Foundation

struct Location: Codable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
}
