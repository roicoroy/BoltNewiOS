//
//  GlassMedusaHomeView.swift
//  BoltNewiOS
//
//  Created by Ricardo Bento on 24/06/2025.
//

import SwiftUI

struct GlassMedusaHomeView: View {
    @StateObject private var medusaService = MedusaService.shared
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var showingProfile = false
    
    private var availableCategories: [String] {
        medusaService.getAvailableCategories()
    }
    
    private var filteredProducts: [MedusaProduct] {
        var filtered = medusaService.products
        
        if selectedCategory != "All" {
            filtered = medusaService.getProductsByCategory(selectedCategory)
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { 
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Glass Background
                GlassBackground()
                
                VStack(spacing: 0) {
                    // Custom Navigation Bar
                    GlassNavigationBar(
                        title: "Medusa Store",
                        leadingIcon: "line.3.horizontal",
                        trailingIcon: "person.circle",
                        leadingAction: {},
                        trailingAction: { showingProfile.toggle() }
                    )
                    
                    // Content
                    ScrollView {
                        VStack(spacing: 24) {
                            // Welcome Section
                            GlassCard(cornerRadius: 20) {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("Welcome back!")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            
                                            Text("Discover amazing products")
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.primary)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "sparkles")
                                            .font(.title2)
                                            .foregroundColor(.blue)
                                            .padding(12)
                                            .background(
                                                Circle()
                                                    .fill(.blue.opacity(0.15))
                                            )
                                    }
                                    
                                    // Search Bar
                                    GlassCard(cornerRadius: 16) {
                                        HStack(spacing: 12) {
                                            Image(systemName: "magnifyingglass")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            
                                            TextField("Search products...", text: $searchText)
                                                .textFieldStyle(PlainTextFieldStyle())
                                                .font(.subheadline)
                                            
                                            if !searchText.isEmpty {
                                                Button(action: { searchText = "" }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .font(.subheadline)
                                                        .foregroundColor(.secondary)
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                    }
                                }
                                .padding(20)
                            }
                            .padding(.horizontal, 20)
                            
                            // Category Filter
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(availableCategories, id: \.self) { category in
                                        GlassButton(
                                            title: category,
                                            isSelected: selectedCategory == category
                                        ) {
                                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                                selectedCategory = category
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            // Products Section
                            if medusaService.isLoading {
                                GlassLoadingView()
                            } else if let errorMessage = medusaService.errorMessage {
                                GlassErrorView(message: errorMessage) {
                                    Task {
                                        await medusaService.fetchProducts()
                                    }
                                }
                            } else if filteredProducts.isEmpty {
                                GlassEmptyStateView()
                            } else {
                                LazyVGrid(columns: [
                                    GridItem(.flexible(), spacing: 16),
                                    GridItem(.flexible(), spacing: 16)
                                ], spacing: 20) {
                                    ForEach(filteredProducts) { product in
                                        NavigationLink(destination: GlassMedusaProductDetailView(product: product)) {
                                            GlassMedusaProductCard(product: product)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            // Bottom spacing
                            Spacer(minLength: 100)
                        }
                        .padding(.top, 20)
                    }
                }
            }
            .navigationBarHidden(true)
            .task {
                if medusaService.products.isEmpty {
                    await medusaService.fetchProducts()
                }
            }
            .refreshable {
                await medusaService.fetchProducts()
            }
        }
        .sheet(isPresented: $showingProfile) {
            GlassProfileView()
        }
    }
}

struct GlassLoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        GlassCard(cornerRadius: 20) {
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .stroke(.blue.opacity(0.3), lineWidth: 4)
                        .frame(width: 50, height: 50)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 50, height: 50)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                }
                
                Text("Loading amazing products...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(40)
        }
        .padding(.horizontal, 20)
        .onAppear {
            isAnimating = true
        }
    }
}

struct GlassErrorView: View {
    let message: String
    let retry: () -> Void
    
    var body: some View {
        GlassCard(cornerRadius: 20) {
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 48))
                    .foregroundColor(.orange)
                
                Text("Oops!")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                GlassButton(title: "Try Again", icon: "arrow.clockwise") {
                    retry()
                }
            }
            .padding(40)
        }
        .padding(.horizontal, 20)
    }
}

struct GlassEmptyStateView: View {
    var body: some View {
        GlassCard(cornerRadius: 20) {
            VStack(spacing: 20) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
                
                Text("No products found")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("Try adjusting your search or filters to find what you're looking for")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(40)
        }
        .padding(.horizontal, 20)
    }
}

struct GlassProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            GlassBackground()
            
            VStack {
                GlassNavigationBar(
                    title: "Profile",
                    leadingIcon: "xmark",
                    leadingAction: { dismiss() }
                )
                
                Spacer()
                
                GlassCard(cornerRadius: 20) {
                    VStack(spacing: 20) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        Text("Welcome to Medusa Store")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Your profile features coming soon!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(40)
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    GlassMedusaHomeView()
}