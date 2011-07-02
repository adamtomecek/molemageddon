//
//  Spawner.h
//  Molemageddon
//
//  Created by Adam Tomeček on 6/5/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Spawner : CCNode {
	NSMutableArray *positions;
	CCArray *objects;
	float lifeTime;
	float delay;
	int numberLimit;
}

+ (id) spawner;
+ (void) spawnerWithPositions:(NSMutableArray *)objectPositions 
objectLifeTime:(float)objectLifeTime 
spawnDelay:(float)spawnDelay 
			objectNumberLimit:(int)objectNumberLimit;
			

@end