//
//  Triangulate.h
//  MakeYourGame
//
//  Created by Francisco M. Silva Ferreira on 7/11/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Triangulate : NSObject {
    
}

+ (NSMutableArray*) Process:(NSMutableArray*) contour;
+ (float) Area:(NSMutableArray*) contour;
+ (Boolean) InsideTriangle:(float) Ax :(float) Ay :(float) Bx :(float) By :(float) Cx :(float) Cy :(float) Px :(float)Py;
+ (Boolean) Snip:(NSMutableArray*) contour :(int) u :(int) v :(int) w :(int) n :(int*) V;
+ (NSMutableArray*) RemoveCoLinearPoints:(NSMutableArray*) points;


@end
