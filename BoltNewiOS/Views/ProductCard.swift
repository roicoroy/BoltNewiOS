//
//  ProductCard.swift
//  BoltNewiOS
//
//  Created by Ricardo Bento on 24/06/2025.
//

import SwiftUI

struct ProductCard: View {
    let product: Product
    @State private var imageLoaded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Product Image
            AsyncImage(url: URL(string: product.imageURL)) { image in
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
                Text(product.name)
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
                    Text("$\(String(format: "%.2f", product.price))")
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
    ProductCard(product: Product(
        name: "iPhone 15 Pro",
        price: 999.99,
        description: "The most advanced iPhone yet",
        category: "Electronics",
        imageURL: "https://images.pexels.com/photos/788946/pexels-photo-788946.jpeg",
        rating: 4.8,
        reviewCount: 1247
    ))
    .padding()
    .frame(width: 180)
}