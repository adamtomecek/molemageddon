//
//  Position.h
//  Molemageddon
//
//  Created by Adam Tomeček on 6/20/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Position : NSObject {
	CGPoint position;
	float scale;
	bool free;
}

- (void)setPosition:(CGPoint)pos;
- (void)setFree:(bool)f;
- (void)setScale:(float)s;

- (CGPoint)position;
- (bool)isFree;
- (float)scale;

@end
