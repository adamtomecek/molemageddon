//
//  Krtek.m
//  Molemageddon
//
//  Created by Adam Tomeček on 6/5/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import "Mole.h"
#import "CCAnimationHelper.h"
#import "GameScene.h"
#import "Tools.h"
#import "Settings.h"
#import "SimpleAudioEngine.h"

#define kKrtekHoly 1
#define kKrtekHelma 2
#define kKrtekLopata 3

#define kAppearSound 40
#define kLoopSound 41
#define kDisappearSound 42
#define kHitSound 43


int lives;
bool isActive;

ALuint appearSoundId;
ALuint disappearSoundId;
ALuint hitSoundId;
ALuint loopSoundId;

CGPoint position;

@interface Mole (PrivateMethods)
-(id) initWithType;
@end

@implementation Mole

+ (id) mole:(float)gameSpeed{
	int type = arc4random() % 3 + 1;
	return [[[self alloc] initWithType:type speed:gameSpeed] autorelease];
}

- (bool) hit{
	if (isActive) {
		
	}
	
	return isActive;
}

/*- (id) initWithType:(int)type speed:(float)gameSpeed{
	self.moleType = type;
	self.gspeed = gameSpeed;
	
	return self;
}*/

- (id) initWithType:(int)type speed:(float)gameSpeed{
	self.moleType = type;
	self.gspeed = gameSpeed;
	CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	[frameCache addSpriteFramesWithFile:@"krtci.plist"];
	
	
	
	NSString *string = [NSString stringWithFormat:@"krt_objev_%d_1.png", moleType];
	
	if ((self = [super initWithSpriteFrameName:string])) {		
		lives = 1;
		self.isActive = NO;
		
		if (self.moleType == 2) {
			lives = 2;			
		}
		
		Settings *settings = [Settings sharedSettings];
		SimpleAudioEngine *sae = [settings sae];
		
		[[CDAudioManager sharedManager] setResignBehavior:kAMRBStopPlay autoHandle:YES];
		
		[sae preloadEffect:@"sound_appear.wav"];
		[sae preloadEffect:@"sound_disappear.wav"];
		[sae preloadEffect:@"sound_loop.wav"];
		[sae preloadEffect:@"sound_hit.wav"];
		sae.effectsVolume = settings.soundsVolume;
		
		appearSound = [[sae soundSourceForFile:@"sound_appear.wav"] retain];
		disappearSound = [[sae soundSourceForFile:@"sound_disappear.wav"] retain];
		loopSound = [[sae soundSourceForFile:@"sound_loop.wav"] retain];
		hitSound = [[sae soundSourceForFile:@"sound_hit.wav"] retain];
		
		
	}
	return self;
}

- (void)runAppearAnim{
	self.isActive = NO;
	self.beenHit = NO;
	lastSound = kAppearSound;
	
	NSString *animName = [NSString stringWithFormat:@"krt_objev_%i_", self.moleType];
	
	CCAnimation *anim = [CCAnimation animationWithFrame:animName frameCount:7 delay: 0.06f order:0];
	CCAnimate *animate = [CCAnimate actionWithAnimation:anim];	
	CCCallFuncN *call = [CCCallFunc actionWithTarget:self selector:@selector(runLoopAnim)];
	CCSequence *seq = [CCSequence actions:animate, call, nil];
	[self runAction:seq];
	
		//[sae playEffect:@"sound_appear.wav"];
	
	[appearSound play];
}

- (void)runLoopAnim{	
	lastSound = kLoopSound;
	isActive = YES;
	
	NSString *animName = [NSString stringWithFormat:@"krt_loop_%i_", self.moleType];
	
	CCAnimation *anim = [CCAnimation animationWithFrame:animName frameCount:2 delay:0.1f order:0];
	CCAnimate *animate = [CCAnimate actionWithAnimation:anim];	
	CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animate];
	[self runAction:repeat];
	
	float interval = [Tools randomNumber:3/(self.gspeed * 2) max:4/(self.gspeed * 2)];	
	
		//[[CCScheduler sharedScheduler] scheduleSelector:@selector(runDisappearAnim) forTarget:self interval:interval paused:NO];
	[self schedule:@selector(runDisappearAnim) interval:interval];
	
		//loopSoundId = [sae playEffect:@"sound_loop.wav"];
	
	[appearSound stop];
	[hitSound stop];
	[loopSound play];
	loopSound.looping = YES;
	
}

