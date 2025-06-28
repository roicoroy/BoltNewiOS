//
//  MedusaService.swift
//  BoltNewiOS
//
//  Created by Ricardo Bento on 24/06/2025.
//

import Foundation

class MedusaService: ObservableObject {
    static let shared = MedusaService()
    
    private let baseURL = "http://localhost:9000"
    private let publishableAPIKey = "pk_d62e2de8f849db562e79a89c8a08ec4f5d23f1a958a344d5f64dfc38ad39fa1a"
    
    @Published var products: [MedusaProduct] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private init() {}
    
    func fetchProducts() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        guard let url = URL(string: "\(baseURL)/store/products") else {
            await MainActor.run {
                errorMessage = "Invalid URL"
                isLoading = false
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(publishableAPIKey, forHTTPHeaderField: "x-publishable-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                await MainActor.run {
                    errorMessage = "Invalid response"
                    isLoading = false
                }
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                await MainActor.run {
                    errorMessage = "Server error: \(httpResponse.statusCode)"
                    isLoading = false
                }
                return
            }
            
            // Debug: Print the raw JSON response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON Response:")
                print(jsonString)
            }
            
            let decoder = JSONDecoder()
            
            // Try to decode the response
            do {
                let productsResponse = try decoder.decode(MedusaProductsResponse.self, from: data)
                
                await MainActor.run {
                    self.products = productsResponse.products
                    self.isLoading = false
                }
            } catch let decodingError {
                print("Decoding error: \(decodingError)")
                
                // Try to decode just the structure to see what's missing
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("JSON Structure:")
                    print(jsonObject)
                }
                
                await MainActor.run {
                    self.errorMessage = "Failed to decode products: \(decodingError.localizedDescription)"
                    self.isLoading = false
                }
            }
            
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to fetch products: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func getProduct(by id: String) -> MedusaProduct? {
        return products.first { $0.id == id }
    }
    
    func getProductsByCategory(_ category: String) -> [MedusaProduct] {
        if category == "All" {
            return products
        }
        return products.filter { $0.category.lowercased() == category.lowercased() }
    }
    
    func searchProducts(_ searchText: String) -> [MedusaProduct] {
        if searchText.isEmpty {
            return products
        }
        
        return products.filter { product in
            product.title.localizedCaseInsensitiveContains(searchText) ||
            product.description.localizedCaseInsensitiveContains(searchText) ||
            product.category.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func getAvailableCategories() -> [String] {
        let categories = Set(products.map { $0.category })
        return ["All"] + Array(categories).sorted()
    }
}