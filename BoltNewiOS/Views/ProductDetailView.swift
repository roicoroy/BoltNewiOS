//
//  ProductDetailView.swift
//  BoltNewiOS
//
//  Created by Ricardo Bento on 24/06/2025.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @Environment(\.dismiss) private var dismiss
    @State private var selectedImageIndex = 0
    @State private var showingFullDescription = false
    @State private var quantity = 1
    
    // Sample additional images for demo
    private var productImages: [String] {
        [product.imageURL, product.imageURL, product.imageURL]
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Image Gallery
                TabView(selection: $selectedImageIndex) {
                    ForEach(0..<productImages.count, id: \.self) { index in
                        AsyncImage(url: URL(string: productImages[index])) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 300)
                                .clipped()
                        } placeholder: {
                            Rectangle()
                                .fill(Color(.systemGray5))
                                .frame(height: 300)
                                .overlay(
                                    ProgressView()
                                        .scaleEffect(1.2)
                                )
                        }
                        .tag(index)
                    }
                }
                .frame(height: 300)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                
                // Product Details
                VStack(alignment: .leading, spacing: 20) {
                    // Header Section
                    VStack(alignment: .leading, spacing: 12) {
                        // Category
                        Text(product.category.uppercased())
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        
                        // Product Name
                        Text(product.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(nil)
                        
                        // Rating and Reviews
                        HStack(spacing: 12) {
                            HStack(spacing: 4) {
                                ForEach(0..<5) { index in
                                    Image(systemName: index < Int(product.rating) ? "star.fill" : "star")
                                        .font(.subheadline)
                                        .foregroundColor(.orange)
                                }
                                Text(String(format: "%.1f", product.rating))
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            
                            Text("•")
                                .foregroundColor(.secondary)
                            
                            Text("\(product.reviewCount) reviews")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                        
                        // Price and Stock
                        HStack {
                            Text("$\(String(format: "%.2f", product.price))")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(product.isInStock ? Color.green : Color.red)
                                    .frame(width: 8, height: 8)
                                
                                Text(product.isInStock ? "In Stock" : "Out of Stock")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(product.isInStock ? .green : .red)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Description Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Description")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(product.productDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(showingFullDescription ? nil : 3)
                        
                        if product.productDescription.count > 100 {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showingFullDescription.toggle()
                                }
                            }) {
                                Text(showingFullDescription ? "Show Less" : "Read More")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Quantity Selector
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Quantity")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                if quantity > 1 {
                                    withAnimation(.easeInOut(duration: 0.1)) {
                                        quantity -= 1
                                    }
                                }
                            }) {
                                Image(systemName: "minus")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .frame(width: 32, height: 32)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                            .disabled(quantity <= 1)
                            
                            Text("\(quantity)")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .frame(minWidth: 30)
                            
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    quantity += 1
                                }
                            }) {
                                Image(systemName: "plus")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .frame(width: 32, height: 32)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                            
                            Spacer()
                        }
                    }
                    
                    // Spacer for bottom buttons
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                        .background(Color(.systemBackground).opacity(0.8))
                        .cornerRadius(8)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "heart")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                        .background(Color(.systemBackground).opacity(0.8))
                        .cornerRadius(8)
                }
            }
        }
        .overlay(alignment: .bottom) {
            // Bottom Action Buttons
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "cart")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("Add to Cart")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .disabled(!product.isInStock)
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "bolt.fill")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("Buy Now")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(product.isInStock ? Color.blue : Color.gray)
                        .cornerRadius(12)
                    }
                    .disabled(!product.isInStock)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 34)
            .background(
                LinearGradient(
                    colors: [Color(.systemBackground).opacity(0), Color(.systemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 100)
            )
        }
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: Product(
            name: "iPhone 15 Pro Max",
            price: 1199.99,
            description: "The most advanced iPhone yet with titanium design, A17 Pro chip, and revolutionary camera system. Experience the future of mobile technology with unprecedented performance and stunning photography capabilities.",
            category: "Electronics",
            imageURL: "https://images.pexels.com/photos/788946/pexels-photo-788946.jpeg",
            rating: 4.8,
            reviewCount: 1247
        ))
    }
}