- (void) runHitAnim{
	lastSound = kHitSound;
	isActive = NO;
	
	[self stopAllActions];
	[self unscheduleAllSelectors];
	
	NSString *animName = [NSString stringWithFormat:@"krt_hit_%i_", self.moleType];
	
	CCAnimation *anim;
	CCCallFuncN *call;
	CCAnimate *animate;
	CCSequence *seq;
	
	if (moleType == 2) {
		anim = [CCAnimation animationWithFrame:animName frameCount:6 delay: 0.08f order:0];
		call = [CCCallFunc actionWithTarget:self selector:@selector(runLoopAnim)];
		
		animate = [CCAnimate actionWithAnimation:anim];	
		
		seq = [CCSequence actions:animate, call, nil];
		moleType = 1;
	}else {
		anim = [CCAnimation animationWithFrame:animName frameCount:4 delay: 0.08f order:0];
		call = [CCCallFunc actionWithTarget:self selector:@selector(runDisappearAnim)];
		
		animate = [CCAnimate actionWithAnimation:anim];	
		
		seq = [CCSequence actions:animate, animate, call, nil];
	}
	
	[loopSound stop];
	[hitSound play];
	
	if (self.lives > 1) {
		self.lives--;
	}else {
		self.beenHit = YES;
		GameScene *scene = [GameScene sharedGameScene];
		[scene addScore];
	}
	
	[self runAction:seq];

}

- (void) runDisappearAnim{
	isActive = NO;
	lastSound = kDisappearSound;
	
	[self stopAllActions];
		//[[CCScheduler sharedScheduler] unscheduleAllSelectorsForTarget:self];
	[self unscheduleAllSelectors];
	
	NSString *animName = [NSString stringWithFormat:@"krt_objev_%i_", self.moleType];
	
	CCAnimation *anim = [CCAnimation animationWithFrame:animName frameCount:7 delay: 0.06f order:1];
	CCAnimate *animate = [CCAnimate actionWithAnimation:anim];	
	CCCallFuncN *call = [CCCallFuncN actionWithTarget:self selector:@selector(remove)];
	CCSequence *seq = [CCSequence actions:animate, call, nil];
	[self runAction:seq];
	
		//[sae stopEffect:loopSoundId];
		//[sae playEffect:@"sound_disappear.wav"];
	
	[loopSound stop];
	[hitSound stop];
	[disappearSound play];
}

- (void) remove{
	if (![self beenHit]) {
		GameScene *scene = [GameScene sharedGameScene];
		[scene removeLive];
	}
	
	[appearSound stop];
	[loopSound stop];
	[disappearSound stop];
	[hitSound stop];
	
	[self unscheduleAllSelectors];
	[GameScene deleteFromArray:self pos:self.posIndex];
	[self removeFromParentAndCleanup:YES];
}

- (void) stopSounds{
	[appearSound pause];
	[loopSound pause];
	[disappearSound pause];
	[hitSound pause];
}

- (void) continueSounds{
	switch (lastSound) {
		case kAppearSound:
			[appearSound play];
			break;
		case kLoopSound:
			[loopSound play];
			break;
		case kDisappearSound:
			[disappearSound play];
			break;
		case kHitSound:
			[hitSound play];
			break;

		default:
			break;
	}
}

- (int)moleType{
	return moleType;
}

- (void) setMoleType:(int)type{
	moleType = type;
}

- (void) setIsActive:(bool)is{
	isActive = is;
}

- (CGPoint)getPosition{
	return self.position;
}

- (void) setGspeed:(float)s{
	gspeed = s;
}

- (float) gspeed{
	return gspeed;
}

- (int) posIndex{
	return posIndex;
}

- (void) setPosIndex:(int)index{
	posIndex = index;
}

- (BOOL)beenHit{
	return beenHit;
}

- (void)setBeenHit:(BOOL)state{
	beenHit = state;
}

- (int)lives{
	return lives;
}

- (void)setLives:(int)val{
	lives = val;
}

- (bool)isActive{
	return isActive;
}

- (void) dealloc{
	[appearSound release];
	[disappearSound release];
	[loopSound release];
	[hitSound release];
	[super dealloc];
}

@end