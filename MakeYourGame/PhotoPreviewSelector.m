//
//  PhotoPreviewSelector.m
//  MakeYourGame
//
//  Created by Francisco M. Silva Ferreira on 5/6/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "PhotoPreviewSelector.h"


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
        sprite.position = ccp(240,160);
        [self addChild:sprite];
    }else{
        [sprite setTexture:[controller getTexture]];   
        
    }
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Deactivating controller");
    [controller deactivate];
    NSLog(@"Doing trace");
    [detector doTrace];
    traced = YES;
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method

    
	// don't forget to call "super dealloc"
	[super dealloc];
}


@end
