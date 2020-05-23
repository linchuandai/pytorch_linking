//
//  CameraPreviewView.swift
//  pytorch_linking
//
//  Created by Leon Dai on 2020-05-21.
//

import AVFoundation
import UIKit

class CameraPreviewView: UIView {
    var previewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = self.layer as? AVCaptureVideoPreviewLayer else {
            fatalError("AVCaptureVideoPreviewLayer is expected")
        }
        return layer
    }

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
