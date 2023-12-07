
//
//  AppDelegate.swift
//

// AppDelegate not in use [AppDelegate.swift --> ARView.swift]
// Saved AppDelegate for Canthal Tilt Calculator


import SwiftUI
import ARKit

struct AppDelegate: UIViewRepresentable {
    // ARSCNView Delegate
    class Coordinator: NSObject, ARSCNViewDelegate {
        
        var faceNode: SCNNode?

        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard let faceAnchor = anchor as? ARFaceAnchor else { return }

            if faceNode == nil {
                // Render facial geometry once
                let faceGeometry = ARSCNFaceGeometry(device: renderer.device!)
                faceNode = SCNNode(geometry: faceGeometry)
                node.addChildNode(faceNode!)
            }

            // Update face geometry
            faceNode?.geometry?.firstMaterial?.fillMode = .lines
            faceNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.blue

            if let faceGeometry = faceNode?.geometry as? ARSCNFaceGeometry {
                // Lines for face mesh
                faceGeometry.firstMaterial?.fillMode = .lines
                //  Material color
                faceGeometry.firstMaterial?.diffuse.contents = UIColor.blue
                faceGeometry.update(from: faceAnchor.geometry)
            }


            // Call canthal tilt calculation
            // Needs work
            let canthalTilt = calculateCanthalTilt(from: faceAnchor)
            print("Canthal Tilt: \(canthalTilt)")
        }

        
        func calculateCanthalTilt(from faceAnchor: ARFaceAnchor) -> Float {
            
            // based on the blend shapes of the left and right eyes.
            
                    guard let leftEyeInner = faceAnchor.blendShapes[.eyeBlinkLeft]?.floatValue,
                          let leftEyeOuter = faceAnchor.blendShapes[.eyeBlinkLeft]?.floatValue,
                          let rightEyeInner = faceAnchor.blendShapes[.eyeBlinkRight]?.floatValue,
                          let rightEyeOuter = faceAnchor.blendShapes[.eyeBlinkRight]?.floatValue else {
                        return 0.0
                    }

                    // Values need ajusted
            
                    // Trying to determine canthal tilt [in degrees] with vector operations and dot product calculation
                    
                    // Vectors for the inner and outer corners of both eyes
                    let leftEyeVector = SCNVector3(leftEyeOuter - leftEyeInner, 0.0, 0.0)
                    let rightEyeVector = SCNVector3(rightEyeOuter - rightEyeInner, 0.0, 0.0)
            
                    let dotProduct = leftEyeVector.x * rightEyeVector.x
                    let leftMagnitude = sqrt(pow(leftEyeVector.x, 2))
                    let rightMagnitude = sqrt(pow(rightEyeVector.x, 2))
                    let canthalTiltRadians = acos(dotProduct / (leftMagnitude * rightMagnitude))
                    let canthalTiltDegrees = canthalTiltRadians * (180.0 / .pi)

            
                    return canthalTiltDegrees
                }
    }

    
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.delegate = context.coordinator
        arView.backgroundColor = UIColor.lightGray
        return arView
    }

    // Runs an ARFaceTracking session when ARSCNView is updated
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        let configuration = ARFaceTrackingConfiguration()
        uiView.session.run(configuration)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
}

