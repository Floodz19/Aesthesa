//
//  ARFaceMeshView.swift
//  Aesthesa
//

import SwiftUI

struct ARFaceMeshView: View {
    
    @State private var showStoredMeshView = false
    @State private var startTime: Date?
    @State private var rotation: Angle = .zero
    @State private var scale: CGFloat = 1.0
    @State private var dragOffset: CGSize = .zero

    
    
    
    var body: some View {
        ZStack {
            
            if showStoredMeshView {
                StoredMeshView(
                    rotation: $rotation,
                    scale: $scale,
                    dragOffset: $dragOffset,
                    currentFaceGeometry: Binding.constant(nil)
                )
            } else {
                ARView(
                    showStoredMeshView: $showStoredMeshView,
                    startTime: $startTime,
                    rotation: $rotation,
                    scale: $scale,
                    dragOffset: $dragOffset,
                    currentFaceGeometry: Binding.constant(nil)
                )
            }
        }
        
        .onAppear {
            startTime = Date()
            
        }
    }
}




