

// ARView.swift
// ARView.swift
// ARView.swift
import SwiftUI
import ARKit

struct ARView: UIViewRepresentable {
    
    @Binding var showStoredMeshView: Bool
    @Binding var startTime: Date?
    @Binding var rotation: Angle
    @Binding var scale: CGFloat
    @Binding var dragOffset: CGSize
    @Binding var currentFaceGeometry: ARSCNFaceGeometry?

    class Coordinator: NSObject, ARSCNViewDelegate {
        var faceNode: SCNNode?
        
        var showStoredMeshView: Binding<Bool>
        var startTime: Binding<Date?>
        var rotation: Binding<Angle>
        var scale: Binding<CGFloat>
        var dragOffset: Binding<CGSize>
        var currentFaceGeometry: Binding<ARSCNFaceGeometry?>

        init(
            showStoredMeshView: Binding<Bool>,
            startTime: Binding<Date?>,
            rotation: Binding<Angle>,
            scale: Binding<CGFloat>,
            dragOffset: Binding<CGSize>,
            currentFaceGeometry: Binding<ARSCNFaceGeometry?>
        ) {
            self.showStoredMeshView = showStoredMeshView
            self.startTime = startTime
            self.rotation = rotation
            self.scale = scale
            self.dragOffset = dragOffset
            self.currentFaceGeometry = currentFaceGeometry
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard let faceAnchor = anchor as? ARFaceAnchor else { return }
            
            if faceNode == nil {
                let faceGeometry = ARSCNFaceGeometry(device: renderer.device!)
                faceNode = SCNNode(geometry: faceGeometry)
                node.addChildNode(faceNode!)
            }
            
            faceNode?.geometry?.firstMaterial?.fillMode = .lines
            faceNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            
            if let faceGeometry = faceNode?.geometry as? ARSCNFaceGeometry {
                faceGeometry.firstMaterial?.fillMode = .lines
                faceGeometry.firstMaterial?.diffuse.contents = UIColor.blue
                faceGeometry.update(from: faceAnchor.geometry)
                currentFaceGeometry.wrappedValue = faceGeometry
            }
            
            // Store current face geometry after 5 seconds
            // Should reset timer when face mesh disappears [user's face is blocked]
            if let startTimeValue = startTime.wrappedValue?.timeIntervalSinceNow, startTimeValue <= -5.0 {
                
                storeCurrentFaceGeometry()
                
                // Switch to new page after storing mesh.
                showStoredMeshView.wrappedValue = true
            }
        }
        
        private func storeCurrentFaceGeometry() {
            // Pass the current face geometry to StoredMeshView
            currentFaceGeometry.wrappedValue = faceNode?.geometry as? ARSCNFaceGeometry
        }

        // Implement more ARSCNViewDelegate methods here [later]

        @objc func didPan(_ gesture: UIPanGestureRecognizer) {
            let translation = gesture.translation(in: gesture.view)
            dragOffset.wrappedValue = CGSize(width: translation.x, height: translation.y)
        }

        @objc func didPinch(_ gesture: UIPinchGestureRecognizer) {
            scale.wrappedValue = max(0.5, min(scale.wrappedValue * gesture.scale, 2.0))
            gesture.scale = 1.0
        }

        @objc func didRotate(_ gesture: UIRotationGestureRecognizer) {
            rotation.wrappedValue += Angle(radians: Double(gesture.rotation))
            gesture.rotation = 0
        }
    }

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.delegate = context.coordinator
        arView.backgroundColor = UIColor.lightGray

        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.didPan(_:)))
        arView.addGestureRecognizer(panGesture)

        let pinchGesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.didPinch(_:)))
        arView.addGestureRecognizer(pinchGesture)

        let rotationGesture = UIRotationGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.didRotate(_:)))
        arView.addGestureRecognizer(rotationGesture)

        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        let configuration = ARFaceTrackingConfiguration()
        uiView.session.run(configuration)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(
            showStoredMeshView: $showStoredMeshView,
            startTime: $startTime,
            rotation: $rotation,
            scale: $scale,
            dragOffset: $dragOffset,
            currentFaceGeometry: $currentFaceGeometry
        )
    }
}



