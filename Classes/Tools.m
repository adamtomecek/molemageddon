//
//  Tools.m
//  Molemageddon
//
//  Created by Adam Tomeček on 6/6/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import "Tools.h"
#import "cocos2d.h"


@implementation Tools

+ (float)randomNumber:(float)min max:(float)max{
	srandom(time(NULL));
	
	float temp = CCRANDOM_0_1() * (max - min) + min;
	return temp;
}

+ (int)randomInt:(int)min max:(int)max{
	srand(time(NULL));
	
	int random = arc4random() % (max - min + 1);
	random = random + min;
	
	return random;
}

@end
