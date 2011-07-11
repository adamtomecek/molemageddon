//
//  MolemageddonAppDelegate.m
//  Molemageddon
//
//  Created by Adam Tomeček on 6/8/11.
//  Copyright OwnSoft 2011. All rights reserved.
//

#import "cocos2d.h"

#import "MolemageddonAppDelegate.h"
#import "GameConfig.h"
#import "MainMenuScene.h"
#import "RootViewController.h"
#import "Settings.h"
#import "SA_OAuthTwitterEngine.h"
#import "OAuthTwitterDemoViewController.h"

#define kOAuthConsumerKey				@"Wu1qjzsc8bEPbQOurT83Dg"		//REPLACE ME
#define kOAuthConsumerSecret			@"kjaEvxbAdIVZzBxw0c8TxJVVXopo2qPZ0J7jffm4A"		//REPLACE ME
#define kFacebookAppId					@"158795990857919"


@implementation MolemageddonAppDelegate

@synthesize window;
@synthesize facebook;


- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}
- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
//	if( ! [director enableRetinaDisplay:YES] )
//		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	Settings *settings = [[Settings alloc] init];
	
	facebook = [[Facebook alloc] initWithAppId:kFacebookAppId];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
	}
	
	window.rootViewController = viewController;
	
	[window makeKeyAndVisible];
	
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [MainMenuScene scene]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	Settings *settings = [Settings sharedSettings];
	[settings saveSettings];
	
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)facebookAccountLogin:(NSString *)message{
	if (![facebook isSessionValid]) {
		[facebook authorize:nil delegate:self];
	}else {
		NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									   kFacebookAppId, @"app_id",
									   @"http://www.molemageddon.com", @"link",
									   @"http://www.molemageddon.com/images/logo.png", @"picture",
									   @"Molemageddon", @"name",
									   @"Addictive iPhone game with beautiful handmade graphics", @"description",
									   message,  @"message",
  nil];
		
		[facebook dialog:@"stream.publish" andParams:params andDelegate:self];
	}
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [facebook handleOpenURL:url]; 
}

- (void)dialogDidComplete:(FBDialog *)dialog{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook share" message:@"Your score was successfully shared to your Facebook wall." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
	[alert show];
	[alert release];
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook authentication" message:@"Molemageddon was successfully connected with your Facebook account. You can now share your score." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
	[alert show];
	[alert release];

}

- (void)twitterAccountLogin:(NSString *)message
{
		// if engine logged out before, create new engine:
	if (_engine == nil){
		NSLog(@"creating engine");
		_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
		_engine.consumerKey = kOAuthConsumerKey;
		_engine.consumerSecret = kOAuthConsumerSecret;
	}
	
		// ask if engine is authorized
	if(![_engine isAuthorized])
	{
		UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
		
		if (controller) {
			[viewController presentModalViewController: controller animated: YES];
		}
	}
	else {
		NSLog(@"authenticated and ready to sendUpdate!!!!!");
		
		[_engine sendUpdate: message];
	}
}
	//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
	
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
	
}

	//=============================================================================================================================

#pragma mark SA_OAuthTwitterControllerDelegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	
	NSLog(@"Authenicated for %@", username);
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter authentication" message:@"You was successfully authenticated. You can now share your score!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
	[alert show];
	[alert release];
		//[ctrl dismissModalViewControllerAnimated:YES];
		//[ctrl.view removeFromSuperview];
		//[ctrl release];
		//[[CCDirector sharedDirector] resume];

}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	
	NSLog(@"Authentication Failed!");
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter authentication" message:@"Authentication failed. Try again please!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
	[alert show];
	[alert release];
	
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	
	NSLog(@"Authentication Canceled.");
	
}

	//=============================================================================================================================

#pragma mark TwitterEngineDelegate

- (void) requestSucceeded: (NSString *) requestIdentifier {
	
	NSLog(@"Request %@ succeeded", requestIdentifier);
	
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);

}

- (void)dealloc {
	[facebook release];
	facebook = nil;
	
	[_engine release];
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
