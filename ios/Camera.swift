//
//  Camera.swift
//  pytorch_linking
//
//  Created by Leon Dai on 2020-05-20.
//

import Foundation

@available(iOS 10.0, *)
@objc(Camera)

class Camera: RCTViewManager {
  override func view() -> UIView! {
    return CameraView()
  }
}
