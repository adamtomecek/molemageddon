//
//  StoryScene.h
//  Molemageddon
//
//  Created by Adam Tomeček on 7/1/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface StoryScene : CCLayer {
	NSString *levelName;
	NSNumber *gameType;
	NSNumber *gamePlace;
	NSNumber *minScore;
}

- (id) scene;
- (id) initWithLevel:(int)level;

- (void)setLevelName:(NSString *)name;
- (void)setGameType:(NSNumber *)type;
- (void)setGamePlace:(NSNumber *)place;
- (void)setMinScore:(NSNumber *)min;

- (NSString *)levelName;
- (NSNumber *)gameType;
- (NSNumber *)gamePlace;
- (NSNumber *)minScore;

@end
