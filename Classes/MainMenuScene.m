//
//  MainMenuScene.m
//  Molemageddon
//
//  Created by Adam Tomeček on 6/8/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import "MainMenuScene.h"
#import "SettingsScene.h"
#import "PlayMenuScene.h"
#import "Settings.h"
#import "MolemageddonAppDelegate.h"
#import "CCVideoPlayer.h"
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>



@implementation MainMenuScene

BOOL settings = NO;

+ (id) scene{
	CCScene *scene = [CCScene node];
	
	MainMenuScene *layer = [MainMenuScene node];
	
	[scene addChild: layer];
	
	return scene;
}

- (id) init{	
	if ( (self = [super init]) ) {
		Settings *settings = [Settings sharedSettings];
		
		if ([settings.intro boolValue]) {
			[self createMenu];
		}else {
			settings.intro = [NSNumber numberWithBool:YES];
			[settings saveSettings];
			
			NSBundle *bundle = [NSBundle mainBundle];
			NSString *moviePath = [bundle pathForResource:@"intro" ofType:@"m4v"];
			NSURL *movieURL = [[NSURL fileURLWithPath:moviePath] retain];
			videoController = [[MovieViewController alloc] init];
			[[[CCDirector sharedDirector] openGLView] addSubview:videoController.view];
			[videoController initAndPlayMovie:movieURL layer:self];
		}
	}
	
	return self;
}

- (void)createMenu{
	CCSpriteFrameCache *menuCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	[menuCache addSpriteFramesWithFile:@"menu.plist"];
	
	CCSprite *playButtonSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_play_static.png"];
	CCSprite *playButtonSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_play_active.png"];
	
	CCSprite *settingsButtonSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_settings_static.png"];
	CCSprite *settingsButtonSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_settings_active.png"];
	
	CCSprite *aboutButtonSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_about_static.png"];
	CCSprite *aboutButtonSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_about_active.png"];
	
	CCMenuItemSprite *playButton = [CCMenuItemSprite itemFromNormalSprite:playButtonSpriteStatic selectedSprite:playButtonSpriteActive target:self selector:@selector(playButtonTouched)];
	CCMenuItemSprite *settingsButton = [CCMenuItemSprite itemFromNormalSprite:settingsButtonSpriteStatic selectedSprite:settingsButtonSpriteActive target:self selector:@selector(settingsButtonTouched)];
	CCMenuItemSprite *aboutButton = [CCMenuItemSprite itemFromNormalSprite:aboutButtonSpriteStatic selectedSprite:aboutButtonSpriteActive target:self selector:@selector(aboutButtonTouched)];
	
	CCMenu *menu = [CCMenu menuWithItems:playButton, settingsButton, aboutButton, nil];
	
	[menu alignItemsVerticallyWithPadding:10];
	
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	menu.position = ccp(screenSize.width / 2,
								150);
	
	CCSprite *pozadi = [CCSprite spriteWithFile:@"pozadi_menu_hlavni.png"];
	pozadi.position = ccp([pozadi texture].contentSize.width / 2, [pozadi texture].contentSize.height / 2);
	[self addChild:pozadi];							
	
	[self addChild:menu];	
}

#pragma mark -
#pragma mark Callbacks
- (void) movieFinishedCallback {
	for (id subView in [[[CCDirector sharedDirector] openGLView] subviews]) {
		[(UIView *) subView removeFromSuperview];
	}
	
	[self createMenu];
}

- (void) playButtonTouched{
	if (!settings) {
		[[CCDirector sharedDirector] replaceScene:[PlayMenuScene scene]];
	}
}

- (void) settingsButtonTouched{
	if (!settings) {
		SettingsScene *scene = [SettingsScene node];
		[self addChild:scene z:2 tag:kSettingsScene];
		settings = YES;
	}
}

- (void) aboutButtonTouched{		
	
}

- (void) settingsClosed{
	[self removeChildByTag:kSettingsScene cleanup:YES];
	settings = NO;
}

@end
