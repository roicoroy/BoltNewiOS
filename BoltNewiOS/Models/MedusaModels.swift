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
    let id: String?
    let value: String?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, value
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct ProductCollection: Codable {
    let id: String?
    let title: String?
    let handle: String?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, handle
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct ProductOption: Codable, Identifiable {
    let id: String
    let title: String
    let metadata: AnyCodable?
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        metadata = try container.decodeIfPresent(AnyCodable.self, forKey: .metadata)
        productId = try container.decode(String.self, forKey: .productId)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        deletedAt = try container.decodeIfPresent(String.self, forKey: .deletedAt)
        
        // Handle values array - it might be missing in some cases
        values = try container.decodeIfPresent([ProductOptionValue].self, forKey: .values) ?? []
    }
}

struct ProductOptionValue: Codable, Identifiable {
    let id: String
    let value: String
    let metadata: AnyCodable?
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
    let metadata: AnyCodable?
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
    let metadata: AnyCodable?
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
    let metadata: AnyCodable?
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        value = try container.decode(String.self, forKey: .value)
        metadata = try container.decodeIfPresent(AnyCodable.self, forKey: .metadata)
        optionId = try container.decode(String.self, forKey: .optionId)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        deletedAt = try container.decodeIfPresent(String.self, forKey: .deletedAt)
        
        // Handle nested option - create a simplified version to avoid circular reference
        let optionContainer = try container.nestedContainer(keyedBy: ProductOption.CodingKeys.self, forKey: .option)
        let optionId = try optionContainer.decode(String.self, forKey: .id)
        let optionTitle = try optionContainer.decode(String.self, forKey: .title)
        let optionMetadata = try optionContainer.decodeIfPresent(AnyCodable.self, forKey: .metadata)
        let optionProductId = try optionContainer.decode(String.self, forKey: .productId)
        let optionCreatedAt = try optionContainer.decode(String.self, forKey: .createdAt)
        let optionUpdatedAt = try optionContainer.decode(String.self, forKey: .updatedAt)
        let optionDeletedAt = try optionContainer.decodeIfPresent(String.self, forKey: .deletedAt)
        
        // Create option without values to avoid circular reference
        option = ProductOption(
            id: optionId,
            title: optionTitle,
            metadata: optionMetadata,
            productId: optionProductId,
            createdAt: optionCreatedAt,
            updatedAt: optionUpdatedAt,
            deletedAt: optionDeletedAt,
            values: [] // Empty to avoid circular reference
        )
    }
}

// Add custom initializer for ProductOption to handle manual creation
extension ProductOption {
    init(id: String, title: String, metadata: AnyCodable?, productId: String, createdAt: String, updatedAt: String, deletedAt: String?, values: [ProductOptionValue]) {
        self.id = id
        self.title = title
        self.metadata = metadata
        self.productId = productId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
        self.values = values
    }
}

// MARK: - Helper for handling dynamic metadata
struct AnyCodable: Codable {
    let value: Any
    
    init<T>(_ value: T?) {
        self.value = value ?? ()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self.value = ()
        } else if let bool = try? container.decode(Bool.self) {
            self.value = bool
        } else if let int = try? container.decode(Int.self) {
            self.value = int
        } else if let double = try? container.decode(Double.self) {
            self.value = double
        } else if let string = try? container.decode(String.self) {
            self.value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            self.value = array.map { $0.value }
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            self.value = dictionary.mapValues { $0.value }
        } else {
            self.value = ()
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch value {
        case is Void:
            try container.encodeNil()
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            let anyArray = array.map { AnyCodable($0) }
            try container.encode(anyArray)
        case let dictionary as [String: Any]:
            let anyDict = dictionary.mapValues { AnyCodable($0) }
            try container.encode(anyDict)
        default:
            try container.encodeNil()
        }
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