//
//  CameraController.h
//  video lights out
//
//  Created by Francisco M. Silva Ferreira on 3/30/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "cocos2d.h"
#import "Detector.h"

@interface CameraController : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>{
    AVCaptureSession *session;
    AVCaptureDevice *device;
    AVCaptureDeviceInput *input;
    AVCaptureVideoDataOutput *output;
    
    CCTexture2D *texture;
    Boolean transform;
    
    UIImage* currentImage;
    Detector* detector;
}

- (CCTexture2D*) getTexture;
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;
- (void) activate;
- (void) deactivate;
- (UIImage*) getImage;
- (void) setDetector:(Detector*) detector_;





@end
