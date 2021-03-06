//
//  PauseMenu.m
//  Molemageddon
//
//  Created by Adam Tomeček on 7/21/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import "PauseMenu.h"
#import "GameScene.h"
#import "MainMenuScene.h"
#import "SettingsScene.h"
#import "Settings.h"

#define kPauseMenu 102

@implementation PauseMenu

BOOL settingsOpen = NO;

+ (id) scene{
	CCScene *scene = [CCScene node];
	
	PauseMenu *layer = [PauseMenu node];
	
	[scene addChild: layer];
	
	return scene;
}

- (id) init{	
	CCSpriteFrameCache *menuCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	[menuCache addSpriteFramesWithFile:@"menu.plist"];
	
	if ( (self = [super init]) ) {
		CCSprite *continueButtonSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_continue_static.png"];
		CCSprite *continueButtonSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_continue_active.png"];
		
		CCSprite *settingsButtonSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_settings_static.png"];
		CCSprite *settingsButtonSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_settings_active.png"];
		
		CCSprite *mainmenuButtonSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_mainmenu_static.png"];
		CCSprite *mainmenuButtonSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_mainmenu_active.png"];
		
		CCMenuItemSprite *continueButton = [CCMenuItemSprite itemFromNormalSprite:continueButtonSpriteStatic selectedSprite:continueButtonSpriteActive target:self selector:@selector(continueButtonTouched)];
		
		CCMenuItemSprite *settingsButton = [CCMenuItemSprite itemFromNormalSprite:settingsButtonSpriteStatic selectedSprite:settingsButtonSpriteActive target:self selector:@selector(settingsButtonTouched)];
		
		CCMenuItemSprite *mainmenuButton = [CCMenuItemSprite itemFromNormalSprite:mainmenuButtonSpriteStatic selectedSprite:mainmenuButtonSpriteActive target:self selector:@selector(mainmenuButtonTouched)];
		
		
		CCMenu *menu = [CCMenu menuWithItems:continueButton, settingsButton, mainmenuButton, nil];
		[menu alignItemsVerticallyWithPadding:8];
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		menu.position = CGPointMake(screenSize.width / 2, 300);
		
		[self addChild:menu z:1 tag:kPauseMenu];
	}
	
	return self;
}

- (void) settingsClosed{
	[self removeChildByTag:kSettingsScene cleanup:YES];
	settingsOpen = NO;
	
	CCMenu *menu = (CCMenu *)[self getChildByTag:kPauseMenu];
	menu.visible = YES;
}

- (void) continueButtonTouched{
	if (!settingsOpen) {
		GameScene *gameScene = [GameScene sharedGameScene];
		[gameScene pauseOver];
	}
}

- (void) settingsButtonTouched{
	if (!settingsOpen) {
		SettingsScene *scene = [SettingsScene node];
		[self addChild:scene z:10 tag:kSettingsScene];
		settingsOpen = YES;
		
		CCMenu *menu = (CCMenu *)[self getChildByTag:kPauseMenu];
		menu.visible = NO;
	}
}

- (void) mainmenuButtonTouched{
	if (!settingsOpen) {
		GameScene *gameScene = [GameScene sharedGameScene];
		[gameScene mainMenuButtonTouched];
	}
}

@end
