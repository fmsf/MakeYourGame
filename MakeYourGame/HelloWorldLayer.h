//
//  HelloWorldLayer.h
//  MakeYourGame
//
//  Created by Francisco M. Silva Ferreira on 5/6/11.
//  Copyright Student 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    NSMutableArray* Polygons;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
+(CCScene *) scene:(NSMutableArray*)polygonList;

// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;
- (void) BuildPolygon:(NSMutableArray*) PolygonList;


@end
