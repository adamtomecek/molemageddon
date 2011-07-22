//
//  HelloWorldLayer.m
//  Molemageddon
//
//  Created by Adam Tomeček on 6/5/11.
//  Copyright OwnSoft 2011. All rights reserved.
//

// Import the interfaces
#import "GameScene.h"
#import "CCAnimationHelper.h"
#import "Tools.h"
#import "Mole.h"
#import "Spawner.h"
#import "Position.h"
#import "GameOverScene.h"
#import "Settings.h"
#import "LevelDoneScene.h"
#import "PauseMenu.h"
#import "MainMenuScene.h"

#define kScoreboard 12
#define kLabelR 10
#define kLabelL 11
#define kPauseMenu 13
#define kPauseBackground 14

// HelloWorld implementation
@implementation GameScene

CCArray *moles;
CCArray *positions;
float speed;
float addSpeed;
int addTimeAfter;
int addTime;
int addLiveAfter;
int score;
int positionsCount;
int timeRemaining;
int moleLimit;
int moleCount;
BOOL paused = NO;

int gplace;
int gtype;
BOOL storyMode;
int scoreLimit;

float waveDelayMax = 1.0f;
float waveDelayMin = 2.0f;

static GameScene* instanceOfGameScene;
+(GameScene*) sharedGameScene {
	NSAssert(instanceOfGameScene != nil, @" instance not yet initialized!");
	return instanceOfGameScene;
}

