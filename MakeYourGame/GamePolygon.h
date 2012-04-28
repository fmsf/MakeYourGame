//
//  GamePolygon.h
//  MakeYourGame
//
//  Created by Francisco M. Silva Ferreira on 5/24/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface GamePolygon : NSObject {
    NSMutableArray* polygon;
    CCSprite* sprite;
    
}

- (void) SetPolyon:(NSMutableArray*) Polygon;

@end
