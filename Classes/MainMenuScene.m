//
//  MainMenuScene.m
//  Molemageddon
//
//  Created by Adam Tomeček on 6/8/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import "MainMenuScene.h"
#import "SettingsScene.h"
#import "PlayMenuScene.h"
#import "Settings.h"
#import "MolemageddonAppDelegate.h"
#import "CCVideoPlayer.h"
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CCAnimationHelper.h"
#import "AboutScene.h"

#define kMainMenu 101
#define kMainAnim 102


@implementation MainMenuScene

BOOL set = NO;
ALuint laugh;

+ (id) scene{
	CCScene *scene = [CCScene node];
	
	MainMenuScene *layer = [MainMenuScene node];
	
	[scene addChild: layer];
	
	return scene;
}

- (id) init{	
	if ( (self = [super init]) ) {
		Settings *settings = [Settings sharedSettings];
		
		id appDelegate = [[UIApplication sharedApplication] delegate];
		
		if ([appDelegate intro]) {
			[self createMenu];
		}else {
			[settings.sae pauseBackgroundMusic];
			[appDelegate setIntro:YES];
			[self playIntro];
		}
	}
	
	return self;
}

- (void)createMenu{
	CCSpriteFrameCache *menuCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	[menuCache addSpriteFramesWithFile:@"menu.plist"];
	[menuCache addSpriteFramesWithFile:@"main_anim.plist"];
	
	CCSprite *playButtonSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_play_static.png"];
	CCSprite *playButtonSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_play_active.png"];
	
	CCSprite *settingsButtonSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_settings_static.png"];
	CCSprite *settingsButtonSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_settings_active.png"];
	
	CCSprite *aboutButtonSpriteStatic = [CCSprite spriteWithSpriteFrameName:@"button_about_static.png"];
	CCSprite *aboutButtonSpriteActive = [CCSprite spriteWithSpriteFrameName:@"button_about_active.png"];
	
	CCMenuItemSprite *playButton = [CCMenuItemSprite itemFromNormalSprite:playButtonSpriteStatic selectedSprite:playButtonSpriteActive target:self selector:@selector(playButtonTouched)];
	CCMenuItemSprite *settingsButton = [CCMenuItemSprite itemFromNormalSprite:settingsButtonSpriteStatic selectedSprite:settingsButtonSpriteActive target:self selector:@selector(settingsButtonTouched)];
	CCMenuItemSprite *aboutButton = [CCMenuItemSprite itemFromNormalSprite:aboutButtonSpriteStatic selectedSprite:aboutButtonSpriteActive target:self selector:@selector(aboutButtonTouched)];
	
	CCMenu *menu = [CCMenu menuWithItems:playButton, settingsButton, aboutButton, nil];
	
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	[menu alignItemsVerticallyWithPadding:10];
	
	menu.position = ccp(screenSize.width / 2,
								150);
	
	CCSprite *pozadi = [CCSprite spriteWithFile:@"pozadi_menu_hlavni.png"];
	pozadi.position = ccp([pozadi texture].contentSize.width / 2, [pozadi texture].contentSize.height / 2);
	[self addChild:pozadi];							
	
	[self addChild:menu z:1 tag:kMainMenu];
	
	[self createAnimation];
}

#pragma mark -
#pragma mark Callbacks
- (void) movieFinishedCallback {
	for (id subView in [[[CCDirector sharedDirector] openGLView] subviews]) {
		[(UIView *) subView removeFromSuperview];
	}
	
	[self schedule:@selector(playMusic) interval:0.4f];
	
	[self createMenu];
}

- (void) playButtonTouched{
	if (!set) {
		Settings *settings = [Settings sharedSettings];
		[settings.sae stopEffect:laugh];
		[[CCDirector sharedDirector] replaceScene:[PlayMenuScene scene]];
	}
}

- (void) playMusic{
	[self unschedule:@selector(playMusic)];
	
	Settings *settings = [Settings sharedSettings];
	[settings.sae playBackgroundMusic:@"KeepTrying.mp3"];
}

- (void) settingsButtonTouched{
	if (!set) {
		[[Settings sharedSettings].sae stopEffect:laugh];
		
		SettingsScene *scene = [SettingsScene node];
		[self addChild:scene z:2 tag:kSettingsScene];
		set = YES;
		
		CCMenu *menu = (CCMenu *)[self getChildByTag:kMainMenu];
		menu.visible = NO;
			//CCSprite *mainAnim = (CCSprite *)[self getChildByTag:kMainAnim];
		[self removeChildByTag:kMainAnim cleanup:NO];
	}
}

- (void) aboutButtonTouched{
	[self removeChildByTag:kMainAnim cleanup:YES];
	[[CCDirector sharedDirector] replaceScene:[AboutScene scene]];
}

- (void) stopIntro{
	[self removeChildByTag:2 cleanup:YES];
	[videoController stopMovie];
}

- (void) playIntro{	
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *moviePath = [bundle pathForResource:@"intro" ofType:@"m4v"];
	NSURL *movieURL = [[NSURL fileURLWithPath:moviePath] retain];
	videoController = [[MovieViewController alloc] init];
	[[[CCDirector sharedDirector] openGLView] addSubview:videoController.view];
	[videoController initAndPlayMovie:movieURL layer:self];
	
	Settings *settings = [Settings sharedSettings];
	settings.intro = [NSNumber numberWithBool:YES];
	[settings saveSettings];
	
	CCSprite *s = [CCSprite spriteWithFile:@"Default.png"];
	CCSprite *a = [CCSprite spriteWithFile:@"Default.png"];
	
	CCMenuItemSprite *item = [CCMenuItemSprite itemFromNormalSprite:s selectedSprite:a target:self selector:@selector(stopIntro)];
	
	CCMenu *menu = [CCMenu menuWithItems:item, nil];
	menu.position = ccp([a texture].contentSize.width / 2, [a texture].contentSize.height / 2);
	
	[self addChild:menu z:1 tag:2];
}

- (void) createAnimation{
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	CCSprite *mainAnimation = [CCSprite spriteWithSpriteFrameName:@"main_anim_1.png"];
	mainAnimation.position = ccp(screenSize.width / 2, 355);
	[self addChild:mainAnimation z:1 tag:kMainAnim];
	
	NSString *animName = [NSString stringWithFormat:@"main_anim_"];
	
	CCCallFunc *sound = [CCCallFunc actionWithTarget:self selector:@selector(playLaugh)];
	
	CCAnimation *anim = [CCAnimation animationWithFrame:animName frameCount:15 delay:0.11f order:0];
	CCAnimate *animate = [CCAnimate actionWithAnimation:anim];
	
	CCDelayTime *delay = [CCDelayTime actionWithDuration:5.0f];
	
	CCSequence *animationSeq = [CCSequence actions:sound, animate, delay, nil];
	
	CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animationSeq];
	[mainAnimation runAction:repeat];
}

- (void) settingsClosed{
	[self removeChildByTag:kSettingsScene cleanup:YES];
	set = NO;
	CCMenu *menu = (CCMenu *)[self getChildByTag:kMainMenu];
	menu.visible = YES;
	[self createAnimation];
}

-(void)playLaugh{
	Settings *settings = [Settings sharedSettings];
	laugh = [settings.sae playEffect:@"sound_loop.wav"];
}

@end
