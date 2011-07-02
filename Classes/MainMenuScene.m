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


@implementation MainMenuScene

+ (id) scene{
	CCScene *scene = [CCScene node];
	
	MainMenuScene *layer = [MainMenuScene node];
	
	[scene addChild: layer];
	
	return scene;
}

- (id) init{
	CCSpriteFrameCache *menuCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	[menuCache addSpriteFramesWithFile:@"menu.plist"];
	
	if ( (self = [super init]) ) {
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
		
		menu.position = CGPointMake(screenSize.width / 2,
					150);
		
		CCSprite *pozadi = [CCSprite spriteWithFile:@"pozadi_menu_hlavni.png"];
		pozadi.position = ccp([pozadi texture].contentSize.width / 2, [pozadi texture].contentSize.height / 2);
		[self addChild:pozadi];							
		
		[self addChild:menu];
		
	}
	
	return self;
}

- (void) playButtonTouched{
	[[CCDirector sharedDirector] replaceScene:[PlayMenuScene scene]];
}

- (void) settingsButtonTouched{
	[[CCDirector sharedDirector] replaceScene:[SettingsScene scene]];
}

- (void) aboutButtonTouched{		
	id appDelegate = [[UIApplication sharedApplication] delegate];
	
	NSString *message = [NSString stringWithFormat:@"I've just ousted %d moles in iPhone game Molemageddon. Can you do better?", 25];
	
	[appDelegate facebookAccountLogin:message];
}

@end
