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
#import "Settings.h"

@implementation GameOverScene

int gameType;
int gamePlace;
int gScore;
int scoreLimit = 0;

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

- (id) initWithScoreLimit:(int)score gameType:(int)type gamePlace:(int)place scoreLimit:(int)minScore{
	gameType = type;
	gamePlace = place;
	gScore = score;
	scoreLimit = minScore;
	return self;
}

- (id) initWithScore:(int)score gameType:(int)type gamePlace:(int)place{
	gameType = type;
	gamePlace = place;
	gScore = score;
	scoreLimit = 0;
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
		
		if (scoreLimit == 0) {
			CCSprite *twitter = [CCSprite spriteWithSpriteFrameName:@"button_twitter_static.png"];
			CCSprite *twitterA = [CCSprite spriteWithSpriteFrameName:@"button_twitter_active.png"];
			
			CCMenuItemSprite *twitterButton = [CCMenuItemSprite itemFromNormalSprite:twitter selectedSprite:twitterA target:self selector:@selector(twitterShare)];
			
			CCSprite *facebook = [CCSprite spriteWithSpriteFrameName:@"button_facebook_static.png"];
			CCSprite *facebookA = [CCSprite spriteWithSpriteFrameName:@"button_facebook_active.png"];
			
			CCMenuItemSprite *facebookButton = [CCMenuItemSprite itemFromNormalSprite:facebook selectedSprite:facebookA target:self selector:@selector(facebookShare)];
			
			CCMenu *shareMenu = [CCMenu menuWithItems:facebookButton, twitterButton, nil];
			[shareMenu alignItemsHorizontallyWithPadding:20];
			shareMenu.position = CGPointMake(screenSize.width / 2, 155);
			
			[self addChild:shareMenu];
		}
		
		/* create menu with items */
		CCMenu *menu = [CCMenu menuWithItems:playAgainButton, mainMenuButton, nil];
		[menu alignItemsVerticallyWithPadding:10];
		menu.position = CGPointMake(screenSize.width / 2, 70);
		[self addChild:menu];
		
		if (scoreLimit > 0) {
			NSString *gameOver = [NSString stringWithFormat:@"Sorry, you didn't satisfy conditions for this level"];
			
			CCLabelTTF *gameOverLabel = [CCLabelTTF labelWithString:gameOver dimensions:CGSizeMake(screenSize.width * 0.65f, 100) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeClip fontName:@"font.otf" fontSize:20];
			
			gameOverLabel.color = ccc3(75, 56, 31);
			gameOverLabel.position = CGPointMake(screenSize.width / 2, 340);
			
			[self addChild:gameOverLabel];
			
			NSString *conditions;
			
			switch (gameType) {
				case kGameModeClassic:
					conditions = [NSString stringWithFormat:@"You have to banish %d moles to win this level", scoreLimit];
					break;
				case kGameModeTimeAttack:
					conditions = [NSString stringWithFormat:@"You have to banish %d moles to win this level", scoreLimit];
					break;
				case kGameModeMoleMadness:
					conditions = [NSString stringWithFormat:@"You have to banish %d moles to win this level", scoreLimit];
					break;
				default:
					CCLOG(@"Default case in gameType switch in GameOverScene");
					break;
			}
			
			CCLabelTTF *conditionsLabel = [CCLabelTTF labelWithString:conditions dimensions:CGSizeMake(screenSize.width * 0.65f, 100) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeClip fontName:@"font.otf" fontSize:22];
			
			conditionsLabel.color = ccc3(199, 224, 43);
			conditionsLabel.position = CGPointMake(screenSize.width / 2, 235);
			
			[self addChild:conditionsLabel];
			
		}else {
			NSString *yourScore = [NSString stringWithFormat:@"Your score"];
			CCLabelTTF *yourScoreLabel = [CCLabelTTF labelWithString:yourScore fontName:@"font.otf" fontSize: 30];
			yourScoreLabel.color = ccc3(199, 224, 43);
			yourScoreLabel.position = CGPointMake(screenSize.width / 2, 370);
			[self addChild:yourScoreLabel];
			
			NSString *skoreString = [NSString stringWithFormat:@"%i", gScore];
			
			CCLabelTTF *skoreLabel = [CCLabelTTF labelWithString:skoreString fontName:@"font.otf" fontSize:40];
			skoreLabel.color = ccc3(75, 56, 31);
			skoreLabel.position = ccp(screenSize.width / 2, 320);
			
			NSString *gameMode;
			NSString *gameDifficulty;
			
			switch (gameType) {
				case kGameModeClassic:
					gameMode = [NSString stringWithFormat:@"Classic"];
					break;
				case kGameModeTimeAttack:
					gameMode = [NSString stringWithFormat:@"Time Attack"];
					break;
				case kGameModeMoleMadness:
					gameMode = [NSString stringWithFormat:@"Mole Madness"];
					break;
				default:
					CCLOG(@"Default case in gameType switch in GameOverScene");
					break;
			}
			
			switch (gamePlace) {
				case kGamePlaceGarden:
					gameDifficulty = [NSString stringWithFormat:@" in the garden."];
					break;
				case kGamePlaceCountry:
					gameDifficulty = [NSString stringWithFormat:@" in the city park."];
					break;
				case kGamePlaceGolf:
					gameDifficulty = [NSString stringWithFormat:@" on the golf course."];
					break;
				default:
					CCLOG(@"Default case in gamePlace switch in GameOverScene");
					break;
			}
			
			NSString *message = [NSString stringWithFormat:@"In %@ %@", gameMode, gameDifficulty];
			
			CCLabelTTF *messageLabel = [CCLabelTTF labelWithString:message dimensions:CGSizeMake(screenSize.width * 0.65f, 100) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeClip fontName:@"font.otf" fontSize:20];
			
			messageLabel.color = ccc3(199, 224, 43);
			messageLabel.position = CGPointMake(screenSize.width / 2, 235);
			
			[self addChild:messageLabel];
			
			[self addChild:skoreLabel];
			
			Settings *settings = [Settings sharedSettings];
			[settings.sae playBackgroundMusic:@"KeepTrying.mp3" loop:YES];
		}
	}
	
	return self;
}

- (void) facebookShare{
	id appDelegate = [[UIApplication sharedApplication] delegate];
	NSString *message = [NSString stringWithFormat:@"I've just banished %d moles in iPhone game Molemageddon. Can you do better?", gScore];
	[appDelegate facebookAccountLogin:message];
}

- (void) twitterShare{
	if ([[NSUserDefaults standardUserDefaults] objectForKey: @"authData"] == nil) {	
		NSString *message = [NSString stringWithFormat:@"I've just banished %d moles in iPhone game Molemageddon http://is.gd/molemageddon #Molemageddon", gScore];
		id appDelegate = [[UIApplication sharedApplication] delegate];
		[appDelegate twitterAccountLogin:message];
	}else {
		NSString *message = [NSString stringWithFormat:@"I've just banished %d moles in iPhone game Molemageddon http://is.gd/molemageddon #Molemageddon", gScore];
		id appDelegate = [[UIApplication sharedApplication] delegate];
		[appDelegate twitterAccountLogin:message];
	}


}

- (void) playAgainButtonTouched{
	GameScene *scene = [GameScene alloc];
	
	if (scoreLimit == 0) {
		[scene initWithGameType:gameType gamePlace:gamePlace];
	}else {
		[scene initWithGameType:gameType gamePlace:gamePlace scoreLimit:scoreLimit];
	}
	
	[[CCDirector sharedDirector] replaceScene:[scene scene]];
}

- (void) mainMenuButtonTouched{
	[[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
}

@end
