//
//  CategoryChip.swift
//  BoltNewiOS
//
//  Created by Ricardo Bento on 24/06/2025.
//

import SwiftUI

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
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HStack {
        CategoryChip(title: "All", isSelected: true) {}
        CategoryChip(title: "Electronics", isSelected: false) {}
        CategoryChip(title: "Clothing", isSelected: false) {}
    }
    .padding()
}