- (id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene *layer = [GameScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
		//self.gameType = type;
		//self.place = place;
	
	// return the scene
	return scene;
}

-(id) initWithGameType:(int)type gamePlace:(int)place scoreLimit:(int)minScore{
	gplace = place;
	gtype = type;
	scoreLimit = minScore;
	storyMode = YES;
	
	return self;
}

-(id) initWithGameType:(int)type gamePlace:(int)place
{
	gplace = place;
	gtype = type;
	storyMode = NO;
	
	return self;
}

// on "init" you need to initialize your instance
-(id) init
{
	CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
	[frameCache addSpriteFramesWithFile:@"krtci.plist"];
	[frameCache addSpriteFramesWithFile:@"ui.plist"];
	
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {	
		
		instanceOfGameScene = self;
		
		positions = [CCArray alloc];
		
		Settings *settings = [Settings sharedSettings];
		
		switch (gplace) {
			case kGamePlaceGolf:{
				[settings.sae playBackgroundMusic:@"BreakOfDawn.mp3"];
				settings.golf = [NSNumber numberWithInt:1];
				
				CCSprite *pozadi = [CCSprite spriteWithFile:@"bg_golf.png"];
				pozadi.position = ccp([pozadi texture].contentSize.width / 2, [pozadi texture].contentSize.height / 2);
				[self addChild:pozadi];
				
				positionsCount = 13;
				[positions initWithCapacity:positionsCount];
				
				Position *p1 = [Position new];
				p1.position = CGPointMake(82, 83);
				p1.scale = 1.f;
				p1.free = YES;
				
				Position *p2 = [Position new];
				p2.position = CGPointMake(220, 93);
				p2.scale = 1.f;
				p2.free = YES;
				
				Position *p3 = [Position new];
				p3.position = CGPointMake(104, 193);
				p3.scale = 1.f;
				p3.free = YES;
				
				Position *p4 = [Position new];
				p4.position = CGPointMake(238, 163);
				p4.scale = 1.f;
				p4.free = YES;
				
				Position *p5 = [Position new];
				p5.position = CGPointMake(256, 226);
				p5.scale = .8f;
				p5.free = YES;
				
				Position *p6 = [Position new];
				p6.position = CGPointMake(188, 274);
				p6.scale = .8f;
				p6.free = YES;
				
				Position *p7 = [Position new];
				p7.position = CGPointMake(74, 300);
				p7.scale = .8f;
				p7.free = YES;
				
				Position *p8 = [Position new];
				p8.position = CGPointMake(271, 308);
				p8.scale = .8f;
				p8.free = YES;
				
				Position *p9 = [Position new];
				p9.position = CGPointMake(240, 349);
				p9.scale = .6f;
				p9.free = YES;
				
				Position *p10 = [Position new];
				p10.position = CGPointMake(135, 341);
				p10.scale = .6f;
				p10.free = YES;
				
				Position *p11 = [Position new];
				p11.position = CGPointMake(47, 362);
				p11.scale = .6f;
				p11.free = YES;
				
				Position *p12 = [Position new];
				p12.position = CGPointMake(145, 376);
				p12.scale = .4f;
				p12.free = YES;
				
				Position *p13 = [Position new];
				p13.position = CGPointMake(278, 385);
				p13.scale = .4f;
				p13.free = YES;
				
				[positions addObject:p1];
				[positions addObject:p2];
				[positions addObject:p3];
				[positions addObject:p4];
				[positions addObject:p5];
				[positions addObject:p6];
				[positions addObject:p7];
				[positions addObject:p8];
				[positions addObject:p9];
				[positions addObject:p10];
				[positions addObject:p11];
				[positions addObject:p12];
				[positions addObject:p13];
				
				moleLimit = 5;
				
				break;
			}
			case kGamePlaceCountry:{
				[settings.sae playBackgroundMusic:@"WhyWouldI.mp3"];
				settings.country = [NSNumber numberWithInt:1];
				
				CCSprite *pozadi = [CCSprite spriteWithFile:@"bg_country.png"];
				pozadi.position = ccp([pozadi texture].contentSize.width / 2, [pozadi texture].contentSize.height / 2);
				[self addChild:pozadi];
				
				
				Position *p1 = [Position new];
				p1.position = CGPointMake(55, 91);
				p1.scale = 1.f;
				p1.free = YES;
				
				Position *p2 = [Position new];
				p2.position = CGPointMake(259, 94);
				p2.scale = 1.f;
				p2.free = YES;
				
				Position *p3 = [Position new];
				p3.position = CGPointMake(245, 160);
				p3.scale = 1.f;
				p3.free = YES;
				
				Position *p4 = [Position new];
				p4.position = CGPointMake(72, 305);
				p4.scale = 0.8f;
				p4.free = YES;
				
				Position *p5 = [Position new];
				p5.position = CGPointMake(225, 250);
				p5.scale = 0.8f;
				p5.free = YES;
				
				Position *p6 = [Position new];
				p6.position = CGPointMake(260, 295);
				p6.scale = 0.8f;
				p6.free = YES;
				
				Position *p7 = [Position new];
				p7.position = CGPointMake(38, 364);
				p7.scale = 0.6f;
				p7.free = YES;
				
				Position *p8 = [Position new];
				p8.position = CGPointMake(142, 343);
				p8.scale = 0.6f;
				p8.free = YES;
				
				Position *p9 = [Position new];
				p9.position = CGPointMake(114, 378);
				p9.scale = 0.4f;
				p9.free = YES;
				
				Position *p10 = [Position new];
				p10.position = CGPointMake(188, 370);
				p10.scale = 0.4f;
				p10.free = YES;
				
				positionsCount = 10;
				[positions initWithCapacity:positionsCount];
				
				[positions addObject:p1];
				[positions addObject:p2];
				[positions addObject:p3];
				[positions addObject:p4];
				[positions addObject:p5];
				[positions addObject:p6];
				[positions addObject:p7];
				[positions addObject:p8];
				[positions addObject:p9];
				[positions addObject:p10];
				
				moleLimit = 4;
				
				break;
			}
			case kGamePlaceGarden:{
				[settings.sae playBackgroundMusic:@"AllWeDid.mp3"];
				
				settings.garden = [NSNumber numberWithInt:1];
				
				CCSprite *pozadi = [CCSprite spriteWithFile:@"bg_garden.png"];
				pozadi.position = ccp([pozadi texture].contentSize.width / 2, [pozadi texture].contentSize.height / 2);
				[self addChild:pozadi];
				
				positionsCount = 7;
				[positions initWithCapacity:positionsCount];
				
				Position *p1 = [Position new];
				p1.position = CGPointMake(120, 107);
				p1.scale = 1.0f;
				p1.free = YES;
				
				Position *p2 = [Position new];
				p2.position = CGPointMake(255, 126);
				p2.scale = 1.0f;
				p2.free = YES;
				
				Position *p3 = [Position new];
				p3.position = CGPointMake(185, 201);
				p3.scale = 1.0f;
				p3.free = YES;
				
				Position *p4 = [Position new];
				p4.position = CGPointMake(134, 300);
				p4.scale = 0.8f;
				p4.free = YES;
				
				Position *p5 = [Position new];
				p5.position = CGPointMake(243, 329);
				p5.scale = 0.6f;
				p5.free = YES;
				
				Position *p6 = [Position new];
				p6.position = CGPointMake(89, 346);
				p6.scale = 0.4f;
				p6.free = YES;
				
				Position *p7 = [Position new];
				p7.position = CGPointMake(181, 356);
				p7.scale = 0.4f;
				p7.free = YES;
				
				[positions addObject:p1];
				[positions addObject:p2];
				[positions addObject:p3];
				[positions addObject:p4];
				[positions addObject:p5];
				[positions addObject:p6];
				[positions addObject:p7];
				
				moleLimit = 3;
				
				break;
			}
		}
		
		switch (gtype) {
			case kGameModeClassic:
				self.gameSpeed = 1.0f * ((gplace / 10) + 1);
				addSpeed = 0.01f;
				addTimeAfter = 0;
				addTime = 0;
				self.lives = 3;
				addLiveAfter = 30;
				score = 0;
				timeRemaining = 0;
				break;
			case kGameModeTimeAttack:
				self.gameSpeed = 1.0 * ((gplace / 10) + 1);
				addSpeed = 0.02f;
				addTimeAfter = 10;
				addTime = 5;
				timeRemaining = 60;
				self.lives = 0;
				addLiveAfter = 0;
				score = 0;
				break;
			case kGameModeMoleMadness:
				self.gameSpeed = 3.0f * ((gplace / 10) + 1);
				addSpeed = 0;
				addTimeAfter = 0;
				addTime = 0;
				self.lives = 0;
				addLiveAfter = 0;
				score = 0;
				timeRemaining = 30;
				break;
		}
		
		[self createScoreboard];
		
		moles = [[CCArray alloc] initWithCapacity:moleLimit];
		
		moleCount = 0;
		
		self.isTouchEnabled = YES;
		
		float interval = [Tools randomNumber:waveDelayMin/self.gameSpeed max:waveDelayMax/self.gameSpeed];
		
		
		[self schedule:@selector(spawn) interval:interval];
		
		if (gtype != kGameModeClassic) {
			[self schedule:@selector(updateTime) interval:1];
			[self updateTime];
		}else{
			[self updateLives];
		}
		 
		
		/*
		
		for (int i = 0; i < positionsCount; i++) {
			Position *p = [positions objectAtIndex:i];
			
			Mole *m = [Mole mole:speed];
			m.position = p.position;
			m.scale = p.scale;
			
			[self addChild:m];
		}
		*/
	}
	
	return self;
}

- (void)addScore{
	score++;
	NSString *scoreString = [NSString stringWithFormat:@"%d", score];
	
	CCSprite *scoreboard = (CCSprite *)[self getChildByTag:kScoreboard];
	
	CCLabelTTF *time = (CCLabelTTF *)[scoreboard getChildByTag:kLabelR];
	[time setString:scoreString];
	
	if (storyMode) {
		if (score >= scoreLimit) {
			[self unscheduleAllSelectors];
			[self schedule:@selector(newLevel) interval:1.0f];
		}
	}
	
	if (gtype == kGameModeClassic) {
		if ((score % addLiveAfter) == 0) {
			self.lives += 1;
			[self updateLives];
		}
	}else if (gtype == kGameModeTimeAttack) {
		if ((score % addTimeAfter) == 0) {
			timeRemaining += addTime;
		}
	}

}

- (void)updateLives{
	NSString *scoreString = [NSString stringWithFormat:@"%d", self.lives];
	CCSprite *scoreboard = (CCSprite *)[self getChildByTag:kScoreboard];
	
	CCLabelTTF *time = (CCLabelTTF *)[scoreboard getChildByTag:kLabelL];
	[time setString:scoreString];
}

- (void)removeLive{
	if (gtype == kGameModeClassic) {
		self.lives -= 1;
		
		[self updateLives];
		
		if (self.lives == 0) {
			[self gameOver];
		}
	}
}

- (void) updateTime{
	if (timeRemaining == 0) {
		[self gameOver];
	}else {
		NSString *scoreString = [NSString stringWithFormat:@"%d", timeRemaining];
		
		CCSprite *scoreboard = (CCSprite *)[self getChildByTag:kScoreboard];
		
		CCLabelTTF *time = (CCLabelTTF *)[scoreboard getChildByTag:kLabelL];
		[time setString:scoreString];
		
		timeRemaining--;
	}
}

- (void) createScoreboard{
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	CCSprite *scoreboard = [CCSprite spriteWithSpriteFrameName:@"scoreboard1.png"];
	
	CCSprite *scoreboard1 = [CCSprite spriteWithSpriteFrameName:@"scoreboard1.png"];
	CCSprite *scoreboard2 = [CCSprite spriteWithSpriteFrameName:@"scoreboard1.png"];
	
	CCMenuItemSprite *pauseButton = [CCMenuItemSprite itemFromNormalSprite:scoreboard1 selectedSprite:scoreboard2 target:self selector:@selector(pause)];
	
	CCMenu *pauseMenu = [CCMenu menuWithItems:pauseButton, nil];
	
	pauseMenu.position = ccp(screenSize.width / 2, screenSize.height - [scoreboard contentSize].height / 2);
	scoreboard.position = ccp(screenSize.width / 2, screenSize.height - [scoreboard contentSize].height / 2);
	
	[self addChild:scoreboard z:5 tag:kScoreboard];
	[self addChild:pauseMenu z:4];
	
	switch (gtype) {
		case kGameModeMoleMadness:{
			CCSprite *score = [CCSprite spriteWithSpriteFrameName:@"icon_time.png"];
			score.position = ccp(score.contentSize.width * 1.4f, score.contentSize.height / 2);
			[scoreboard addChild:score];
			
			CCSprite *time = [CCSprite spriteWithSpriteFrameName:@"icon_zivoty.png"];
			time.position = ccp(scoreboard.contentSize.width - time.contentSize.width * 1.2f, time.contentSize.height / 2);
			[scoreboard addChild:time];			
			break;
		}
		
		case kGameModeTimeAttack:{
			CCSprite *score = [CCSprite spriteWithSpriteFrameName:@"icon_time.png"];
			score.position = ccp(score.contentSize.width * 1.4f, score.contentSize.height / 2);
			[scoreboard addChild:score];
			
			CCSprite *time = [CCSprite spriteWithSpriteFrameName:@"icon_zivoty.png"];
			time.position = ccp(scoreboard.contentSize.width - time.contentSize.width * 1.2f, time.contentSize.height / 2);
			[scoreboard addChild:time];
			break;
		}
		case kGameModeClassic:{
			CCSprite *score = [CCSprite spriteWithSpriteFrameName:@"icon_score.png"];
			score.position = ccp(score.contentSize.width, score.contentSize.height / 2);
			[scoreboard addChild:score];
			
			CCSprite *time = [CCSprite spriteWithSpriteFrameName:@"icon_zivoty.png"];
			time.position = ccp(scoreboard.contentSize.width - time.contentSize.width * 1.2, time.contentSize.height / 2);
			[scoreboard addChild:time];
			break;
		}		
	}
	
	CCLabelTTF *labelR = [CCLabelTTF labelWithString:@"zzz" fontName:@"font.otf" fontSize:19];
	labelR.color = ccc3(0, 0, 0);
	labelR.position = ccp(scoreboard.contentSize.width - labelR.contentSize.width * 3, scoreboard.contentSize.height / 3.8f);
	[scoreboard addChild:labelR z:1 tag:kLabelR];
	[labelR setString:@"0"];
	
	CCLabelTTF *labelL = [CCLabelTTF labelWithString:@"zzz" fontName:@"font.otf" fontSize:19];
	labelL.color = ccc3(0, 0, 0);
	labelL.position = ccp(labelL.contentSize.width * 3, scoreboard.contentSize.height / 3.8f);
	[scoreboard addChild:labelL z:1 tag:kLabelL];
	[labelL setString:@"0"];
}

- (void) pause{
	if (!paused) {
		CCSprite *pauseBackground = [CCSprite spriteWithFile:@"pause.png"];
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		pauseBackground.position = ccp(screenSize.width / 2, screenSize.height / 2);
		
		[self addChild:pauseBackground z:2 tag:kPauseBackground];
		
		[[CCDirector sharedDirector] pause];
		
		CCLayer *pauseMenu = [PauseMenu node];
		[self addChild: pauseMenu z:10 tag:kPauseMenu];
		Settings *settings = [Settings sharedSettings];
		[settings.sae pauseBackgroundMusic];
		int count = [moles count];
		
		for (int i = 0; i < count; i++) {
			Mole *mole = (Mole *)[moles randomObject];
			[mole stopSounds];
		}
		
		paused = YES;
	}
}

- (void) pauseOver{
	[self removeChildByTag:kPauseMenu cleanup:YES];
	[self removeChildByTag:kPauseBackground cleanup:YES];
	[[CCDirector sharedDirector] resume];
	Settings *settings = [Settings sharedSettings];
	[settings.sae resumeBackgroundMusic];
	
	int count = [moles count];
	
	for (int i = 0; i < count; i++) {
		Mole *mole = (Mole *)[moles randomObject];
		[mole continueSounds];
	}
	
	paused = NO;
}

- (void) spawn{
	if (moleCount < moleLimit) {	
		bool free = FALSE;
		int random;
	
		for (int i = 7; i > 0; i--) {
			random = [Tools randomInt:1 max:positionsCount] - 1;
			Position *pos = (Position *)[positions objectAtIndex:random];
			
			if ([pos isFree]) {
				free = YES;
				break;
			}
		}
		
		if (free) {
			Position *pos = (Position *)[positions objectAtIndex:random];
			pos.free = NO;
			
			Mole *mole = [Mole mole: [self gameSpeed]];
			mole.position = pos.position;
			mole.scale = pos.scale;
			mole.posIndex = random;
			if (gtype != kGameModeMoleMadness) {
				[self unschedule:@selector(spawn)];
				float interval = [Tools randomNumber:waveDelayMin/self.gameSpeed max:waveDelayMax/self.gameSpeed];
				[self schedule:@selector(spawn) interval:interval];
			}
			
			self.gameSpeed += addSpeed;
			moleCount++;
			
			[moles addObject:mole];
			[self addChild:mole];
			[mole runAppearAnim];
		}
	}
}

- (void)clear{
	[[Settings sharedSettings].sae stopBackgroundMusic];
	[self unscheduleAllSelectors];
	
	int count = [moles count];
	
	for (int i = 0; i < count; i++) {
		Mole *mole = (Mole *)[moles randomObject];
		[mole remove];
	}
}

- (void)newLevel{
	[self clear];
	
	Settings *settings = [Settings sharedSettings];
	
	int lastLevel = [settings.lastLevel intValue] + 1;
	
	settings.lastLevel = [NSNumber numberWithInt:lastLevel];
	[settings saveSettings];
	
	LevelDoneScene *scene = [LevelDoneScene alloc];
	[scene initWithLevel:lastLevel];
	
	[[CCDirector sharedDirector] replaceScene:[scene scene]];
}

- (void)gameOver{	
	[self clear];
	
	GameOverScene *gameOverScene = [GameOverScene alloc];
	
	if (scoreLimit > 0) {
		[gameOverScene initWithScoreLimit:score gameType:gtype gamePlace:gplace scoreLimit:scoreLimit];
	}else {
		[gameOverScene initWithScore:score gameType:gtype gamePlace:gplace];
	}
	
	[[CCDirector sharedDirector] replaceScene:[gameOverScene scene]];
}

- (void) mainMenuButtonTouched{
	[self pauseOver];
	[self clear];
	[[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
}

- (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* touch = [touches anyObject];
	CGPoint point2 = [touch locationInView: [touch view]];
	CGPoint point = [[CCDirector sharedDirector] convertToGL:point2];
	
	int count = [moles count];
	
	for (int i = 0; i < count; i++) {
		Mole *mySprite = (Mole*)[moles objectAtIndex:i];
		if ([mySprite isActive]) {
			if (CGRectContainsPoint([mySprite boundingBox], point)) {
				[mySprite runHitAnim];
				break;
			}
		}
	}
	
	return YES;
}

+ (void) deleteFromArray:(Mole *)mole pos:(int)posIndex{
	[moles removeObject:mole];
	Position *pos = (Position *)[positions objectAtIndex:posIndex];
	pos.free = YES;
	moleCount--;
}

- (void) setGameType:(int)t{
	gameType = t;
}

- (void) setGamePlace:(int)p{
	gamePlace = p;
}

- (void) setGameSpeed:(float)s{
	gameSpeed = s;
}

- (int)gameType{
	return gameType;
}

- (int)gamePlace{
	return gamePlace;
}

- (float)gameSpeed{
	return gameSpeed;
}

- (void)setLives:(int)l{
	lives = l;
}

- (int)lives{
	return lives;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	[moles release];
	[positions release];
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
