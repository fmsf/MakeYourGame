//
//  Triangulate.m
//  MakeYourGame
//
//  Created by Francisco M. Silva Ferreira on 7/11/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "Triangulate.h"
#import "cocos2d.h"

#define EPSILON 0.0000000001f

@implementation Triangulate

+ (float) Area:(NSMutableArray*) contour{
    int n = [contour count];
    
    float A = 0.0f;
    for(int p=n-1, q=0; q<n;p=q++){
        CGPoint P = [((NSValue*) [contour objectAtIndex:p]) CGPointValue];
        CGPoint Q = [((NSValue*) [contour objectAtIndex:q]) CGPointValue];
        A+=P.x*Q.y - Q.x*P.y;
    }
    return A*0.5f;
}


+ (Boolean) InsideTriangle:(float) Ax :(float) Ay :(float) Bx :(float) By :(float) Cx :(float) Cy :(float) Px :(float)Py{
    float ax, ay, bx, by, cx, cy, apx, apy, bpx, bpy, cpx, cpy;
    float cCROSSap, bCROSScp, aCROSSbp;
    
    ax = Cx - Bx;  ay = Cy - By;
    bx = Ax - Cx;  by = Ay - Cy;
    cx = Bx - Ax;  cy = By - Ay;
    apx= Px - Ax;  apy= Py - Ay;
    bpx= Px - Bx;  bpy= Py - By;
    cpx= Px - Cx;  cpy= Py - Cy;
    
    aCROSSbp = ax*bpy - ay*bpx;
    cCROSSap = cx*apy - cy*apx;
    bCROSScp = bx*cpy - by*cpx;
    
    return ((aCROSSbp >= 0.0f) && (bCROSScp >= 0.0f) && (cCROSSap >= 0.0f));
}


+ (Boolean) Snip:(NSMutableArray*) contour :(int) u :(int) v :(int) w :(int) n :(int*) V{
    int p;
    float Ax, Ay, Bx, By, Cx, Cy, Px, Py;
    
    CGPoint A = [((NSValue*) [contour objectAtIndex:V[u]]) CGPointValue];
    CGPoint B = [((NSValue*) [contour objectAtIndex:V[v]]) CGPointValue];
    CGPoint C = [((NSValue*) [contour objectAtIndex:V[w]]) CGPointValue];
    
    
    Ax = A.x;
    Ay = A.y;
    
    Bx = B.x;
    By = B.y;
    
    Cx = C.x;
    Cy = C.y;
    
    if ( EPSILON > (((Bx-Ax)*(Cy-Ay)) - ((By-Ay)*(Cx-Ax))) ) return false;
    
    for (p=0;p<n;p++){
        if( (p == u) || (p == v) || (p == w) ) continue;

        CGPoint P = [((NSValue*) [contour objectAtIndex:V[p]]) CGPointValue];
        Px = P.x;
        Py = P.y;
        if ([Triangulate InsideTriangle:Ax:Ay:Bx:By:Cx:Cy:Px:Py]) return false;
    }
    
    return true;
}

+ (NSMutableArray*) RemoveCoLinearPoints:(NSMutableArray*) points{
    
    int i=0;
    NSMutableArray* pointsToRemove = [[NSMutableArray alloc] init];
    
    for(i=0;i<[points count];i++){
        int j;
        for(j=0;j<10 && i+j<[points count];j++){
            [pointsToRemove addObject:[points objectAtIndex:i+j]];            
        }
        i+=j;
    }
    
    for(NSValue* point in pointsToRemove){
        [points removeObject:point];
    }
    [pointsToRemove release];
    NSLog(@"Removed %d points, final polygon with %d",i,[points count]);
    
   /* // Reversing
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[points count]];
    NSEnumerator *enumerator = [points reverseObjectEnumerator];
    for(id element in enumerator){
        [array addObject:element];
    }
    [points release];
    points = array;*/
    return points;
}

+ (NSMutableArray*) Process:(NSMutableArray*) contour{
    
    contour = [Triangulate RemoveCoLinearPoints:contour];
    
    NSMutableArray* triangles = [[NSMutableArray alloc] init];
    
    int n= [contour count];
    
    if (n<3) return NULL;
    
    int *V = (int*)malloc(sizeof(int)*n);
    
    if(0.0f < [Triangulate Area:contour]){
        for (int v=0;v<n;v++) V[v] = v;
    }else{
        for (int v=0;v<n;v++) V[v] = (n-1)-v;
    }
    
    int nv = n;
    
    int count = 2*nv;
    
    for(int m=0, v=nv-1;nv>2;){
        if(0>=(count--)){
            return NULL; // LOOPING
        }
        
        int u = v  ; if (nv <= u) u = 0;     /* previous */
        v = u+1; if (nv <= v) v = 0;     /* new v    */
        int w = v+1; if (nv <= w) w = 0;     /* next     */
        
        if([Triangulate Snip:contour :u :v :w :nv :V]){
            int a,b,c,s,t;
            
            a = V[u];
            b = V[v];
            c = V[w];
            
            
            NSMutableArray *polygon = [[NSMutableArray alloc] init];
            [polygon addObject:[contour objectAtIndex:a]];
            [polygon addObject:[contour objectAtIndex:b]];
            [polygon addObject:[contour objectAtIndex:c]];
            [triangles addObject:polygon];
            
            m++;
            
            for(s=v,t=v+1;t<nv;s++,t++) V[s] = V[t]; nv--;
            
            /* resest error detection counter */
            count = 2*nv;
        }
    
    
    }
        
       
    free(V);
    return triangles;
}






@end
