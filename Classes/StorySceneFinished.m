//
//  StorySceneFinished.m
//  Molemageddon
//
//  Created by Adam Tomeček on 7/26/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import "StorySceneFinished.h"
#import "MainMenuScene.h"
#import "Settings.h"
#import "MolemageddonAppDelegate.h"

@implementation StorySceneFinished

+ (id) scene
{
		// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
		// 'layer' is an autorelease object.
	StorySceneFinished *layer = [StorySceneFinished node];
	
		// add layer as a child to scene
	[scene addChild: layer];
	
		// return the scene
	return scene;
}

- (id) init{
	if( (self=[super init] )) {	
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[frameCache addSpriteFramesWithFile:@"menu.plist"];
		
		
		CCSprite *pozadi = [CCSprite spriteWithFile:@"StoryFinished.png"];
		pozadi.position = ccp([pozadi texture].contentSize.width / 2, [pozadi texture].contentSize.height / 2);
		
		[self addChild:pozadi];
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
		
		CCSprite *mainMenuStatic = [CCSprite spriteWithSpriteFrameName:@"button_mainmenu_static.png"];
		CCSprite *mainMenuActive = [CCSprite spriteWithSpriteFrameName:@"button_mainmenu_active.png"];
		
		CCMenuItemSprite *mainMenuButton = [CCMenuItemSprite itemFromNormalSprite:mainMenuStatic selectedSprite:mainMenuActive target:self selector:@selector(mainMenuButtonTouched)];
		
		
			CCSprite *twitter = [CCSprite spriteWithSpriteFrameName:@"button_twitter_static.png"];
			CCSprite *twitterA = [CCSprite spriteWithSpriteFrameName:@"button_twitter_active.png"];
			
			CCMenuItemSprite *twitterButton = [CCMenuItemSprite itemFromNormalSprite:twitter selectedSprite:twitterA target:self selector:@selector(twitterShare)];
			
			CCSprite *facebook = [CCSprite spriteWithSpriteFrameName:@"button_facebook_static.png"];
			CCSprite *facebookA = [CCSprite spriteWithSpriteFrameName:@"button_facebook_active.png"];
			
			CCMenuItemSprite *facebookButton = [CCMenuItemSprite itemFromNormalSprite:facebook selectedSprite:facebookA target:self selector:@selector(facebookShare)];
			
			CCMenu *shareMenu = [CCMenu menuWithItems:facebookButton, twitterButton, nil];
			[shareMenu alignItemsHorizontallyWithPadding:20];
			shareMenu.position = CGPointMake(screenSize.width / 2, 130);
			
			[self addChild:shareMenu];
		
		
		/* create menu with items */
		CCMenu *menu = [CCMenu menuWithItems:mainMenuButton, nil];
		[menu alignItemsVerticallyWithPadding:10];
		menu.position = CGPointMake(screenSize.width / 2, 70);
		[self addChild:menu];
		
		
			NSString *gameOver = [NSString stringWithFormat:@"You've just finished story mode"];
			
			CCLabelTTF *gameOverLabel = [CCLabelTTF labelWithString:gameOver dimensions:CGSizeMake(screenSize.width * 0.65f, 100) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeClip fontName:@"font.otf" fontSize:20];
			
			gameOverLabel.color = ccc3(75, 56, 31);
			gameOverLabel.position = CGPointMake(screenSize.width / 2, 300);
			
			[self addChild:gameOverLabel];
			
			NSString *conditions = [NSString stringWithFormat:@"Enjoy playing different game modes!"];

			
			CCLabelTTF *conditionsLabel = [CCLabelTTF labelWithString:conditions dimensions:CGSizeMake(screenSize.width * 0.65f, 100) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeClip fontName:@"font.otf" fontSize:20];
			
			conditionsLabel.color = ccc3(199, 224, 43);
			conditionsLabel.position = CGPointMake(screenSize.width / 2, 235);
			
			[self addChild:conditionsLabel];
	}
	
	return self;
}

- (void) facebookShare{
	id *appDelegate = [[UIApplication sharedApplication] delegate];
	NSString *message = [NSString stringWithFormat:@"I've just finished story mode in iPhone game Molemageddon. Try it!"];
	[appDelegate facebookAccountLogin:message];
}

- (void) twitterShare{
	if ([[NSUserDefaults standardUserDefaults] objectForKey: @"authData"] == nil) {	
		NSString *message = [NSString stringWithFormat:@"I've just finished story mode in iPhone game Molemageddon. Try it! http://is.gd/molemageddon #Molemageddon"];
		id appDelegate = [[UIApplication sharedApplication] delegate];
		[appDelegate twitterAccountLogin:message];
	}else {
		NSString *message = [NSString stringWithFormat:@"I've just finished story mode in iPhone game Molemageddon. Try it! http://is.gd/molemageddon #Molemageddon"];
		id appDelegate = [[UIApplication sharedApplication] delegate];
		[appDelegate twitterAccountLogin:message];
	}
	
	
}

- (void) mainMenuButtonTouched{
	[[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
}

@end
