//
//  MedusaProductDetailView.swift
//  BoltNewiOS
//
//  Created by Ricardo Bento on 24/06/2025.
//

import SwiftUI

struct MedusaProductDetailView: View {
    let product: MedusaProduct
    @Environment(\.dismiss) private var dismiss
    @State private var selectedImageIndex = 0
    @State private var showingFullDescription = false
    @State private var quantity = 1
    @State private var selectedVariant: ProductVariant?
    @State private var selectedOptions: [String: String] = [:]
    
    private var productImages: [String] {
        product.allImages.isEmpty ? [product.primaryImage] : product.allImages
    }
    
    private var availableVariants: [ProductVariant] {
        if selectedOptions.isEmpty {
            return product.variants
        }
        
        return product.variants.filter { variant in
            selectedOptions.allSatisfy { optionTitle, selectedValue in
                variant.options.contains { variantOption in
                    variantOption.option.title == optionTitle && variantOption.value == selectedValue
                }
            }
        }
    }
    
    private var currentVariant: ProductVariant? {
        return selectedVariant ?? availableVariants.first
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
                        Text(product.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(nil)
                        
                        // Subtitle if available
                        if let subtitle = product.subtitle {
                            Text(subtitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
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
                            Text("$\(String(format: "%.2f", product.basePrice))")
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
                        
                        // SKU if available
                        if let sku = currentVariant?.sku {
                            Text("SKU: \(sku)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Divider()
                    
                    // Product Options
                    if !product.options.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Options")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            ForEach(product.options) { option in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(option.title)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 8) {
                                            ForEach(option.values) { value in
                                                Button(action: {
                                                    selectedOptions[option.title] = value.value
                                                    updateSelectedVariant()
                                                }) {
                                                    Text(value.value)
                                                        .font(.subheadline)
                                                        .fontWeight(.medium)
                                                        .padding(.horizontal, 12)
                                                        .padding(.vertical, 8)
                                                        .background(
                                                            selectedOptions[option.title] == value.value ? 
                                                            Color.blue : Color(.systemGray6)
                                                        )
                                                        .foregroundColor(
                                                            selectedOptions[option.title] == value.value ? 
                                                            .white : .primary
                                                        )
                                                        .cornerRadius(8)
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                }
                            }
                        }
                        
                        Divider()
                    }
                    
                    // Description Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Description")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(product.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(showingFullDescription ? nil : 3)
                        
                        if product.description.count > 100 {
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
        .onAppear {
            initializeSelectedOptions()
        }
    }
    
    private func initializeSelectedOptions() {
        // Initialize with first available option for each product option
        for option in product.options {
            if let firstValue = option.values.first {
                selectedOptions[option.title] = firstValue.value
            }
        }
        updateSelectedVariant()
    }
    
    private func updateSelectedVariant() {
        selectedVariant = availableVariants.first
    }
}

#Preview {
    NavigationStack {
        MedusaProductDetailView(product: MedusaProduct(
            id: "prod_01JYTRJ9389X398ZWSVVFCF40Y",
            title: "Medusa Sweatshirt",
            subtitle: "Premium Cotton Blend",
            description: "Reimagine the feeling of a classic sweatshirt. With our cotton sweatshirt, everyday essentials no longer have to be ordinary. This premium piece combines comfort with style, featuring a modern fit and exceptional quality materials.",
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
    }
}