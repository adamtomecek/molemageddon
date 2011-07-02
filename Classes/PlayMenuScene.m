//
//  PlayMenuScene.m
//  Molemageddon
//
//  Created by Adam Tomeček on 6/16/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import "PlayMenuScene.h"
#import "GameScene.h"
#import "LocationScene.h"
#import "MainMenuScene.h"
#import "Settings.h"
#import "StoryScene.h"


@implementation PlayMenuScene

+ (id) scene{
	CCScene *scene = [CCScene node];
	
	PlayMenuScene *layer = [PlayMenuScene node];
	
	[scene addChild: layer];
	
	return scene;
}

- (id) init{
	Settings *settings = [Settings sharedSettings];
	
	CCSpriteFrameCache *menuCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	[menuCache addSpriteFramesWithFile:@"menu.plist"];
	
	if ( (self = [super init]) ) {
		CCSprite *continueButtonSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_continue_static.png"];
		CCSprite *continueButtonSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_continue_active.png"];
		
		CCSprite *newstoryButtonSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_newstory_static.png"];
		CCSprite *newstoryButtonSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_newstory_active.png"];
		
		CCSprite *classicButtonSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_classic_static.png"];
		CCSprite *classicButtonSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_classic_active.png"];
		
		CCSprite *timeattackButtonSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_timeattack_static.png"];
		CCSprite *timeattackButtonSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_timeattack_active.png"];
		
		CCSprite *molemadnessButtonSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_molemadness_static.png"];
		CCSprite *molemadnessButtonSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_molemadness_active.png"];
		
		CCSprite *backButtonSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_back_static.png"];
		CCSprite *backButtonSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_back_active.png"];
		
		CCMenuItemSprite *continueButton = [CCMenuItemSprite itemFromNormalSprite:continueButtonSpriteStatic selectedSprite:continueButtonSpriteActive target:self selector:@selector(continueButtonTouched)];
		
		CCMenuItemSprite *newstoryButton = [CCMenuItemSprite itemFromNormalSprite:newstoryButtonSpriteStatic selectedSprite:newstoryButtonSpriteActive target:self selector:@selector(newstoryButtonTouched)];
		
		CCMenuItemSprite *classicButton = [CCMenuItemSprite itemFromNormalSprite:classicButtonSpriteStatic selectedSprite:classicButtonSpriteActive target:self selector:@selector(classicButtonTouched)];
		
		CCMenuItemSprite *timeattackButton = [CCMenuItemSprite itemFromNormalSprite:timeattackButtonSpriteStatic selectedSprite:timeattackButtonSpriteActive target:self selector:@selector(timeattackButtonTouched)];
		
		CCMenuItemSprite *molemadnessButton = [CCMenuItemSprite itemFromNormalSprite:molemadnessButtonSpriteStatic selectedSprite:molemadnessButtonSpriteActive target:self selector:@selector(molemadnessButtonTouched)];
		
		CCMenuItemSprite *backButton = [CCMenuItemSprite itemFromNormalSprite:backButtonSpriteStatic selectedSprite:backButtonSpriteActive target:self selector:@selector(backButtonTouched)];
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		
		CCSprite *pozadi = [CCSprite spriteWithFile:@"pozadi_menu.png"];
		pozadi.position = ccp([pozadi texture].contentSize.width / 2, [pozadi texture].contentSize.height / 2);
		
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Play" fontName:@"font.otf" fontSize:30];
		label.position = ccp(screenSize.width / 2 + 15, screenSize.height - 37);
		
		CCLabelTTF *labelShadow = [CCLabelTTF labelWithString:@"Play" fontName:@"font.otf" fontSize:30];
		labelShadow.position = ccp(screenSize.width / 2 + 15, screenSize.height - 39);
		labelShadow.color = ccc3(0, 0, 0);
		labelShadow.opacity = 120;
		
		[self addChild:pozadi];
		[self addChild:labelShadow];
		[self addChild:label];
		
		if ([settings.lastLevel intValue] > 0) {
			CCMenu *menu = [CCMenu menuWithItems:continueButton, newstoryButton, classicButton, timeattackButton, molemadnessButton, backButton, nil];
			[menu alignItemsVerticallyWithPadding:8];
			menu.position = CGPointMake(screenSize.width / 2, 200);
			[self addChild:menu];
		}else {
			CCMenu *menu = [CCMenu menuWithItems:newstoryButton, classicButton, timeattackButton, molemadnessButton, backButton, nil];
			[menu alignItemsVerticallyWithPadding:8];
			menu.position = CGPointMake(screenSize.width / 2, 170);
			[self addChild:menu];
		}
		
	}
	
	return self;
}

- (void) continueButtonTouched{
	
}

- (void) newstoryButtonTouched{
	Settings *settings = [Settings sharedSettings];
	
	if ([settings.lastLevel intValue] > 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New story" message:@"Starting new story will delete current progress" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Start anyway", nil];
		
		[alert show];
		[alert release];
	}else {
		StoryScene *scene = [StoryScene alloc];
		[scene initWithLevel:1];
		[[CCDirector sharedDirector] replaceScene:[scene scene]];
	}

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
		Settings *settings = [Settings sharedSettings];
		settings.lastLevel = [NSNumber numberWithInt:0];
		[settings saveSettings];
		
		StoryScene *scene = [StoryScene alloc];
		[scene initWithLevel:1];
		[[CCDirector sharedDirector] replaceScene:[scene scene]];
	}
}

- (void) classicButtonTouched{
	LocationScene *scene = [LocationScene alloc];
	
	[[CCDirector sharedDirector] replaceScene: [[scene initWithGameType:kGameModeClassic] scene]];
}

- (void) timeattackButtonTouched{
	LocationScene *scene = [LocationScene alloc];
	
	[[CCDirector sharedDirector] replaceScene: [[scene initWithGameType:kGameModeTimeAttack] scene]];
}

- (void) molemadnessButtonTouched{
	LocationScene *scene = [LocationScene alloc];
	
	[[CCDirector sharedDirector] replaceScene: [[scene initWithGameType:kGameModeMoleMadness] scene]];
}

- (void) backButtonTouched{
	[[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
}

- (void) dealloc{
	[super dealloc];
}

@end
