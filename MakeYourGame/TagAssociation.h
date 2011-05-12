//
//  TagAssociation.h
//  blobdetector
//
//  Created by Francisco M. Silva Ferreira on 5/1/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_ASSOCIATIONS 256

@interface TagAssociation : NSObject {
    int totalAssociations;
    int association[MAX_ASSOCIATIONS];
    int parentTag;
}


-(id) initWithMainTag:(int)tag;
- (Boolean) checkIfAssociated:(int) tag;
- (int) getMainTag;
- (void) addTag:(int) tag;




@end
