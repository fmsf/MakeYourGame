//
//  ImageHandler.h
//  blobdetector
//
//  Created by Francisco M. Silva Ferreira on 4/26/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageHandler : NSObject {
    UInt8   *pixels;
    int   *tags;
    UInt8   *original;
    UIImage *image;
    UIImage *currentGeneratedImage;
    
    
    int     width;
    int     height;
    int     numberOfPixels;
    
    Boolean generated;
    
}


- (Boolean) setImage:(UIImage*)img;

- (UIImage*) getImage;
- (UIImage*) getOriginal;

- (void) paintOriginalWithBlobs:(NSMutableArray*)blobs;

- (void) threshold:(int)value;

- (int) getXY:(int)x :(int)y;

- (void) setRGB:(int)x :(int)y :(UInt8)r :(UInt8)g :(UInt8)b;
- (void) setRGBOriginal:(int)x :(int)y :(UInt8)r :(UInt8)g :(UInt8)b;

- (void) setTag:(int)x :(int)y :(int)tag;


- (UInt8) getRed:(int)x :(int)y;

- (UInt8) getGreen:(int)x :(int)y;

- (UInt8) getBlue:(int)x :(int)y;

- (int) getTag:(int)x :(int)y;

@end
