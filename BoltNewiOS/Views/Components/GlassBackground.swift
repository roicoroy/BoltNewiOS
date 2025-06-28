//
//  GlassBackground.swift
//  BoltNewiOS
//
//  Created by Ricardo Bento on 24/06/2025.
//

import SwiftUI

struct GlassBackground: View {
    @State private var animateGradient = false
    
    var body: some View {
        ZStack {
            // Base gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.3),
                    Color(red: 0.2, green: 0.1, blue: 0.4),
                    Color(red: 0.1, green: 0.2, blue: 0.5)
                ],
                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                endPoint: animateGradient ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
            
            // Floating orbs
            GeometryReader { geometry in
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.blue.opacity(0.3),
                                    Color.purple.opacity(0.2),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .offset(
                            x: CGFloat.random(in: -100...geometry.size.width),
                            y: CGFloat.random(in: -100...geometry.size.height)
                        )
                        .blur(radius: 20)
                        .animation(
                            .easeInOut(duration: Double.random(in: 4...8))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.5),
                            value: animateGradient
                        )
                }
            }
        }
    }
}

struct GlassNavigationBar: View {
    let title: String
    let leadingAction: (() -> Void)?
    let trailingAction: (() -> Void)?
    let leadingIcon: String?
    let trailingIcon: String?
    
    init(
        title: String,
        leadingIcon: String? = nil,
        trailingIcon: String? = nil,
        leadingAction: (() -> Void)? = nil,
        trailingAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.leadingAction = leadingAction
        self.trailingAction = trailingAction
    }
    
    var body: some View {
        HStack {
            if let leadingIcon = leadingIcon, let leadingAction = leadingAction {
                Button(action: leadingAction) {
                    Image(systemName: leadingIcon)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .frame(width: 40, height: 40)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
            } else {
                Spacer()
                    .frame(width: 40)
            }
            
            Spacer()
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
            
            if let trailingIcon = trailingIcon, let trailingAction = trailingAction {
                Button(action: trailingAction) {
                    Image(systemName: trailingIcon)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .frame(width: 40, height: 40)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
            } else {
                Spacer()
                    .frame(width: 40)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    ZStack {
        GlassBackground()
        
        VStack {
            GlassNavigationBar(
                title: "Medusa Store",
                leadingIcon: "line.3.horizontal",
                trailingIcon: "person.circle",
                leadingAction: {},
                trailingAction: {}
            )
            
            Spacer()
        }
    }
}