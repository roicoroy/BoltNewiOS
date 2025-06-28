//
//  GlassMedusaProductDetailView.swift
//  BoltNewiOS
//
//  Created by Ricardo Bento on 24/06/2025.
//

import SwiftUI

struct GlassMedusaProductDetailView: View {
    let product: MedusaProduct
    @Environment(\.dismiss) private var dismiss
    @State private var selectedImageIndex = 0
    @State private var showingFullDescription = false
    @State private var quantity = 1
    @State private var selectedVariant: ProductVariant?
    @State private var selectedOptions: [String: String] = [:]
    @State private var isFavorite = false
    
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
        ZStack {
            GlassBackground()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                GlassNavigationBar(
                    title: "",
                    leadingIcon: "chevron.left",
                    trailingIcon: isFavorite ? "heart.fill" : "heart",
                    leadingAction: { dismiss() },
                    trailingAction: { 
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            isFavorite.toggle()
                        }
                    }
                )
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Image Gallery
                        GlassCard(cornerRadius: 24) {
                            TabView(selection: $selectedImageIndex) {
                                ForEach(0..<productImages.count, id: \.self) { index in
                                    AsyncImage(url: URL(string: productImages[index])) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 320)
                                            .clipped()
                                    } placeholder: {
                                        GlassDetailImagePlaceholder(height: 320)
                                    }
                                    .tag(index)
                                }
                            }
                            .frame(height: 320)
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        }
                        .padding(.horizontal, 20)
                        
                        // Product Details
                        GlassCard(cornerRadius: 20) {
                            VStack(alignment: .leading, spacing: 20) {
                                // Header Section
                                VStack(alignment: .leading, spacing: 12) {
                                    // Category Badge
                                    HStack {
                                        Text(product.category.uppercased())
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.blue)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                Capsule()
                                                    .fill(.blue.opacity(0.15))
                                                    .overlay(
                                                        Capsule()
                                                            .stroke(.blue.opacity(0.3), lineWidth: 1)
                                                    )
                                            )
                                        
                                        Spacer()
                                        
                                        // Stock Status
                                        HStack(spacing: 6) {
                                            Circle()
                                                .fill(product.isInStock ? .green : .red)
                                                .frame(width: 8, height: 8)
                                            
                                            Text(product.isInStock ? "In Stock" : "Out of Stock")
                                                .font(.caption)
                                                .fontWeight(.medium)
                                                .foregroundColor(product.isInStock ? .green : .red)
                                        }
                                    }
                                    
                                    // Product Name
                                    Text(product.title)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    
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
                                    
                                    // Price
                                    Text("$\(String(format: "%.2f", product.basePrice))")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    
                                    // SKU if available
                                    if let sku = currentVariant?.sku {
                                        Text("SKU: \(sku)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Divider()
                                    .background(.ultraThinMaterial)
                                
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
                                                            GlassButton(
                                                                title: value.value,
                                                                isSelected: selectedOptions[option.title] == value.value
                                                            ) {
                                                                selectedOptions[option.title] = value.value
                                                                updateSelectedVariant()
                                                            }
                                                        }
                                                    }
                                                    .padding(.horizontal, 20)
                                                }
                                            }
                                        }
                                    }
                                    
                                    Divider()
                                        .background(.ultraThinMaterial)
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
                                        GlassButton(
                                            title: showingFullDescription ? "Show Less" : "Read More",
                                            icon: showingFullDescription ? "chevron.up" : "chevron.down"
                                        ) {
                                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                                showingFullDescription.toggle()
                                            }
                                        }
                                    }
                                }
                                
                                Divider()
                                    .background(.ultraThinMaterial)
                                
                                // Quantity Selector
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Quantity")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    
                                    HStack(spacing: 16) {
                                        Button(action: {
                                            if quantity > 1 {
                                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                                    quantity -= 1
                                                }
                                            }
                                        }) {
                                            Image(systemName: "minus")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.primary)
                                                .frame(width: 40, height: 40)
                                                .background(.ultraThinMaterial)
                                                .cornerRadius(12)
                                        }
                                        .disabled(quantity <= 1)
                                        
                                        Text("\(quantity)")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .frame(minWidth: 40)
                                        
                                        Button(action: {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                                quantity += 1
                                            }
                                        }) {
                                            Image(systemName: "plus")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.primary)
                                                .frame(width: 40, height: 40)
                                                .background(.ultraThinMaterial)
                                                .cornerRadius(12)
                                        }
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding(24)
                        }
                        .padding(.horizontal, 20)
                        
                        // Bottom spacing for floating buttons
                        Spacer(minLength: 120)
                    }
                    .padding(.top, 20)
                }
            }
            
            // Floating Action Buttons
            VStack {
                Spacer()
                
                GlassCard(cornerRadius: 20) {
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
                            .background(.blue.opacity(0.1))
                            .cornerRadius(16)
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
                            .background(
                                product.isInStock ? 
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ) :
                                LinearGradient(
                                    colors: [.gray],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(16)
                        }
                        .disabled(!product.isInStock)
                    }
                    .padding(16)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 34)
            }
        }
        .navigationBarHidden(true)
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

struct GlassDetailImagePlaceholder: View {
    let height: CGFloat
    @State private var isAnimating = false
    @State private var shimmerOffset: CGFloat = -300
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Base gradient background with depth
            LinearGradient(
                colors: [
                    Color(.systemGray6).opacity(0.9),
                    Color(.systemGray5).opacity(0.7),
                    Color(.systemGray4).opacity(0.5),
                    Color(.systemGray5).opacity(0.7),
                    Color(.systemGray6).opacity(0.9)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: height)
            
            // Animated shimmer effect
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            .clear,
                            .white.opacity(0.6),
                            .white.opacity(0.8),
                            .white.opacity(0.6),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: height)
                .offset(x: shimmerOffset)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: false)) {
                        shimmerOffset = 300
                    }
                }
            
            // Glass overlay with subtle animation
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.4)
                .frame(height: height)
                .scaleEffect(pulseScale)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                        pulseScale = 1.02
                    }
                }
            
            // Enhanced loading indicator
            VStack(spacing: 16) {
                // Circular progress indicator
                ZStack {
                    Circle()
                        .stroke(.white.opacity(0.3), lineWidth: 3)
                        .frame(width: 40, height: 40)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.9), .blue.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round)
                        )
                        .frame(width: 40, height: 40)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: isAnimating)
                }
                
                // Loading text with fade animation
                Text("Loading image...")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.9))
                    .opacity(isAnimating ? 0.6 : 1.0)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
                
                // Animated dots
                HStack(spacing: 6) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(.white.opacity(0.8))
                            .frame(width: 6, height: 6)
                            .scaleEffect(isAnimating ? 1.3 : 0.7)
                            .animation(
                                .easeInOut(duration: 0.8)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
            }
            .onAppear {
                isAnimating = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        GlassMedusaProductDetailView(product: MedusaProduct(
            id: "prod_01JYTRJ9389X398ZWSVVFCF40Y",
            title: "Medusa Sweatshirt",
            subtitle: "Premium Cotton Blend",
            description: "Reimagine the feeling of a classic sweatshirt. With our cotton sweatshirt, everyday essentials no longer have to be ordinary. This premium piece combines comfort with style, featuring a modern fit and exceptional quality materials that will keep you comfortable all day long.",
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