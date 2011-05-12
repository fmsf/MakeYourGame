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
    UInt8   *tags;
    UInt8   *original;
    UIImage *image;

    
    int     width;
    int     height;
    int     numberOfPixels;
    
}


- (Boolean) setImage:(UIImage*)img;

- (UIImage*) getImage;
- (UIImage*) getOriginal;


- (void) threshold:(int)value;

- (int) getXY:(int)x :(int)y;

- (void) setRGB:(int)x :(int)y :(UInt8)r :(UInt8)g :(UInt8)b;

- (void) setTag:(int)x :(int)y :(UInt8)tag;


- (UInt8) getRed:(int)x :(int)y;

- (UInt8) getGreen:(int)x :(int)y;

- (UInt8) getBlue:(int)x :(int)y;

- (UInt8) getTag:(int)x :(int)y;

@end
