//
//  LocationScene.m
//  Molemageddon
//
//  Created by Adam Tomeček on 6/19/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import "LocationScene.h"
#import "PlayMenuScene.h"
#import "SlidingMenuGrid.h"
#import "GameScene.h"
#import "Settings.h"


@implementation LocationScene

int gtype;

- (id) scene{
	CCScene *scene = [CCScene node];
	
	LocationScene *layer = [LocationScene node];
	
	[scene addChild: layer];
	
	return scene;
}

- (id) initWithGameType:(int)type{
	gtype = type;
	
	return self;
}

- (id) init{
	CCSpriteFrameCache *menuCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	[menuCache addSpriteFramesWithFile:@"menu.plist"];
	[menuCache addSpriteFramesWithFile:@"ui.plist"];
	
	if ( (self = [super init]) ) {
		/* get window size for later use */
		Settings *settings = [Settings sharedSettings];
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		/* create two sprites for both states of one button */
		CCSprite *backButtonSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_back_static.png"];
		CCSprite *backButtonSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_back_active.png"];
		
		/* create menu item from sprites */
		CCMenuItemSprite *backButton = [CCMenuItemSprite itemFromNormalSprite:backButtonSpriteStatic selectedSprite:backButtonSpriteActive target:self selector:@selector(backButtonTouched)];
		
		/* create menu with items */
		CCMenu *menu = [CCMenu menuWithItems:backButton, nil];
		[menu alignItemsVerticallyWithPadding:10];
		menu.position = CGPointMake(screenSize.width / 2, 70);

		
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Location" fontName:@"font.otf" fontSize:30];
		label.position = ccp(screenSize.width / 2 + 35, screenSize.height - 37);
		
		CCLabelTTF *labelShadow = [CCLabelTTF labelWithString:@"Location" fontName:@"font.otf" fontSize:30];
		labelShadow.position = ccp(screenSize.width / 2 + 35, screenSize.height - 39);
		labelShadow.color = ccc3(0, 0, 0);
		labelShadow.opacity = 120;
		
		
		NSString *golf = [NSString stringWithFormat:@"mini_golf_%i.png", [settings.golf intValue]];
		NSString *country = [NSString stringWithFormat:@"mini_country_%i.png", [settings.country intValue]];
		NSString *garden = [NSString stringWithFormat:@"mini_garden_%i.png", [settings.garden intValue]];
		
		CCSprite *miniGarden = [CCSprite spriteWithSpriteFrameName:garden];
		CCSprite *miniGarden2 = [CCSprite spriteWithSpriteFrameName:garden];
		CCSprite *miniCountry = [CCSprite spriteWithSpriteFrameName:country];
		CCSprite *miniCountry2 = [CCSprite spriteWithSpriteFrameName:country];
		CCSprite *miniGolf = [CCSprite spriteWithSpriteFrameName:golf];
		CCSprite *miniGolf2 = [CCSprite spriteWithSpriteFrameName:golf];
		
		CCMenuItemSprite *miniGardenButton = [CCMenuItemSprite itemFromNormalSprite:miniGarden selectedSprite:miniGarden2 target:self selector:@selector(locationGarden)];
		
		CCLabelTTF *gardenLabel = [CCLabelTTF labelWithString:@"Easy" fontName:@"font.otf" fontSize:20];
		gardenLabel.position = ccp(miniGolf.contentSize.width / 2, -15.f);
		[miniGardenButton addChild:gardenLabel];
		
		CCMenuItemSprite *miniCountryButton = [CCMenuItemSprite itemFromNormalSprite:miniCountry selectedSprite:miniCountry2 target:self selector:@selector(locationCountry)];
		
		CCLabelTTF *countryLabel = [CCLabelTTF labelWithString:@"Medium" fontName:@"font.otf" fontSize:20];
		countryLabel.position = ccp(miniGolf.contentSize.width / 2, -15.f);
		[miniCountryButton addChild:countryLabel];
		
		
		CCMenuItemSprite *miniGolfButton = [CCMenuItemSprite itemFromNormalSprite:miniGolf selectedSprite:miniGolf2 target:self selector:@selector(locationGolf)];
		
		CCLabelTTF *golfLabel = [CCLabelTTF labelWithString:@"Hard" fontName:@"font.otf" fontSize:20];
		golfLabel.position = ccp(miniGolf.contentSize.width / 2, -15.f);
		[miniGolfButton addChild:golfLabel];
		
		NSMutableArray *items = [NSMutableArray arrayWithObjects:miniGardenButton, miniCountryButton, miniGolfButton, nil];
		
		
		SlidingMenuGrid *slidingMenu = [SlidingMenuGrid menuWithArray:items cols:3 rows:1 
															 position:CGPointMake(screenSize.width / 2, screenSize.height - miniGolf.contentSize.height + 20.f) 
															  padding:CGPointMake(miniGolf.contentSize.width + 30.0f, 10.f)];
		
		slidingMenu.pageSize = miniGolf.contentSize.width + 30.0f;
		slidingMenu.iPageCount = 3;
		
		
		CCSprite *pozadi = [CCSprite spriteWithFile:@"pozadi_menu.png"];
		pozadi.position = ccp([pozadi texture].contentSize.width / 2, [pozadi texture].contentSize.height / 2);	
		
		
		
		[self addChild:pozadi];
		
		[self addChild:labelShadow];
		[self addChild:label];
		
			//[slidingMenu addChild:backButton z:1 tag:0];
		[self addChild:slidingMenu];
		
		[self addChild:menu];
		
	}
	
	return self;
}

- (void) setGameType:(int)type{
	gameType = type;
}

- (int) gameType{
	return gameType;
}

- (void) locationGarden{
	Settings *settings = [Settings sharedSettings];
	
	if ([settings.garden boolValue]) {
		GameScene *scene = [GameScene alloc];
		[scene initWithGameType:gtype gamePlace:kGamePlaceGarden];
		
		[[CCDirector sharedDirector] replaceScene: [scene scene]];
	}
}

- (void) locationCountry{
	Settings *settings = [Settings sharedSettings];
	
	if ([settings.country boolValue]) {
		GameScene *scene = [GameScene alloc];
		[scene initWithGameType:gtype gamePlace:kGamePlaceCountry];
		
		[[CCDirector sharedDirector] replaceScene: [scene scene]];
	}
}

- (void) locationGolf{
	Settings *settings = [Settings sharedSettings];
	
	settings.country = [NSNumber numberWithBool:YES];;
	
	if ([settings.golf boolValue]) {
		GameScene *scene = [GameScene alloc];
		[scene initWithGameType:gtype gamePlace:kGamePlaceGolf];
		
		[[CCDirector sharedDirector] replaceScene: [scene scene]];
	}
}

- (void) backButtonTouched{
	[[CCDirector sharedDirector] replaceScene:[PlayMenuScene scene]];
}

@end
