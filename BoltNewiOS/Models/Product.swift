//
//  Product.swift
//  BoltNewiOS
//
//  Created by Ricardo Bento on 24/06/2025.
//

import Foundation
import SwiftData

@Model
final class Product {
    var id: UUID
    var name: String
    var price: Double
    var productDescription: String
    var category: String
    var imageURL: String
    var rating: Double
    var reviewCount: Int
    var isInStock: Bool
    var createdAt: Date
    
    init(name: String, price: Double, description: String, category: String, imageURL: String, rating: Double = 4.5, reviewCount: Int = 0, isInStock: Bool = true) {
        self.id = UUID()
        self.name = name
        self.price = price
        self.productDescription = description
        self.category = category
        self.imageURL = imageURL
        self.rating = rating
        self.reviewCount = reviewCount
        self.isInStock = isInStock
        self.createdAt = Date()
    }
}