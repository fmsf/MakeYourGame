//
//  EarClipper.m
//  MakeYourGame
//
//  Created by Francisco M. Silva Ferreira on 5/17/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "EarClipper.h"

@implementation EarClipper

+ (float) CrossArea:(CGPoint) A:(CGPoint) B: (CGPoint) C{
    //return abs(A.x*B.y+B.x*C.y+C.x*A.y-A.x*C.y-C.x*B.y-B.x*A.y)/2;
    CGPoint a = A;
    CGPoint b = B;
    CGPoint c = C;
    float ab = sqrt((a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y));
    float ac = sqrt((a.x-c.x)*(a.x-c.x)+(a.y-c.y)*(a.y-c.y));
    float bc = sqrt((b.x-c.x)*(b.x-c.x)+(b.y-c.y)*(b.y-c.y));
}

- (Boolean) PointInTriangle:(CGPoint) A:(CGPoint) B: (CGPoint) C: (CGPoint) P{
    float ABC = [EarClipper CrossArea:A :B :C];
    
    float ABP = [EarClipper CrossArea:A :B :P];
    float ACP = [EarClipper CrossArea:A :C :P];
    float BCP = [EarClipper CrossArea:B :C :P];
    float acceptedFloatingPointErrorMargin = 0.000001;
    if(abs(ABC-(ABP+ACP+BCP))<acceptedFloatingPointErrorMargin){
        return NO;
    }else{
//        NSLog(@"-> area ->  %f",ABC);
        return YES;
    }
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
        Boolean passed = YES;
        int e;
        for(e=0;e<[points count];e++){
            if(e==i){
                continue;
            }
            CGPoint P = [(NSValue*)[points objectAtIndex:e] CGPointValue];
            if([self PointInTriangle:A :B :C :P]==YES){
                NSLog(@"i=%d e=%d",i,e);
                NSLog(@"a.x=%f a.y=%f",A.x,A.y);
                NSLog(@"b.x=%f b.y=%f",B.x,B.y);
                NSLog(@"c.x=%f c.y=%f",C.x,C.y);
                NSLog(@"p.x=%f p.y=%f",P.x,P.y);
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
    /*CGPoint current_point;
    CGPoint first_point;
    float m=0;
    float errorMargin = 0;
    Boolean f=false,c=false;*/
    int i=0;
    NSMutableArray* pointsToRemove = [[NSMutableArray alloc] init];
  /*  for(NSValue* point in points){
        if(!f){
            f=true;
            first_point = [point CGPointValue];
        }else{
            current_point = [point CGPointValue];
            if(!c){
                m = (first_point.y-current_point.y)/(first_point.x-current_point.x);
                if(m>-100000){
                    c=true;
                }
            }else{
                float candidate_m = (first_point.y-current_point.y)/(first_point.x-current_point.x);
                NSLog(@"%f %f",m,candidate_m);
                if(abs(m-candidate_m)<=errorMargin || candidate_m<-1000000){
                    [pointsToRemove addObject:point];
                    i++;
                }else{
                    m=candidate_m;
                    first_point = current_point;
                    c=false;
                }
            }
        }
    }*/
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

- (NSMutableArray*) TransformToPolygons:(NSMutableArray*) points{
    // Only compute polygone if polygon has enought points
    if([points count]<MINIMUM_POINTS_IN_POLYGON){
        return NULL;
    }
    int startPoint = -1;

    NSMutableArray* polygons = [[NSMutableArray alloc] init];
    
    NSMutableArray* polygon;
    
    points = [self RemoveCoLinearPoints:points];
    
    
    float EPSILON = 1;
    NSLog(@"%d",[points count]);
    int A =0;
    int B =0;
    int C =0;
    while([points count]>3){
        if(startPoint==-1){
            startPoint = [self findEar:points:0];
            if(startPoint==-1){
                break;
            }
        }
        
        if(startPoint>=0){
            A = (startPoint-1>=0 ? startPoint-1 : [points count]-1);
            B = startPoint;
            C = (startPoint+1<[points count] ? startPoint+1 : 0);
        }else{
            NSLog(@"aaaaaaaaaa");
        }
        NSLog(@"A=%d, B=%d, c=%d",A,B,C);
        polygon = [[NSMutableArray alloc] init];
        CGPoint pa = [(NSValue*)[points objectAtIndex:A] CGPointValue];
        CGPoint pb = [(NSValue*)[points objectAtIndex:B] CGPointValue];
        CGPoint pc = [(NSValue*)[points objectAtIndex:C] CGPointValue];
        [polygon addObject:[points objectAtIndex:A]];
        [polygon addObject:[points objectAtIndex:B]];
        [polygon addObject:[points objectAtIndex:C]];
        NSLog(@"a.x = %f a.y=%f",pa.x,pa.y);
        NSLog(@"b.x = %f b.y=%f",pb.x,pb.y);
        NSLog(@"c.x = %f c.y=%f",pc.x,pc.y);
        
        
        [points removeObjectAtIndex:B];
        NSLog(@"removed %d",B);
       
        [polygons addObject:polygon];

        startPoint = [self findEar:points :A];            
        NSLog(@"%d",startPoint);
        
        
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
