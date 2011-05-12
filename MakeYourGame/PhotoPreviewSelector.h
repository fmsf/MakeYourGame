//
//  PhotoPreviewSelector.h
//  MakeYourGame
//
//  Created by Francisco M. Silva Ferreira on 5/6/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CameraController.h"
#import "Detector.h"

@interface PhotoPreviewSelector : CCLayer {
    CameraController *controller;
    Detector *detector;
    CCSprite* sprite;
    
    Boolean spriteToAdd;
    Boolean traced;
}

+(CCScene *) scene;


@end
