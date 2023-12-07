// StoredMeshView.swift
import SwiftUI
import SceneKit

struct StoredMeshView: View {
    @State private var rotation: Angle = .zero
    @State private var scale: CGFloat = 1.0
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        VStack {
            SceneKitView(rotation: $rotation, scale: $scale, dragOffset: $dragOffset)
                .frame(width: 300, height: 300, alignment: .center)
                .background(Color.gray)
                .cornerRadius(10)
                .padding()

            Text("Zoom: \(Int(scale * 100))%")
            Slider(value: $scale, in: 0.5...2.0, step: 0.01)
                .padding()

            Text("Rotation: \(Int(rotation.degrees))°")
            Slider(value: $rotation.degrees, in: 0...360, step: 1)
                .padding()

            Spacer()
        }
    }
}

