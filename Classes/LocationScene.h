//
//  LocationScene.h
//  Molemageddon
//
//  Created by Adam Tomeček on 6/19/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LocationScene : CCLayer {
	int gameType;
}

- (id) scene;
- (id) initWithGameType:(int)type;

- (void) setGameType:(int)type;
- (int) gameType;

@end
