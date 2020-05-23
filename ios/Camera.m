//
//  Camera.m
//  pytorch_linking
//
//  Created by Leon Dai on 2020-05-20.
//

#import "React/RCTViewManager.h"
@interface RCT_EXTERN_MODULE(Camera, RCTViewManager)
RCT_EXPORT_VIEW_PROPERTY(bestGuess, NSString)
RCT_EXPORT_VIEW_PROPERTY(confidence, float)
RCT_EXPORT_VIEW_PROPERTY(onStatusChange, RCTDirectEventBlock)
@end
