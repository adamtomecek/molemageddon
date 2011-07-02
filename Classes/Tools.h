//
//  Tools.h
//  Molemageddon
//
//  Created by Adam Tomeček on 6/6/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface Tools : NSObject {

}

+ (float)randomNumber:(float)min max:(float)max;
+ (int)randomInt:(int)min max:(int)max;

@end
