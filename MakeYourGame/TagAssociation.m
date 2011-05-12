//
//  TagAssociation.m
//  blobdetector
//
//  Created by Francisco M. Silva Ferreira on 5/1/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "TagAssociation.h"


@implementation TagAssociation


- (void) addTag:(int) tag{
    if(totalAssociations<MAX_ASSOCIATIONS){
        association[totalAssociations++]=tag;
    }
}

- (int) getMainTag{
    return parentTag;
}

- (Boolean) checkIfAssociated:(int) tag{
    for(int i=0;i<totalAssociations;i++){
        if(tag==association[i]){
            return true;
        }
    }
    return false;
}

-(id) initWithMainTag:(int)tag{
    if( (self=[super init])) {
        parentTag = tag;        
        totalAssociations = 0;
	}
	return self;
}

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
