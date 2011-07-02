//
//  HelloWorldLayer.h
//  Molemageddon
//
//  Created by Adam Tomeček on 6/5/11.
//  Copyright OwnSoft 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Mole.h"

#define kGameModeClassic 1
#define kGameModeTimeAttack 2
#define kGameModeMoleMadness 3
#define kGamePlaceGarden 4
#define kGamePlaceCountry 5
#define kGamePlaceGolf 6

// HelloWorld Layer
@interface GameScene : CCLayer
{
	int gameType;
	int gamePlace;
	float gameSpeed;
	int lives;
}

// returns a Scene that contains the HelloWorld as the only child
-(id) scene;

-(id) initWithGameType:(int)type gamePlace:(int)place scoreLimit:(int)minScore;
- (id) initWithGameType:(int)type gamePlace:(int)place;
+(GameScene *) sharedGameScene;
+ (void) deleteFromArray:(Mole *)mole pos:(int)posIndex;

- (void)addScore;
- (void)removeLive;

- (void) setGameType:(int)t;
- (void) setGamePlace:(int)p;
- (void) setGameSpeed:(float)s;
- (void) setLives:(int)l;

- (int)gameType;
- (int)gamePlace;
- (float)gameSpeed;
- (int)lives;

@end
