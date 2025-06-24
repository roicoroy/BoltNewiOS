//
//  Item.swift
//  BoltNewiOS
//
//  Created by Ricardo Bento on 24/06/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
