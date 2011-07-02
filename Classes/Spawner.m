//
//  Spawner.m
//  Molemageddon
//
//  Created by Adam Tomeček on 6/5/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import "Spawner.h"


@implementation Spawner

+ (id) spawner{
	return [[[self alloc] init] autorelease];
}

- (id) spawnerInit{
	if ((self = [super init])) {
	
	}
	return self;
}

+ (void) spawnerWithPositions:(NSMutableArray *)objectPositions 
		objectLifeTime:(float)objectLifeTime 
		spawnDelay:(float)spawnDelay 
		objectNumberLimit:(int)objectNumberLimit{
		positions = objectPositions;
		delay = spawnDelay;
		lifeTime = objectLifeTime;
		numberLimit = objectNumberLimit;
		objects = [[CCArray alloc] arrayWithCapacity:numberLimit];
	
		//[self schedule:@selector(spawn:) interval: spawnDelay];
}

- (void) spawn:(ccTime)delta{
		//[self unschedule:_cmd];
	
		//[self schedule:@selector(spawn:) interval: delay];
}

@end