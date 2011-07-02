//
//  Position.m
//  Molemageddon
//
//  Created by Adam Tomeček on 6/20/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import "Position.h"


@implementation Position

- (void)setPosition:(CGPoint)pos{
	position = pos;
}

- (void)setFree:(bool)f{
	free = f;
}

- (void)setScale:(float)s{
	scale = s;
}

- (CGPoint)position{
	return position;
}

- (bool)isFree{
	return free;
}

- (float)scale{
	return scale;
}

- (void)dealloc{
	[super dealloc];
}

@end
