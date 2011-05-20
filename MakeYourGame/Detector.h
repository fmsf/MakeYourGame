//
//  Detector.h
//  blobdetector
//
//  Created by Francisco M. Silva Ferreira on 4/26/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageHandler.h"
#import "cocos2d.h"
#import "TagAssociation.h"

@interface Detector : NSObject {
    ImageHandler* imageHandler;
    UInt8 threshold_level;
    
    UIImage* currentUImage;
    UIImage* imageCopy;
    
    CGPoint clockWiseSequence[8];
    int currentTag;
    int savedTag;
    
    NSMutableArray* associations;
    NSMutableArray* lastBlobList;
    
    Boolean activeTrace;
}

- (UIImage*) getImage;
- (void) setImage:(UIImage*) inputImage;
- (void) doTrace;
- (UIImage*) getPaintedImage;
- (NSMutableArray*) getBlobs;






@end
