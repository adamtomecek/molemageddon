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
	
		/*
		self.levelName = (NSString *)[level objectForKey:@"name"];
		self.gameType = (NSNumber *)[level objectForKey:@"mode"];
		self.gamePlace = (NSNumber *)[level objectForKey:@"difficulty"];
		self.minScore = (NSNumber *)[level objectForKey:@"score"];
		*/
		
		
		gplace = [[level objectForKey:@"difficulty"] intValue];
		gtype = [[level objectForKey:@"mode"] intValue];
		mscore = [[level objectForKey:@"score"] intValue];
		
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[frameCache addSpriteFramesWithFile:@"menu.plist"];
		
		Settings *settings = [Settings sharedSettings];
		settings.lastLevel = [NSNumber numberWithInt:levelNumber - 1];
		
		CCSprite *playSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_play_static.png"];
		CCSprite *playSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_play_active.png"];
		
		CCMenuItemSprite *playButton = [CCMenuItemSprite itemFromNormalSprite:playSpriteStatic selectedSprite:playSpriteActive target:self selector:@selector(buttonTouched)];
		
		CCMenu *menu = [CCMenu menuWithItems:playButton, nil];
		[self addChild:menu];
		 
	}
	
	return self;
}

- (void) buttonTouched{	
	/* load game scene with level configuration */
	GameScene *scene = [GameScene alloc];
	[scene initWithGameType:gtype gamePlace:gplace scoreLimit:mscore];
	
	[[CCDirector sharedDirector] replaceScene: [scene scene]];
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
