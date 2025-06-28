//
//  ContentView.swift
//  BoltNewiOS
//
//  Created by Ricardo Bento on 24/06/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        MedusaHomeView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Product.self, inMemory: true)
}