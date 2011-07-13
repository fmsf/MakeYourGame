//
//  PhotoPreviewSelector.m
//  MakeYourGame
//
//  Created by Francisco M. Silva Ferreira on 5/6/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "PhotoPreviewSelector.h"
#import "HelloWorldLayer.h"


@implementation PhotoPreviewSelector

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PhotoPreviewSelector *layer = [PhotoPreviewSelector node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// enable touches
		self.isTouchEnabled = YES;
        
        controller = [[CameraController alloc] init];
        detector = [[Detector alloc] init];
        
        [controller setDetector: detector];
        [controller activate];
        
        spriteToAdd = true;
		
        polygons = NULL;
        [self schedule:@selector(tick:) interval:0.05];

	}
	return self;
}

- (void)tick:(ccTime) dt {
    if([controller getTexture]==NULL){
        return;
    }
    

    if(spriteToAdd){
        spriteToAdd = false;
        sprite = [CCSprite spriteWithTexture:[controller getTexture]];
        sprite.position = ccp(540,460);
        sprite.scale = 2.0f;
        [self addChild:sprite];
    }else{
        [sprite setTexture:[controller getTexture]];   
        
    }
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(traced){
//        [controller activate];
//        traced = NO;
        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene:polygons]];
    }else{        
        if(polygons!=NULL){
            [polygons release];
        }
        NSLog(@"Deactivating controller");
        [controller deactivate];
        NSLog(@"Doing trace");
        //[detector doTrace];
        //EarClipper* clipper = [[EarClipper alloc] init];
        if(polygons!=NULL){
            [polygons release];
        }
        polygons = [[NSMutableArray alloc] init];
        for(NSMutableArray* points in [detector getBlobs]){
            NSMutableArray* candidate = [Triangulate Process:points];//[clipper TransformToPolygons:points];
            if(candidate!=nil){
                [polygons addObject:candidate];
            }
        }
        traced = YES;
        
        
    }
    
}

- (void) draw{
    if(polygons!=NULL){
        glColor4f(0.8, 1.0, 0.76, 0.3);  
		glLineWidth(1.0f);
        
        for(NSMutableArray* polyList in polygons){
            for(NSMutableArray* polygon in polyList){
                CGPoint A = [((NSValue*)[polygon objectAtIndex:0]) CGPointValue];
                CGPoint B = [((NSValue*)[polygon objectAtIndex:1]) CGPointValue];
                CGPoint C = [((NSValue*)[polygon objectAtIndex:2]) CGPointValue];
                
                ccDrawLine(A,B);
                ccDrawLine(A,C);
                ccDrawLine(B,C);
            }
            
        }
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method

    
	// don't forget to call "super dealloc"
	[super dealloc];
}


@end
