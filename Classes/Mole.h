//
//  Krtek.h
//  Molemageddon
//
//  Created by Adam Tomeček on 6/5/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface Mole : CCSprite {
	CDSoundSource* appearSound;
	CDSoundSource* disappearSound;
	CDSoundSource* hitSound;
	CDSoundSource* loopSound;
	int moleType;
	int lives;
	BOOL isActive;
	float gspeed;
	int posIndex;
	BOOL beenHit;
	int lastSound;
}

+ (id) mole:(float)gameSpeed;
- (id) initWithType:(int)type speed:(float)gameSpeed;
- (void) runAppearAnim;
- (void) runLoopAnim;
- (void) runDisappearAnim;
- (void) runHitAnim;
- (void) remove;
- (CGPoint) getPosition;
- (bool) hit;
- (int) moleType;
- (int) lives;
- (void) setLives:(int)val;
- (void) setMoleType:(int)type;
- (void) setIsActive:(_Bool)is;
- (void) setGspeed:(float)s;
- (float) gspeed;
- (int) posIndex;
- (void) setPosIndex:(int)index;
- (bool)isActive;
- (BOOL)beenHit;
- (void)setBeenHit:(bool)state;
- (void)stopSounds;
- (void)continueSounds;
@end
