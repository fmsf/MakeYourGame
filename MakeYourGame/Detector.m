//
//  Detector.m
//  blobdetector
//
//  Created by Francisco M. Silva Ferreira on 4/26/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "Detector.h"


@implementation Detector


- (NSMutableArray*) trace:(int)x :(int)y external:(Boolean)external{
    NSMutableArray* points = [[NSMutableArray alloc] init];
    
    CGPoint firstPoint = ccp(x,y);
    CGPoint firstNext;
    
    CGPoint currentPoint = firstNext = ccp(-1,-1);
    
    Boolean finish = false;
    
    int nextInSequence;
    if(external){
        nextInSequence = 7;
    }else{
        nextInSequence = 3;
    }
    
    //    int jumpover = 0;
    
    
    while (!finish) {
        if(currentPoint.y==-1){
            currentPoint = firstPoint;
        }else if(firstNext.y==-1){
            firstNext = currentPoint;
        }
        
        
        [imageHandler setTag:currentPoint.x :currentPoint.y :currentTag];
        [points addObject:[NSValue valueWithCGPoint:currentPoint]];
        
        int i;
        for(i=0;i<8;i++){
            CGPoint nextIndexToSearch = clockWiseSequence[(nextInSequence+i)%8];
            CGPoint nextPointToSearch = ccp(currentPoint.x+nextIndexToSearch.x, currentPoint.y+nextIndexToSearch.y);
            
            if([imageHandler getRed:nextPointToSearch.x :nextPointToSearch.y]==0){
                
                if(currentPoint.x == firstPoint.x &&  currentPoint.y==firstPoint.y){
                    if(nextPointToSearch.x == firstNext.x && nextPointToSearch.y == firstNext.y){
                        finish = true;
                        break;
                    }
                }
                
                nextInSequence = (nextInSequence+i+4+2)%8;
                currentPoint = nextPointToSearch;                
                if([points count]==0 || points == NULL){
                    int d;
                    d = 1 +1;
                    
                }
                break;
            }else if([imageHandler getTag:nextPointToSearch.x :nextPointToSearch.y]==0){
                [imageHandler setTag:nextPointToSearch.x :nextPointToSearch.y :1];
            }
        }
        
        if(i==8){
            // point is isolated stop now and return null
            [points release];
            return NULL;
        }
        
        
    }
    
    return points;
}

- (void) process{
    NSMutableArray* blobs = [[NSMutableArray alloc] init];
    NSLog(@"%f %f",[imageHandler getImage].size.height, [imageHandler getImage].size.width);
    for(int y=0;y<[imageHandler getImage].size.height;y++){
        for(int x=0;x<[imageHandler getImage].size.width;x++){
            if([imageHandler getRed:x :y]==0){
                Boolean externalTrace = false;
                Boolean internalTrace = false;
                if([imageHandler getRed:x :y-1]==255 && [imageHandler getTag:x :y]==0){
                    NSMutableArray *newBlob = [self trace:x :y external:YES];
                    if(newBlob!=NULL){
                        [blobs addObject:newBlob]; // TRACE MAIN BLOB
                    }
                    if(currentTag!=savedTag){
                        currentTag = savedTag;
                    }
                    currentTag++;
                    savedTag = currentTag;
                    externalTrace = true;
                }
                if([imageHandler getRed:x :y+1]==255 && [imageHandler getTag:x :y+1]==0){
                    if([imageHandler getTag:x :y]==0){
                        int candidateTag = [imageHandler getTag:x-1 :y];
                        if(candidateTag==0){
                            NSLog(@"Something wrong happened here! There should be a tag at %d %d",x,y);
                        }else{
                            currentTag = candidateTag;
                            [imageHandler setTag:x :y :currentTag];
                        }
                    }
                    NSMutableArray *newBlob = [self trace:x :y external:NO];
                    if(newBlob!=NULL){
                        [blobs addObject:newBlob]; // TRACE MAIN BLOB
                    }
                    internalTrace = true;
                }
                
                if(!externalTrace && !internalTrace){
                    if([imageHandler getTag:x :y]==0){
                        int candidateTag = [imageHandler getTag:x-1 :y];
                        [imageHandler setTag:x :y :candidateTag];
                    }
                }
            }                       
        }
    }
    NSLog(@"blob count %d", [blobs count]);
    /*    for(int i=0;i<[blobs count];i++){
     
     }*/
    if(lastBlobList!=NULL){
        [lastBlobList release];
    }
    lastBlobList = blobs;
    [lastBlobList retain];
    [imageHandler paintOriginalWithBlobs:blobs]; 
}



/*- (CCTexture2D*) paintImage{
 ImageHandler* imgha = [[ImageHandler alloc] init];
 [imgha setImage:imageCopy];
 
 for(NSMutableArray* blob in lastBlobList){
 for(NSValue* val in blob){
 CGPoint point = [val CGPointValue];
 [imgha setRGB:point.x :point.y :0 :255 :255];
 }
 }
 
 //[imgha release];
 CCTexture2D* texture = [[CCTexture2D alloc] initWithImage:[imgha getImage]];
 [imgha release];
 return texture;
 
 }*/


- (void) setImage:(UIImage*) inputImage{
    if(inputImage!=NULL){
        if(currentUImage!=NULL){
            [currentUImage release];
        }
        currentUImage = inputImage;
        //imageCopy = [inputImage copy];
        //[imageCopy retain];
        [currentUImage retain];
        [imageHandler setImage:currentUImage]; 
        [imageHandler threshold:threshold_level];
        if(activeTrace){
            [self process];
            activeTrace = false;
        }
        if(associations!=NULL){
            [associations release];
            associations = [[NSMutableArray alloc]init];
        }
    }
    
}

- (UIImage*) getImage{
    //return  currentUImage;
    return [imageHandler getImage];
}

- (CCTexture2D*) getRawImage{
    return [[CCTexture2D alloc] initWithImage:imageCopy];
}

- (UIImage*) getPaintedImage{
    return [imageHandler getOriginal];
}

- (NSMutableArray*) getBlobs{
    return lastBlobList;
}

- (void) doTrace{
    [self process];
}

// on "init" you need to initialize your instance
-(id) init{
	if( (self=[super init])) {
        threshold_level = 100;
        
        imageHandler = [[ImageHandler alloc] init];
        
/*        currentUImage = [UIImage imageNamed:@"Noise6.png"];
        imageHandler = [[ImageHandler alloc] init];
        [imageHandler setImage:currentUImage];
        [imageHandler threshold:threshold_level];*/
        
        clockWiseSequence[0] = ccp(1,0);   // 0
        clockWiseSequence[1] = ccp(1,1);  // 1
        clockWiseSequence[2] = ccp(0,1);  // 2
        clockWiseSequence[3] = ccp(-1,1); // 3
        clockWiseSequence[4] = ccp(-1,0);  // 4
        clockWiseSequence[5] = ccp(-1,-1);  // 5
        clockWiseSequence[6] = ccp(0,-1);   // 6            
        clockWiseSequence[7] = ccp(1,-1);   // 7
        
        
        savedTag = currentTag = 2;
        
        
        
        associations = [[NSMutableArray alloc] init];
        
        //[self process];
        
        
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[super dealloc];
}

@end
