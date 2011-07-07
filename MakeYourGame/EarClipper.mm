//
//  EarClipper.m
//  MakeYourGame
//
//  Created by Francisco M. Silva Ferreira on 5/17/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "EarClipper.h"

@implementation EarClipper



+ (Boolean) CoLinear:(CGPoint) A:(CGPoint) B:(CGPoint) C{
    Boolean colinear = true;
    Boolean entry = false;
    if(A.x!=B.x && A.x!=C.x){
        entry = true;
        float m = (A.y-B.y)/(A.x-B.x);
        float b = A.y-(A.x*m);
        
        colinear = (A.y == m*A.x + b);
        if(colinear){
            colinear = (B.y == m*B.x + b);            
        }
        
        if(colinear){
            colinear = (C.y == m*C.x + b);            
        }
    }
    if(colinear && entry){
        NSLog(@"Colinear!!!");
        NSLog(@"a.x=%f a.y=%f",A.x,A.y);
        NSLog(@"b.x=%f b.y=%f",B.x,B.y);
        NSLog(@"c.x=%f c.y=%f",C.x,C.y);
    }

    return colinear;
}

+ (float) CrossArea:(CGPoint) A:(CGPoint) B: (CGPoint) C{
    return abs(A.x*B.y+B.x*C.y+C.x*A.y-A.x*C.y-C.x*B.y-B.x*A.y)/2;
/*    CGPoint a = A;
    CGPoint b = B;
    CGPoint c = C;
    float ab = sqrt((a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y));
    float ac = sqrt((a.x-c.x)*(a.x-c.x)+(a.y-c.y)*(a.y-c.y));
    float bc = sqrt((b.x-c.x)*(b.x-c.x)+(b.y-c.y)*(b.y-c.y));*/
}

- (Boolean) PointInTriangle:(CGPoint) A:(CGPoint) B: (CGPoint) C: (CGPoint) P{
    /*float ABC = [EarClipper CrossArea:A :B :C];
    
    float ABP = [EarClipper CrossArea:A :B :P];
    float ACP = [EarClipper CrossArea:A :C :P];
    float BCP = [EarClipper CrossArea:B :C :P];
    float acceptedFloatingPointErrorMargin = 0.000001;
    if(abs(ABC-(ABP+ACP+BCP))<acceptedFloatingPointErrorMargin){
        return NO;
    }else{
//        NSLog(@"-> area ->  %f",ABC);
        return YES;
    }*/
    CGPoint v0 = ccpSub(C, A);
    CGPoint v1 = ccpSub(B, A);
    CGPoint v2 = ccpSub(P, A);
    
    float dot00 = ccpDot(v0, v0);
    float dot01 = ccpDot(v0, v1);
    float dot02 = ccpDot(v0, v2);
    float dot11 = ccpDot(v1, v1);
    float dot12 = ccpDot(v1, v2);
    
    float invDemon = 1 / (dot00 * dot01 - dot01 * dot01);
    float u = (dot11 * dot02 - dot01 * dot12) * invDemon;
    float v = (dot00 * dot12 - dot01 * dot02) * invDemon;
    
    return (u > 0) && (v > 0) && (u + v < 1);
}

- (int) findEar:(NSMutableArray*) points:(int)start{
    int v0=0, v1=1, v2=2;
    for(int i=start;i<[points count];i++){
        if(i==0){
            v0=[points count]-1;
        }else{
            v0 = i-1;
        }
        v1 = i;
        if(i==[points count]-1){
            v2=0;
        }else{
            v2 = i+1;
        }
        
        
        CGPoint A = [(NSValue*)[points objectAtIndex:v0] CGPointValue];
        CGPoint B = [(NSValue*)[points objectAtIndex:v1] CGPointValue];
        CGPoint C = [(NSValue*)[points objectAtIndex:v2] CGPointValue];
        
        CGPoint BA = ccpSub(A, B);
        CGPoint BC = ccpSub(C, B);
        float angle = ccpAngle(BC, BA);
        if(angle>=M_PI){
            continue;
        }
        
        Boolean passed = YES;
        int e;
        for(e=0;e<[points count];e++){
            if(e==i){
                continue;
            }
            CGPoint P = [(NSValue*)[points objectAtIndex:e] CGPointValue];
            if([self PointInTriangle:A :B :C :P]==YES){
                passed = NO;
                break;
            }
        }
        if(passed){
            return i;
        }
    }
    NSLog(@"Find ear failed!!! For blobcount %d",[points count]);
    return -1;
}

