//
//  GamePolygon.m
//  MakeYourGame
//
//  Created by Francisco M. Silva Ferreira on 5/24/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "GamePolygon.h"


@implementation GamePolygon


// on "init" you need to initialize your instance
-(id) init{
	if( (self=[super init])) {        
        
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [polygon release];
	[super dealloc];
}

@end
