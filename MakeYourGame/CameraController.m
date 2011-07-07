//
//  CameraController.m
//  video lights out
//
//  Created by Francisco M. Silva Ferreira on 3/30/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "CameraController.h"

@implementation CameraController


- (id)init{
    // always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        session = [[AVCaptureSession alloc] init];
        //session.sessionPreset = AVCaptureSessionPresetMedium;
        //session.sessionPreset = AVCaptureSessionPreset640x480;
//        session.sessionPreset = AVCaptureSessionPresetLow;
        session.sessionPreset = AVCaptureSessionPresetLow;
        //session.sessionPreset = AVCaptureSessionPreset1280x720;
        
        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error;
        input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        [session addInput:input];
        
        output = [[AVCaptureVideoDataOutput alloc] init];
        [session addOutput:output];
        
        dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
        [output setSampleBufferDelegate:self queue:queue];
        dispatch_release(queue);
        
        output.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                                           forKey:(id)kCVPixelBufferPixelFormatTypeKey];
        
        output.minFrameDuration = CMTimeMake(1, 15);
        
        [session startRunning];
        NSLog(@"session running");
	}
	return self;
    
}

- (CCTexture2D*) getTexture{
    return texture;
}

- (void) activate{
    transform = true;
}

- (void) deactivate{
    transform = false;
}

- (UIImage*) getImage{
    return currentImage;
}

- (void) setDetector:(Detector*) detector_{
    detector = detector_;
}

- (void) captureOutput:(AVCaptureOutput *) captureOutput
 didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
        fromConnection:(AVCaptureConnection *)connection {
    
        UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
        
        dispatch_async(dispatch_get_main_queue(), ^{ 
            if(transform){
                if(texture!=NULL){
                    [texture release];
                }
                currentImage = image;
                [detector setImage:image];
                [detector doTrace];
                //texture = [[CCTexture2D alloc] initWithImage:[detector getImage]];
                texture = [[CCTexture2D alloc] initWithImage:[detector getPaintedImage]];
            }else{
                texture = [[CCTexture2D alloc] initWithImage:[detector getPaintedImage]];
            }

        });
    
}


- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer 
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer); 
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0); 
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer); 
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer); 
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer); 
    size_t height = CVPixelBufferGetHeight(imageBuffer); 
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, 
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst); 
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context); 
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context); 
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [session release];
    [device release];
    [input release];
    [output release];
    
	[super dealloc];
}

@end
