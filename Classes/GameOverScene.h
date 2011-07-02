//
//  GameOverScene.h
//  Molemageddon
//
//  Created by Adam Tomeček on 6/24/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverScene : CCLayer {
}

- (id) scene;

- (id) initWithScore:(int)score gameType:(int)type gamePlace:(int)place;

@end