- (NSMutableArray*) RemoveCoLinearPoints:(NSMutableArray*) points{

    int i=0;
    NSMutableArray* pointsToRemove = [[NSMutableArray alloc] init];

    for(i=0;i<[points count];i++){
        int j;
        for(j=0;j<5 && i+j<[points count];j++){
            [pointsToRemove addObject:[points objectAtIndex:i+j]];            
        }
        i+=j;
    }
    
    for(NSValue* point in pointsToRemove){
        [points removeObject:point];
    }
    [pointsToRemove release];
    NSLog(@"Removed %d points, final polygon with %d",i,[points count]);

    return points;
}

- (NSMutableArray*) ExtractEars:(NSMutableArray*) points{
    int v0=0, v1=1, v2=2,i=0;
    NSMutableArray* vertexes = [[NSMutableArray alloc] init];
    for(i=0;i<[points count];i++){
        if(i==0){
            v0=[points count]-1;
        }else{
            v0 = i-1;
        }
        v1 = i;
        if(i==[points count]-1){
            v2=0;
        }else{
            v2 = i+1;
        }
        
        
        CGPoint A = [(NSValue*)[points objectAtIndex:v0] CGPointValue];
        CGPoint B = [(NSValue*)[points objectAtIndex:v1] CGPointValue];
        CGPoint C = [(NSValue*)[points objectAtIndex:v2] CGPointValue];
        
        CGPoint BA = ccpSub(A, B);
        CGPoint BC = ccpSub(C, B);
        float angle = ccpAngle(BC, BA);
        if(angle>=M_PI){
            continue;
        }
        
        Boolean passed = YES;
        int e;
        for(e=0;e<[points count];e++){
            if(e==i){
                continue;
            }
            CGPoint P = [(NSValue*)[points objectAtIndex:e] CGPointValue];
            if([self PointInTriangle:A :B :C :P]==YES){
                passed = NO;
                break;
            }
        }
        if(passed){
            [vertexes addObject:[points objectAtIndex:v1]];
            i++;
        }
    }
    return vertexes;
}

- (NSMutableArray*) TransformToPolygons:(NSMutableArray*) points{
    // Only compute polygone if polygon has enought points
    if([points count]<MINIMUM_POINTS_IN_POLYGON){
        return NULL;
    }
    int startPoint = -1;

    NSMutableArray* polygons = [[NSMutableArray alloc] init];
    
    NSMutableArray* polygon;
    
    points = [self RemoveCoLinearPoints:points];
    
    
//    float EPSILON = 1;
    NSLog(@"Transforming total of %d points to poligons",[points count]);
    int A =0;
    int B =0;
    int C =0;
    while([points count]>3){
        if(startPoint==-1 || startPoint>=[points count]){
            startPoint = [self findEar:points:0];
            if(startPoint==-1){
                break;
            }
        }
        
        if(startPoint>=0){
            A = (startPoint-1>=0 ? startPoint-1 : [points count]-1);
            B = startPoint;
            C = (startPoint+1<[points count] ? startPoint+1 : 0);
        }
        

        
        polygon = [[NSMutableArray alloc] init];
        CGPoint pa = [(NSValue*)[points objectAtIndex:A] CGPointValue];
        CGPoint pb = [(NSValue*)[points objectAtIndex:B] CGPointValue];
        CGPoint pc = [(NSValue*)[points objectAtIndex:C] CGPointValue];
        
        CGPoint BA = ccp(pa.x-pb.x,pa.y-pb.y);
        CGPoint BC = ccp(pc.x-pb.x,pc.y-pb.y);
        

        
        [polygon addObject:[points objectAtIndex:A]];
        [polygon addObject:[points objectAtIndex:B]];
        [polygon addObject:[points objectAtIndex:C]];        
        
        [points removeObjectAtIndex:B];
       
        [polygons addObject:polygon];

        startPoint = [self findEar:points :A];            
        
        
    }
    
    return polygons;
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
