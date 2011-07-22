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

#define kSettingsScene 15

@implementation PauseMenu

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
		[menu alignItemsVerticallyWithPadding:20];
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		menu.position = CGPointMake(screenSize.width / 2, 300);
		
		[self addChild:menu];
	}
	
	return self;
}

- (void) continueButtonTouched{
	GameScene *gameScene = [GameScene sharedGameScene];
	[gameScene pauseOver];
}

- (void) settingsButtonTouched{
	SettingsScene *scene = [SettingsScene scene];
	[self addChild:scene z:10 tag:kSettingsScene];
}

- (void) mainmenuButtonTouched{
	GameScene *gameScene = [GameScene sharedGameScene];
	[gameScene mainMenuButtonTouched];
}

@end
