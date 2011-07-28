//
//  SettingsScene.m
//  Molemageddon
//
//  Created by Adam Tomeček on 6/8/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import "SettingsScene.h"
#import "MainMenuScene.h"
#import "Settings.h"
#import "PauseMenu.h"
#import "GameScene.h"

#define kSounds 1
#define kMusic 2
#define kSoundsBar 3
#define kMusicBar 4


@implementation SettingsScene

+ (id) scene{
	CCScene *scene = [CCScene node];
	
	SettingsScene *layer = [SettingsScene node];
	
	[scene addChild: layer];
	
	return scene;
}

- (id) init{
	CCSpriteFrameCache *menuCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	[menuCache addSpriteFramesWithFile:@"menu.plist"];
	
	if ( (self = [super init]) ) {
		/* get window size for later use */
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		/* create two sprites for both states of one button */
		CCSprite *backButtonSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_back_static.png"];
		CCSprite *backButtonSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_back_active.png"];
		
		/* create menu item from sprites */
		CCMenuItemSprite *backButton = [CCMenuItemSprite itemFromNormalSprite:backButtonSpriteStatic selectedSprite:backButtonSpriteActive target:self selector:@selector(backButtonTouched)];
		
		/* create menu with items */
		CCMenu *menu = [CCMenu menuWithItems:backButton, nil];
		[menu alignItemsVerticallyWithPadding:10];
		menu.position = CGPointMake(screenSize.width / 2, 80);
		
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Settings" fontName:@"font.otf" fontSize:30];
		label.position = ccp(screenSize.width / 2 + 35, screenSize.height - 37);
		
		CCLabelTTF *labelShadow = [CCLabelTTF labelWithString:@"Settings" fontName:@"font.otf" fontSize:30];
		labelShadow.position = ccp(screenSize.width / 2 + 35, screenSize.height - 39);
		labelShadow.color = ccc3(0, 0, 0);
		labelShadow.opacity = 120;
		
		CCSprite *pozadi = [CCSprite spriteWithFile:@"pozadi_menu.png"];
		pozadi.position = ccp([pozadi texture].contentSize.width / 2, [pozadi texture].contentSize.height / 2);
		
		CCSprite *sounds = [CCSprite spriteWithSpriteFrameName:@"settings_sounds_mask.png"];
		sounds.position = ccp(screenSize.width / 2, 300);
		
		CCSprite *music = [CCSprite spriteWithSpriteFrameName:@"settings_music_mask.png"];
		music.position = ccp(screenSize.width / 2, 175);
		
		CCSprite *soundsBackgroundBar = [CCSprite spriteWithSpriteFrameName:@"settings_bar_green.png"];
		soundsBackgroundBar.position = ccp(screenSize.width / 2, 290);
		
		CCSprite *musicBackgroundBar = [CCSprite spriteWithSpriteFrameName:@"settings_bar_green.png"];
		musicBackgroundBar.position = ccp(screenSize.width / 2, 165);
		
		CCSprite *soundsBar = [CCSprite spriteWithSpriteFrameName:@"settings_bar_brown.png"];
		soundsBar.anchorPoint = CGPointMake(0, 0);
		soundsBar.position = ccp(0, 0);
		soundsBar.scaleX = 0.5f;
		
		
		CCSprite *musicBar = [CCSprite spriteWithSpriteFrameName:@"settings_bar_brown.png"];
		musicBar.anchorPoint = CGPointMake(0, 0);
		musicBar.position = ccp(0, 0);
		
		Settings *settings = [Settings sharedSettings];

		soundsBar.scaleX = settings.soundsVolume;
		musicBar.scaleX = settings.musicVolume;
		
		[soundsBackgroundBar addChild:soundsBar z:0 tag:kSoundsBar];
		[musicBackgroundBar addChild:musicBar z:0 tag:kMusicBar];
		
		[self addChild:pozadi];
		[self addChild:labelShadow];
		[self addChild:label];
		
		[self addChild:soundsBackgroundBar z:0 tag:kSounds];
		[self addChild:musicBackgroundBar z:0 tag:kMusic];
		
		[self addChild:sounds];
		[self addChild:music];
		
		[self addChild:menu];
		
		self.isTouchEnabled = YES;
		
		
	}
	
	return self;
}

- (void) backButtonTouched{
	Settings *settings = [Settings sharedSettings];
	[settings saveSettings];
	
		//[[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
	
	[self.parent settingsClosed];
}

- (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* touch = [touches anyObject];
	CGPoint point2 = [touch locationInView: [touch view]];
	CGPoint point = [[CCDirector sharedDirector] convertToGL:point2];
	
	
	CCSprite *soundsNode = (CCSprite *)[self getChildByTag:kSounds];
	CCSprite *musicNode = (CCSprite *)[self getChildByTag:kMusic];
	
	CCSprite *sounds = (CCSprite *)[soundsNode getChildByTag:kSoundsBar];
	CCSprite *music = (CCSprite *)[musicNode getChildByTag:kMusicBar];
	
	Settings *settings = [Settings sharedSettings];
	
	if (CGRectContainsPoint([soundsNode boundingBox], point)) {
		float spriteX = soundsNode.position.x - soundsNode.contentSize.width / 2;
		float touchX = point.x;
		float value = (touchX - spriteX) / soundsNode.contentSize.width;
		value = round(value * 10.0f) / 10.0f;
		
		if (value > 0.95f) {
			value = 1;
		}
		
		if (value < 0.05f) {
			value = 0;
		}
		
		sounds.scaleX = value;
		settings.soundsVolume = value;
	}else if (CGRectContainsPoint([musicNode boundingBox], point)) {
		float spriteX = musicNode.position.x - musicNode.contentSize.width / 2;
		float touchX = point.x;
		float value = (touchX - spriteX) / musicNode.contentSize.width;
		value = round(value * 10.0f) / 10.0f;
		
		if (value > 0.95f) {
			value = 1;
		}
		
		if (value < 0.05f) {
			value = 0;
		}
		
		music.scaleX = value;
		settings.musicVolume = value;
	}
	
	return YES;
}

@end
