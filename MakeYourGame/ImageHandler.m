//
//  ImageHandler.m
//  blobdetector
//
//  Created by Francisco M. Silva Ferreira on 4/26/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "ImageHandler.h"

#define PIXEL_MULTIPLIER 4

@implementation ImageHandler

- (Boolean) setImage:(UIImage*)img{
    if(generated){
        [currentGeneratedImage release];
    }
    
    generated = NO;
    
    
	image = img;
	
	CGImageRef imgRef = image.CGImage;
    
	CGDataProviderRef dataProvider = CGImageGetDataProvider(imgRef);
	CFDataRef imageData = CGDataProviderCopyData(dataProvider);
	pixels = (void*)CFDataGetBytePtr(imageData);
    
    CGDataProviderRef odataProvider = CGImageGetDataProvider(imgRef);
	CFDataRef oimageData = CGDataProviderCopyData(odataProvider);
    original = (void*)CFDataGetBytePtr(oimageData);
	
	
	width = CGImageGetWidth(imgRef);
	height = CGImageGetHeight(imgRef);
	
	numberOfPixels = width*height;
	
	tags = malloc(numberOfPixels*(sizeof(int)));
	
    
	return true;
}

- (UIImage*) getImage{
    if(!generated){
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        CGContextRef context = CGBitmapContextCreate(
                                                     pixels,
                                                     width,
                                                     height,
                                                     8,
                                                     width*PIXEL_MULTIPLIER,
                                                     colorSpace,
                                                     kCGImageAlphaNoneSkipLast
                                                     );
        
        
        
        CGImageRef imgRef = CGBitmapContextCreateImage(context);
        
        //[img release];
        CGColorSpaceRelease(colorSpace);
        
        //free(pixels);
        
        currentGeneratedImage = [UIImage imageWithCGImage: imgRef];
        [currentGeneratedImage retain];
        generated = YES;
    }
    
    return currentGeneratedImage;
	
}

- (UIImage*) getOriginal{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	CGContextRef context = CGBitmapContextCreate(
												 original,
												 width,
												 height,
												 8,
												 width*PIXEL_MULTIPLIER,
												 colorSpace,
												 kCGImageAlphaNoneSkipLast
												 );
	
	
	
	CGImageRef imgRef = CGBitmapContextCreateImage(context);
	
	//[img release];
	CGColorSpaceRelease(colorSpace);
	
	//free(pixels);
	
	return [UIImage imageWithCGImage: imgRef];
}

- (void) paintOriginalWithBlobs:(NSMutableArray*)blobs{
    for(NSMutableArray* blob in blobs){
        for(NSValue* val in blob){
            CGPoint coords = [val CGPointValue];
            [self setRGBOriginal:coords.x :coords.y :0 :255 :0];
        }
    }
}

- (void) threshold:(int)value{
	int x,y;
	for(y=0;y<height;y++){
		for(x=0;x<width;x++){
            [self setTag:x :y :0];
            if(x==0 || y==0 || y==height-1 || x == width-1){
                [self setRGB:x :y :255 :255 :255];
            }else if([self getRed:x:y]<value){
				[self setRGB:x :y :0 :0 :0];
			}else{
				if([self getBlue:x :y]!=0){
					[self setRGB:x :y :255 :255 :255];
				}
			}
		}
	}		
}

- (int) getXY:(int)x :(int)y{
	return (width*PIXEL_MULTIPLIER*y+x*PIXEL_MULTIPLIER);
}

- (void) setRGB:(int)x :(int)y :(UInt8)r :(UInt8)g :(UInt8)b{
	pixels[[self getXY:x:y]]=r;
	pixels[[self getXY:x:y]+1]=g;
	pixels[[self getXY:x:y]+2]=b;
}

- (void) setRGBOriginal:(int)x :(int)y :(UInt8)r :(UInt8)g :(UInt8)b{
    original[[self getXY:x:y]]=r;
	original[[self getXY:x:y]+1]=g;
	original[[self getXY:x:y]+2]=b;
}

- (void) setTag:(int)x :(int)y :(int)tag{
	tags[width*y+x]=tag;
    
}


- (UInt8) getRed:(int)x :(int)y{
	return pixels[[self getXY:x:y]];
}

- (UInt8) getGreen:(int)x :(int)y{
	return pixels[[self getXY:x:y]+1];
}

- (UInt8) getBlue:(int)x :(int)y{
	return pixels[[self getXY:x:y]+2];
}

- (int) getTag:(int)x :(int)y{
	return tags[width*y+x];
    
}


// on "init" you need to initialize your instance
-(id) init{
	if( (self=[super init])) {
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[super dealloc];
}


@end
