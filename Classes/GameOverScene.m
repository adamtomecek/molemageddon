//
//  GameOverScene.m
//  Molemageddon
//
//  Created by Adam Tomeček on 6/24/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import "GameOverScene.h"
#import "GameScene.h"
#import "MainMenuScene.h"

@implementation GameOverScene

int gameType;
int gamePlace;
int gScore;

- (id) scene
{
		// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
		// 'layer' is an autorelease object.
	GameOverScene *layer = [GameOverScene node];
	
		// add layer as a child to scene
	[scene addChild: layer];
	
		//self.gameType = type;
		//self.place = place;
	
		// return the scene
	return scene;
}

- (id) initWithScore:(int)score gameType:(int)type gamePlace:(int)place{
	gameType = type;
	gamePlace = place;
	gScore = score;
	return self;
}

- (id) init{
	if( (self=[super init] )) {	
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[frameCache addSpriteFramesWithFile:@"menu.plist"];
		
		
		CCSprite *pozadi = [CCSprite spriteWithFile:@"game_over.png"];
		pozadi.position = ccp([pozadi texture].contentSize.width / 2, [pozadi texture].contentSize.height / 2);
		
		[self addChild:pozadi];
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		/* create two sprites for both states of one button */
		CCSprite *playAgainSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_playagain_static.png"];
		CCSprite *playAgainSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_playagain_active.png"];
		
		CCSprite *mainMenuStatic = [CCSprite spriteWithSpriteFrameName:@"button_mainmenu_static.png"];
		CCSprite *mainMenuActive = [CCSprite spriteWithSpriteFrameName:@"button_mainmenu_active.png"];
		
		/* create menu item from sprites */
		CCMenuItemSprite *playAgainButton = [CCMenuItemSprite itemFromNormalSprite:playAgainSpriteStatic selectedSprite:playAgainSpriteActive target:self selector:@selector(playAgainButtonTouched)];
		
		CCMenuItemSprite *mainMenuButton = [CCMenuItemSprite itemFromNormalSprite:mainMenuStatic selectedSprite:mainMenuActive target:self selector:@selector(mainMenuButtonTouched)];
		
		CCSprite *twitter = [CCSprite spriteWithSpriteFrameName:@"button_about_static.png"];
		CCSprite *twitterA = [CCSprite spriteWithSpriteFrameName:@"button_about_active.png"];
		
		CCMenuItemSprite *twitterButton = [CCMenuItemSprite itemFromNormalSprite:twitter selectedSprite:twitterA target:self selector:@selector(twitterShare)];
		
		/* create menu with items */
		CCMenu *menu = [CCMenu menuWithItems:playAgainButton, mainMenuButton, nil];
		[menu alignItemsVerticallyWithPadding:10];
		menu.position = CGPointMake(screenSize.width / 2, 80);
		[self addChild:menu];
		
		NSString *skoreString = [NSString stringWithFormat:@"%i", gScore];
		
		CCLabelTTF *skoreLabel = [CCLabelTTF labelWithString:skoreString fontName:@"font.otf" fontSize:40];
		skoreLabel.color = ccc3(75, 56, 31);
		skoreLabel.position = ccp(screenSize.width / 2, 320);
		
		[self addChild:skoreLabel];
	}
	
	return self;
}

- (void) twitterShare{
	if ([[NSUserDefaults standardUserDefaults] objectForKey: @"authData"] == nil) {	
		NSString *message = [NSString stringWithFormat:@"I've just ousted %d moles in Molemageddon", gScore];
		id appDelegate = [[UIApplication sharedApplication] delegate];
		[appDelegate twitterAccountLogin:message];
	}else {
		NSString *message = [NSString stringWithFormat:@"I've just ousted %d moles in Molemageddon", gScore];
		id appDelegate = [[UIApplication sharedApplication] delegate];
		[appDelegate sendUpdate:message];
	}


}

- (void) playAgainButtonTouched{
	GameScene *scene = [GameScene alloc];
	[scene initWithGameType:gameType gamePlace:gamePlace];
	
	[[CCDirector sharedDirector] replaceScene:[scene scene]];
}

- (void) mainMenuButtonTouched{
	[[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
}

@end
