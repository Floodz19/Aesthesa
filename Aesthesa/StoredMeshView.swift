//
// StoredMeshView.swift
//

import SwiftUI
import ARKit

struct StoredMeshView: View {
    
    @Binding var rotation: Angle
    @Binding var scale: CGFloat
    @Binding var dragOffset: CGSize
    @Binding var currentFaceGeometry: ARSCNFaceGeometry?

    // StoredMeshView needs to display stored [non-changing] face mesh
    var body: some View {
        VStack {
            ARView(
                showStoredMeshView: .constant(true),
                startTime: .constant(nil),
                rotation: $rotation,
                scale: $scale,
                dragOffset: $dragOffset,
                currentFaceGeometry: $currentFaceGeometry
            )
            .frame(width: 300, height: 300, alignment: .center)
            .background(Color.gray)
            .cornerRadius(10)
            .padding()

            // Needs Work
            Text("Zoom: \(Int(scale * 100))%")
            Slider(value: $scale, in: 0.5...2.0, step: 0.01)
                .padding()

            // Needs Work
            Text("Rotation: \(Int(rotation.degrees))°")
            Slider(value: $rotation.degrees, in: 0...360, step: 1)
                .padding()

            Spacer()
        }
    }
}

