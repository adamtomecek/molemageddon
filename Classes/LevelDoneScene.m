//
//  LevelDoneScene.m
//  Molemageddon
//
//  Created by Adam Tomeček on 7/2/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import "LevelDoneScene.h"
#import "StoryScene.h"
#import "GameScene.h"
#import "MainMenuScene.h"
#import "StoryScene.h"
#import "Settings.h"
#import "StorySceneFinished.h"


@implementation LevelDoneScene
int levelNumber;

- (id)initWithLevel:(int)level{
	levelNumber = level;
	return self;
}

- (id) scene
{
		// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
		// 'layer' is an autorelease object.
	StoryScene *layer = [LevelDoneScene node];
	
		// add layer as a child to scene
	[scene addChild: layer];
	
		// return the scene
	return scene;
}

- (id) init{
	if( (self=[super init] )) {
		/* load file with level configuration */
		NSString *path = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"plist"];
		NSDictionary *dictionary = [[[NSDictionary alloc] initWithContentsOfFile:path] autorelease];
		
		NSString *l = [NSString stringWithFormat:@"%d", levelNumber];
		
		/* load exact level details */
		NSDictionary *level = [dictionary objectForKey:l];
		
		NSString *levelName = (NSString *)[level objectForKey:@"name"];
		
		int gameType = [[level objectForKey:@"mode"] intValue];
		int gamePlace = [[level objectForKey:@"difficulty"] intValue];
		
		NSString *message = [level objectForKey:@"text"];
		
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[frameCache addSpriteFramesWithFile:@"menu.plist"];
		
		
		CCSprite *pozadi = [CCSprite spriteWithFile:@"level_done.png"];
		pozadi.position = ccp([pozadi texture].contentSize.width / 2, [pozadi texture].contentSize.height / 2);
		
		[self addChild:pozadi];
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		/* create two sprites for both states of one button */
		CCSprite *playAgainSpriteStatic;
		CCSprite *playAgainSpriteActive;
		
		if (levelNumber < 16) {
			playAgainSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_nextlevel_static.png"];
			playAgainSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_nextlevel_active.png"];
		}else {
			playAgainSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_finish_static.png"];
			playAgainSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_finish_active.png"];
		}
		
		CCSprite *mainMenuStatic = [CCSprite spriteWithSpriteFrameName:@"button_mainmenu_static.png"];
		CCSprite *mainMenuActive = [CCSprite spriteWithSpriteFrameName:@"button_mainmenu_active.png"];
		
		/* create menu item from sprites */
		CCMenuItemSprite *playAgainButton = [CCMenuItemSprite itemFromNormalSprite:playAgainSpriteStatic selectedSprite:playAgainSpriteActive target:self selector:@selector(nextLevelButtonTouched)];
		
		CCMenuItemSprite *mainMenuButton = [CCMenuItemSprite itemFromNormalSprite:mainMenuStatic selectedSprite:mainMenuActive target:self selector:@selector(mainMenuButtonTouched)];
		
		/* create menu with items */
		CCMenu *menu = [CCMenu menuWithItems:playAgainButton, mainMenuButton, nil];
		[menu alignItemsVerticallyWithPadding:8];
		menu.position = CGPointMake(screenSize.width / 2, 65);
		[self addChild:menu];
		
		NSString *yourScore = [NSString stringWithFormat:@"You finished level"];
		CCLabelTTF *yourScoreLabel = [CCLabelTTF labelWithString:yourScore fontName:@"font.otf" fontSize: 22];
		yourScoreLabel.color = ccc3(199, 224, 43);
		yourScoreLabel.position = CGPointMake(screenSize.width / 2, 370);
		[self addChild:yourScoreLabel];
		
		NSString *skoreString = [NSString stringWithFormat:@"%@", levelName];
		
		CCLabelTTF *skoreLabel = [CCLabelTTF labelWithString:skoreString fontName:@"font.otf" fontSize:40];
		skoreLabel.color = ccc3(75, 56, 31);
		skoreLabel.position = ccp(screenSize.width / 2, 320);
		
		CCLabelTTF *messageLabel = [CCLabelTTF labelWithString:message dimensions:CGSizeMake(screenSize.width * 0.65f, 130) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeClip fontName:@"font.otf" fontSize:18];
		
		messageLabel.color = ccc3(199, 224, 43);
		messageLabel.position = CGPointMake(screenSize.width / 2, 215);
		
		[self addChild:messageLabel];
		
		[self addChild:skoreLabel];
		
		Settings *settings = [Settings sharedSettings];
		[settings.sae playBackgroundMusic:@"KeepTrying.mp3" loop:YES];
		
		if (levelNumber == 16) {
			settings.lastLevel = 0;
			[settings saveSettings];
		}
	}
	
	return self;
}

- (void)nextLevelButtonTouched{
	if (levelNumber == 16) {
		[[CCDirector sharedDirector] replaceScene:[StorySceneFinished scene]];
	}else {
		StoryScene *scene = [StoryScene alloc];
		[scene initWithLevel:levelNumber + 1];
		[[CCDirector sharedDirector] replaceScene:[scene scene]];
	}
}

- (void)mainMenuButtonTouched{
	[[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
}

@end
