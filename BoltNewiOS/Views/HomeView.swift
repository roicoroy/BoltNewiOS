//
//  HomeView.swift
//  BoltNewiOS
//
//  Created by Ricardo Bento on 24/06/2025.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var products: [Product]
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    
    private let categories = ["All", "Electronics", "Clothing", "Books", "Home & Garden", "Sports"]
    
    private var filteredProducts: [Product] {
        var filtered = products
        
        if selectedCategory != "All" {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { 
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.productDescription.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome back!")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("Discover Products")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "person.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Search products...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categories, id: \.self) { category in
                                CategoryChip(
                                    title: category,
                                    isSelected: selectedCategory == category
                                ) {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 16)
                .background(Color(.systemBackground))
                
                // Products Grid
                if filteredProducts.isEmpty {
                    EmptyStateView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ], spacing: 16) {
                            ForEach(filteredProducts) { product in
                                NavigationLink(destination: ProductDetailView(product: product)) {
                                    ProductCard(product: product)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                if products.isEmpty {
                    addSampleProducts()
                }
            }
        }
    }
    
    private func addSampleProducts() {
        let sampleProducts = [
            Product(
                name: "iPhone 15 Pro",
                price: 999.99,
                description: "The most advanced iPhone yet with titanium design and A17 Pro chip.",
                category: "Electronics",
                imageURL: "https://images.pexels.com/photos/788946/pexels-photo-788946.jpeg",
                rating: 4.8,
                reviewCount: 1247
            ),
            Product(
                name: "MacBook Air M3",
                price: 1299.99,
                description: "Supercharged by the M3 chip, incredibly thin and light design.",
                category: "Electronics",
                imageURL: "https://images.pexels.com/photos/205421/pexels-photo-205421.jpeg",
                rating: 4.9,
                reviewCount: 892
            ),
            Product(
                name: "Premium Cotton T-Shirt",
                price: 29.99,
                description: "Soft, comfortable cotton t-shirt perfect for everyday wear.",
                category: "Clothing",
                imageURL: "https://images.pexels.com/photos/996329/pexels-photo-996329.jpeg",
                rating: 4.3,
                reviewCount: 156
            ),
            Product(
                name: "Wireless Headphones",
                price: 199.99,
                description: "Premium noise-canceling wireless headphones with 30-hour battery.",
                category: "Electronics",
                imageURL: "https://images.pexels.com/photos/3394650/pexels-photo-3394650.jpeg",
                rating: 4.6,
                reviewCount: 743
            ),
            Product(
                name: "The Art of Programming",
                price: 49.99,
                description: "Comprehensive guide to modern programming techniques and best practices.",
                category: "Books",
                imageURL: "https://images.pexels.com/photos/159711/books-bookstore-book-reading-159711.jpeg",
                rating: 4.7,
                reviewCount: 234
            ),
            Product(
                name: "Smart Garden Kit",
                price: 89.99,
                description: "Automated indoor garden system for growing herbs and vegetables.",
                category: "Home & Garden",
                imageURL: "https://images.pexels.com/photos/1301856/pexels-photo-1301856.jpeg",
                rating: 4.4,
                reviewCount: 89
            )
        ]
        
        for product in sampleProducts {
            modelContext.insert(product)
        }
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No products found")
                .font(.title3)
                .fontWeight(.medium)
            
            Text("Try adjusting your search or filters")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Product.self, inMemory: true)
}