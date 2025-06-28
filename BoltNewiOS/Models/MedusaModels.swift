//
//  MedusaModels.swift
//  BoltNewiOS
//
//  Created by Ricardo Bento on 24/06/2025.
//

import Foundation

// MARK: - Medusa API Response Models

struct MedusaProductsResponse: Codable {
    let products: [MedusaProduct]
    let count: Int
    let offset: Int
    let limit: Int
}

struct MedusaProduct: Codable, Identifiable {
    let id: String
    let title: String
    let subtitle: String?
    let description: String
    let handle: String
    let isGiftcard: Bool
    let discountable: Bool
    let thumbnail: String?
    let collectionId: String?
    let typeId: String?
    let weight: String?
    let length: String?
    let height: String?
    let width: String?
    let hsCode: String?
    let originCountry: String?
    let midCode: String?
    let material: String?
    let createdAt: String
    let updatedAt: String
    let type: ProductType?
    let collection: ProductCollection?
    let options: [ProductOption]
    let tags: [ProductTag]
    let images: [ProductImage]
    let variants: [ProductVariant]
    
    enum CodingKeys: String, CodingKey {
        case id, title, subtitle, description, handle, discountable, thumbnail, weight, length, height, width, material, type, collection, options, tags, images, variants
        case isGiftcard = "is_giftcard"
        case collectionId = "collection_id"
        case typeId = "type_id"
        case hsCode = "hs_code"
        case originCountry = "origin_country"
        case midCode = "mid_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct ProductType: Codable {
    let id: String
    let value: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, value
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct ProductCollection: Codable {
    let id: String
    let title: String
    let handle: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, handle
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct ProductOption: Codable, Identifiable {
    let id: String
    let title: String
    let metadata: [String: String]?
    let productId: String
    let createdAt: String
    let updatedAt: String
    let deletedAt: String?
    let values: [ProductOptionValue]
    
    enum CodingKeys: String, CodingKey {
        case id, title, metadata, values
        case productId = "product_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

struct ProductOptionValue: Codable, Identifiable {
    let id: String
    let value: String
    let metadata: [String: String]?
    let optionId: String
    let createdAt: String
    let updatedAt: String
    let deletedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, value, metadata
        case optionId = "option_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

struct ProductTag: Codable, Identifiable {
    let id: String
    let value: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, value
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct ProductImage: Codable, Identifiable {
    let id: String
    let url: String
    let metadata: [String: String]?
    let rank: Int
    let productId: String
    let createdAt: String
    let updatedAt: String
    let deletedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, url, metadata, rank
        case productId = "product_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

struct ProductVariant: Codable, Identifiable {
    let id: String
    let title: String
    let sku: String?
    let barcode: String?
    let ean: String?
    let upc: String?
    let allowBackorder: Bool
    let manageInventory: Bool
    let hsCode: String?
    let originCountry: String?
    let midCode: String?
    let material: String?
    let weight: String?
    let length: String?
    let height: String?
    let width: String?
    let metadata: [String: String]?
    let variantRank: Int
    let productId: String
    let createdAt: String
    let updatedAt: String
    let deletedAt: String?
    let options: [VariantOption]
    
    enum CodingKeys: String, CodingKey {
        case id, title, sku, barcode, ean, upc, metadata, weight, length, height, width, material, options
        case allowBackorder = "allow_backorder"
        case manageInventory = "manage_inventory"
        case hsCode = "hs_code"
        case originCountry = "origin_country"
        case midCode = "mid_code"
        case variantRank = "variant_rank"
        case productId = "product_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

struct VariantOption: Codable, Identifiable {
    let id: String
    let value: String
    let metadata: [String: String]?
    let optionId: String
    let option: ProductOption
    let createdAt: String
    let updatedAt: String
    let deletedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, value, metadata, option
        case optionId = "option_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}

// MARK: - Helper Extensions

extension MedusaProduct {
    var primaryImage: String {
        return thumbnail ?? images.first?.url ?? ""
    }
    
    var allImages: [String] {
        return images.sorted { $0.rank < $1.rank }.map { $0.url }
    }
    
    var category: String {
        return collection?.title ?? type?.value ?? "General"
    }
    
    var isInStock: Bool {
        return variants.contains { variant in
            variant.manageInventory ? !variant.allowBackorder : true
        }
    }
    
    var basePrice: Double {
        // Since Medusa doesn't include pricing in the basic product endpoint,
        // we'll return a placeholder price. In a real app, you'd need to fetch
        // pricing from a separate endpoint or include it in the product query.
        return 29.99
    }
    
    var rating: Double {
        // Placeholder rating since it's not in the Medusa response
        return Double.random(in: 4.0...5.0)
    }
    
    var reviewCount: Int {
        // Placeholder review count since it's not in the Medusa response
        return Int.random(in: 10...500)
    }
}