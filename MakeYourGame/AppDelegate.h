//
//  AppDelegate.h
//  MakeYourGame
//
//  Created by Francisco M. Silva Ferreira on 5/6/11.
//  Copyright Student 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
