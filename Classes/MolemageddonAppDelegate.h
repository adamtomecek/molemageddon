//
//  MolemageddonAppDelegate.h
//  Molemageddon
//
//  Created by Adam Tomeček on 6/8/11.
//  Copyright OwnSoft 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthTwitterDemoViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import "FBConnect.h"

@class RootViewController;
@class SA_OAuthTwitterEngine;

@interface MolemageddonAppDelegate : NSObject <UIApplicationDelegate, SA_OAuthTwitterControllerDelegate, FBSessionDelegate,  FBDialogDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
	SA_OAuthTwitterEngine *_engine;
	UIViewController *ctrl;
	
	Facebook *facebook;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) Facebook *facebook;

-(void) twitterAccountLogin:(NSString *)message;
-(void) facebookAccountLogin:(NSString *)message;

@end
