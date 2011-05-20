//
//  EarClipper.m
//  MakeYourGame
//
//  Created by Francisco M. Silva Ferreira on 5/17/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "EarClipper.h"

@implementation EarClipper

- (float) CrossArea:(CGPoint) A:(CGPoint) B: (CGPoint) C{
    return abs(A.x*B.y+B.x*C.y+C.x*A.y-A.x*C.y-C.x*B.y-B.x*A.y)/2;
}

- (Boolean) PointInTriangle:(CGPoint) A:(CGPoint) B: (CGPoint) C: (CGPoint) P{
    float ABC = [self CrossArea:A :B :C];
    
    float ABP = [self CrossArea:A :B :P];
    float ACP = [self CrossArea:A :C :P];
    float BCP = [self CrossArea:B :C :P];
    float acceptedFloatingPointErrorMargin = 0.000001;
    if(abs(ABC-(ABP+ACP+BCP))<acceptedFloatingPointErrorMargin){
        return NO;
    }else{
        return YES;
    }
}

- (int) findEar:(NSMutableArray*) points{
    int v0=0, v1=1, v2=2;
    for(int i=0;i<[points count];i++){
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
        for(int e=i+1;e<[points count];e++){
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
    CGPoint current_point;
    CGPoint first_point;
    float m=0;
    float errorMargin = 0;
    Boolean f=false,c=false;
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
    for(int i=0;i<[points count];i+=2){
        int j;
        for(j=0;j<3 && i+j<[points count];j++){
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
    int startPoint = -1;

    NSMutableArray* polygons = [[NSMutableArray alloc] init];
    
    NSMutableArray* polygon;
    
    points = [self RemoveCoLinearPoints:points];
    
    while([points count]>3){
        if(startPoint==-1){
            startPoint = [self findEar:points];
            if(startPoint==-1){
                break;
            }
        }
        
        
        
        
        int A = (startPoint-1>=0 ? startPoint-1 : [points count]-1);
        int B = startPoint;
        int C = (startPoint+1<[points count] ? startPoint+1 : 0);
        
        polygon = [[NSMutableArray alloc] init];
        [polygon addObject:[points objectAtIndex:A]];
        [polygon addObject:[points objectAtIndex:B]];
        [polygon addObject:[points objectAtIndex:C]];
//        NSLog(@"%d %d %d",A,B,C);
        [points removeObjectAtIndex:B];
        
        [polygons addObject:polygon];
        
        startPoint = -1; // TODO: cache values
        
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
