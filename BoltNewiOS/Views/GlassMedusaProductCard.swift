//
//  GlassMedusaProductCard.swift
//  BoltNewiOS
//
//  Created by Ricardo Bento on 24/06/2025.
//

import SwiftUI

struct GlassMedusaProductCard: View {
    let product: MedusaProduct
    @State private var imageLoaded = false
    
    var body: some View {
        GlassCard(cornerRadius: 20, shadowRadius: 15) {
            VStack(alignment: .leading, spacing: 0) {
                // Product Image with Glass Overlay
                ZStack {
                    AsyncImage(url: URL(string: product.primaryImage)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 160)
                            .clipped()
                            .onAppear {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    imageLoaded = true
                                }
                            }
                    } placeholder: {
                        GlassImagePlaceholder(height: 160)
                    }
                    
                    // Glass overlay for image
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .opacity(0.1)
                    
                    // Stock status badge
                    VStack {
                        HStack {
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(product.isInStock ? .green : .red)
                                    .frame(width: 6, height: 6)
                                
                                Text(product.isInStock ? "In Stock" : "Out")
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(product.isInStock ? .green : .red)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .padding(.top, 12)
                            .padding(.trailing, 12)
                        }
                        
                        Spacer()
                    }
                }
                .cornerRadius(16, corners: [.topLeft, .topRight])
                
                // Product Details
                VStack(alignment: .leading, spacing: 12) {
                    // Category Badge
                    HStack {
                        Text(product.category.uppercased())
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                Capsule()
                                    .fill(.blue.opacity(0.15))
                                    .overlay(
                                        Capsule()
                                            .stroke(.blue.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        
                        Spacer()
                    }
                    
                    // Product Name
                    Text(product.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.primary)
                    
                    // Rating and Reviews
                    HStack(spacing: 6) {
                        HStack(spacing: 2) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(product.rating) ? "star.fill" : "star")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }
                        }
                        
                        Text("(\(product.reviewCount))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    
                    // Price
                    HStack {
                        Text("$\(String(format: "%.2f", product.basePrice))")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        // Add to cart button
                        Button(action: {
                            // Add to cart action
                            print("Added \(product.title) to cart")
                        }) {
                            Image(systemName: "plus")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                                .background(
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [.blue, .purple],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                )
                        }
                        .disabled(!product.isInStock)
                        .opacity(product.isInStock ? 1.0 : 0.5)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
        }
        .scaleEffect(imageLoaded ? 1.0 : 0.9)
        .opacity(imageLoaded ? 1.0 : 0.7)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: imageLoaded)
    }
}

struct GlassImagePlaceholder: View {
    let height: CGFloat
    @State private var isAnimating = false
    @State private var shimmerOffset: CGFloat = -200
    
    var body: some View {
        ZStack {
            // Base gradient background
            LinearGradient(
                colors: [
                    Color(.systemGray6).opacity(0.8),
                    Color(.systemGray5).opacity(0.6),
                    Color(.systemGray6).opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: height)
            
            // Shimmer effect
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            .clear,
                            .white.opacity(0.4),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: height)
                .offset(x: shimmerOffset)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
                        shimmerOffset = 200
                    }
                }
            
            // Glass overlay
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.3)
                .frame(height: height)
            
            // Loading indicator
            VStack(spacing: 12) {
                // Animated loading dots
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(.white.opacity(0.8))
                            .frame(width: 8, height: 8)
                            .scaleEffect(isAnimating ? 1.2 : 0.8)
                            .animation(
                                .easeInOut(duration: 0.6)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
                
                Text("Loading...")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.8))
            }
            .onAppear {
                isAnimating = true
            }
        }
    }
}

// Extension for corner radius on specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    ZStack {
        GlassBackground()
        
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 20) {
                ForEach(0..<4) { _ in
                    NavigationLink(destination: Text("Product Detail")) {
                        GlassMedusaProductCard(product: MedusaProduct(
                            id: "prod_01JYTRJ9389X398ZWSVVFCF40Y",
                            title: "Medusa Sweatshirt",
                            subtitle: nil,
                            description: "Reimagine the feeling of a classic sweatshirt.",
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
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
        }
    }
}