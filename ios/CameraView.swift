//
//  CameraView.swift
//  pytorch_linking
//
//  Created by Leon Dai on 2020-05-20.
//

import Foundation
import AVFoundation
import UIKit

@available(iOS 10.0, *)
class CameraView: UIView {
  
  // @objc var bestGuesses: NSArray
  @objc var onStatusChange: RCTDirectEventBlock?
  
  private var predictor = ImagePredictor()
  private let inputWidth = 224
  private let inputHeight = 224

  private lazy var videoDataOutput: AVCaptureVideoDataOutput = {
    let video = AVCaptureVideoDataOutput()
    video.alwaysDiscardsLateVideoFrames = true
    video.videoSettings = [String(kCVPixelBufferPixelFormatTypeKey) : kCMPixelFormat_32BGRA]
    video.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
    video.connection(with: .video)?.isEnabled = true
    return video
  }()

  private let videoDataOutputQueue: DispatchQueue = DispatchQueue(label: "JKVideoDataOutputQueue")
  private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
      let layer = AVCaptureVideoPreviewLayer(session: session)
      layer.videoGravity = .resizeAspect
      return layer
  }()

  private let captureDevice: AVCaptureDevice? = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
  private lazy var session: AVCaptureSession = {
    let session = AVCaptureSession()
    session.sessionPreset = .high//.vga640x480
    return session
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)

      commonInit()
  }

  private func commonInit() {
      contentMode = .scaleAspectFit
      beginSession()
  }

  private func beginSession() {
      do {
          guard let captureDevice = captureDevice else {
              return
              // fatalError("Camera doesn't work on the simulator! You have to test this on an actual device!")
          }
          let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
          if session.canAddInput(deviceInput) {
              session.addInput(deviceInput)
          }

          if session.canAddOutput(videoDataOutput) {
              session.addOutput(videoDataOutput)
          }
          layer.masksToBounds = true
          layer.addSublayer(previewLayer)
          previewLayer.frame = bounds
          session.startRunning()
      } catch let error {
          debugPrint("\(self.self): \(#function) line: \(#line).  \(error.localizedDescription)")
      }
  }
  
  override func layoutSubviews() {
      super.layoutSubviews()
      previewLayer.frame = bounds
  }
  
}

@available(iOS 10.0, *)
extension CameraView: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    connection.videoOrientation = .portrait
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
    guard let normalizedBuffer = pixelBuffer.normalized(inputWidth, inputHeight) else { return }
    
    if let results = try? predictor.predict(normalizedBuffer, resultCount: 3) {
      /*
      print("----------- next result -----------")
      for result in results.0 {
        print("item: \(result.label), confidence: \(result.score)/")
      }
      */
      print("bestGuess: \(results.0[0].label), confidence: \(results.0[0].score)")
      onStatusChange!(["bestGuess": results.0[0].label,"confidence": results.0[0].score])
    }
  }
}
