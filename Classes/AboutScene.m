//
//  AboutScene.m
//  Molemageddon
//
//  Created by Adam Tomeček on 7/28/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import "AboutScene.h"
#import "MainMenuScene.h"


@implementation AboutScene

+ (id) scene{
	CCScene *scene = [CCScene node];
	
	AboutScene *layer = [AboutScene node];
	
	[scene addChild: layer];
	
	return scene;
}

- (id)init{
	if ( (self = [super init]) ) {
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[frameCache addSpriteFramesWithFile:@"menu.plist"];
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		CCSprite *pozadi = [CCSprite spriteWithFile:@"about.png"];
		pozadi.position = ccp(screenSize.width / 2, screenSize.height / 2);
		
		[self addChild:pozadi];
		
		CCSprite *backButtonSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_back_static.png"];
		CCSprite *backButtonSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_back_active.png"];
		
		CCMenuItemSprite *backButton = [CCMenuItemSprite itemFromNormalSprite:backButtonSpriteStatic selectedSprite:backButtonSpriteActive target:self selector:@selector(backButtonTouched)];
		
		CCMenu *menu = [CCMenu menuWithItems:backButton, nil];
		menu.position = ccp(screenSize.width / 2, 50);
		
		[self addChild:menu];
	}
	
	return self;
}

- (void) backButtonTouched{
	[[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
}

@end
