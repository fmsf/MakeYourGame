//
//  EarClipper.h
//  MakeYourGame
//
//  Created by Francisco M. Silva Ferreira on 5/17/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


#define MINIMUM_POINTS_IN_POLYGON 30

@interface EarClipper : NSObject {
    NSMutableArray* removedPoints;
}

+ (float) CrossArea:(CGPoint) A:(CGPoint) B: (CGPoint) C;
- (NSMutableArray*) TransformToPolygons:(NSMutableArray*) points;
- (int) findEar:(NSMutableArray*) points:(int)start;
- (NSMutableArray*) ExtractEars:(NSMutableArray*) points;
- (Boolean) PointInTriangle:(CGPoint) A:(CGPoint) B: (CGPoint) C: (CGPoint) P;




@end
