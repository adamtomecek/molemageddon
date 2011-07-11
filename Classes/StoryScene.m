//
//  StoryScene.m
//  Molemageddon
//
//  Created by Adam Tomeček on 7/1/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import "StoryScene.h"
#import "Settings.h"
#import "GameScene.h"
#import "MainMenuScene.h"

@implementation StoryScene
	
int levelNumber;
int gplace;
int gtype;
int mscore;

- (id)initWithLevel:(int)level{
	levelNumber = level;
	return self;
}

- (id) scene
{
		// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
		// 'layer' is an autorelease object.
	StoryScene *layer = [StoryScene node];
	
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
		
		gtype = [[level objectForKey:@"mode"] intValue];
		gplace = [[level objectForKey:@"difficulty"] intValue];
		mscore = [[level objectForKey:@"score"] intValue];
		
		NSString *message = [level objectForKey:@"begintext"];
		
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[frameCache addSpriteFramesWithFile:@"menu.plist"];
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		CCSprite *pozadi = [CCSprite spriteWithFile:@"story_mode.png"];
		pozadi.position = ccp(screenSize.width / 2, screenSize.height / 2);
		
		[self addChild:pozadi];
		
		/* create two sprites for both states of one button */
		CCSprite *playAgainSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_play_static.png"];
		CCSprite *playAgainSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_play_active.png"];
		
		CCSprite *mainMenuStatic = [CCSprite spriteWithSpriteFrameName:@"button_mainmenu_static.png"];
		CCSprite *mainMenuActive = [CCSprite spriteWithSpriteFrameName:@"button_mainmenu_active.png"];
		
		/* create menu item from sprites */
		CCMenuItemSprite *playAgainButton = [CCMenuItemSprite itemFromNormalSprite:playAgainSpriteStatic selectedSprite:playAgainSpriteActive target:self selector:@selector(nextLevelButtonTouched)];
		
		CCMenuItemSprite *mainMenuButton = [CCMenuItemSprite itemFromNormalSprite:mainMenuStatic selectedSprite:mainMenuActive target:self selector:@selector(mainMenuButtonTouched)];
		
		/* create menu with items */
		CCMenu *menu = [CCMenu menuWithItems:playAgainButton, mainMenuButton, nil];
		[menu alignItemsVerticallyWithPadding:7];
		menu.position = CGPointMake(screenSize.width / 2, 65);
		[self addChild:menu];
		
		CCLabelTTF *nextLevelLabel = [CCLabelTTF labelWithString:@"Next level" fontName:@"font.otf" fontSize: 24];
		nextLevelLabel.color = ccc3(199, 224, 43);
		nextLevelLabel.position = CGPointMake(screenSize.width / 2, 380);
		[self addChild:nextLevelLabel];
		
		NSString *gm;
		
		switch (gtype) {
			case kGameModeClassic:
				gm = [NSString stringWithFormat:@"Classic"];
				break;
			case kGameModeTimeAttack:
				gm = [NSString stringWithFormat:@"Time Attack"];
				break;
			case kGameModeMoleMadness:
				gm = [NSString stringWithFormat:@"Mole Madness"];
				break;
			default:
				CCLOG(@"Default case in gameType switch in GameOverScene");
				break;
		}
		
		NSString *gp;
		
		switch (gplace) {
			case kGamePlaceGarden:
				gp = [NSString stringWithFormat:@"In the garden"];
				break;
			case kGamePlaceCountry:
				gp = [NSString stringWithFormat:@"In the city park"];
				break;
			case kGamePlaceGolf:
				gp = [NSString stringWithFormat:@"On the golf course"];
				break;
			default:
				CCLOG(@"Default case in gtype switch in StoryScene");
				break;
		}
		
		/*
		
		CCLabelTTF *gameModeLabel = [CCLabelTTF labelWithString:gm fontName:@"font.otf" fontSize:20];
		gameModeLabel.color = ccc3(75, 56, 31);
		gameModeLabel.position = CGPointMake(screenSize.width / 2, 355);
		[self addChild:gameModeLabel];
		
		CCLabelTTF *gamePlaceLabel = [CCLabelTTF labelWithString:gp fontName:@"font.otf" fontSize:20];
		gamePlaceLabel.color = ccc3(75, 56, 31);
		gamePlaceLabel.position = CGPointMake(screenSize.width / 2, 330);
		[self addChild:gamePlaceLabel];
		
		
		NSString *skoreString = [NSString stringWithFormat:@"%d moles to hit", mscore];
		
		CCLabelTTF *skoreLabel = [CCLabelTTF labelWithString:skoreString fontName:@"font.otf" fontSize:20];
		skoreLabel.color = ccc3(75, 56, 31);
		skoreLabel.position = ccp(screenSize.width / 2, 305);
		 
		*/
		
		CCLabelTTF *levelNameLabel = [CCLabelTTF labelWithString:levelName fontName:@"font.otf" fontSize:40];
		levelNameLabel.color = ccc3(75, 56, 31);
		levelNameLabel.position = CGPointMake(screenSize.width / 2, 340);
		[self addChild:levelNameLabel];
		
		NSString *skoreString = [NSString stringWithFormat:@"%d moles to hit", mscore];
		
		CCLabelTTF *skoreLabel = [CCLabelTTF labelWithString:skoreString fontName:@"font.otf" fontSize:20];
		skoreLabel.color = ccc3(199, 224, 43);
		skoreLabel.position = CGPointMake(screenSize.width / 2, 305);
		
		CCLabelTTF *messageLabel = [CCLabelTTF labelWithString:message dimensions:CGSizeMake(screenSize.width * 0.66f, 130) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeClip fontName:@"font.otf" fontSize:18];
		
		messageLabel.color = ccc3(199, 224, 43);
		messageLabel.position = CGPointMake(screenSize.width / 2, 215);
		
		[self addChild:messageLabel];
		
		[self addChild:skoreLabel];
		 
	}
	
	return self;
}

- (void) nextLevelButtonTouched{	
	/* load game scene with level configuration */
	GameScene *scene = [GameScene alloc];
	[scene initWithGameType:gtype gamePlace:gplace scoreLimit:mscore];
	
	[[CCDirector sharedDirector] replaceScene: [scene scene]];
}

- (void) mainMenuButtonTouched{
	[[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
}

- (void)setLevelName:(NSString *)name{
	levelName = name;
}

- (void)setGameType:(NSNumber *)type{
	gameType = type;
}

- (void)setGamePlace:(NSNumber *)place{
	gamePlace = place;
}

- (void)setMinScore:(NSNumber *)min{
	minScore = min;
}

- (NSString *)levelName{
	return levelName;
}

- (NSNumber *)gameType{
	return gameType;
}

- (NSNumber *)gamePlace{
	return gamePlace;
}

- (NSNumber *)minScore{
	return minScore;
}

- (void) dealloc{	
	[super dealloc];
}

@end
