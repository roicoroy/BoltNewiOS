//
//  MedusaProductCard.swift
//  BoltNewiOS
//
//  Created by Ricardo Bento on 24/06/2025.
//

import SwiftUI

struct MedusaProductCard: View {
    let product: MedusaProduct
    @State private var imageLoaded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Product Image
            AsyncImage(url: URL(string: product.primaryImage)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 140)
                    .clipped()
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.3)) {
                            imageLoaded = true
                        }
                    }
            } placeholder: {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(height: 140)
                    .overlay(
                        ProgressView()
                            .scaleEffect(0.8)
                    )
            }
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                // Product Name
                Text(product.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Rating
                HStack(spacing: 4) {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text(String(format: "%.1f", product.rating))
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    
                    Text("(\(product.reviewCount))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                
                // Price and Stock Status
                HStack {
                    Text("$\(String(format: "%.2f", product.basePrice))")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if product.isInStock {
                        Text("In Stock")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.green)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(4)
                    } else {
                        Text("Out of Stock")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.red)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
                
                // Category
                Text(product.category.uppercased())
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        .scaleEffect(imageLoaded ? 1.0 : 0.95)
        .opacity(imageLoaded ? 1.0 : 0.8)
    }
}

#Preview {
    MedusaProductCard(product: MedusaProduct(
        id: "prod_01JYTRJ9389X398ZWSVVFCF40Y",
        title: "Medusa Sweatshirt",
        subtitle: nil,
        description: "Reimagine the feeling of a classic sweatshirt. With our cotton sweatshirt, everyday essentials no longer have to be ordinary.",
        handle: "sweatshirt",
        isGiftcard: false,
        discountable: true,
        thumbnail: "https://medusa-public-images.s3.eu-west-1.amazonaws.com/sweatshirt-vintage-front.png",
        collectionId: nil,
        typeId: nil,
        weight: "400",
        length: nil,
        height: nil,
        width: nil,
        hsCode: nil,
        originCountry: nil,
        midCode: nil,
        material: nil,
        createdAt: "2025-06-28T07:55:53.313Z",
        updatedAt: "2025-06-28T07:55:53.313Z",
        type: nil,
        collection: nil,
        options: [],
        tags: [],
        images: [],
        variants: []
    ))
    .padding()
    .frame(width: 180)
}