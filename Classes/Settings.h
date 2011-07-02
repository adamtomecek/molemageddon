//
//  Settings.h
//  Molemageddon
//
//  Created by Adam Tomeček on 6/16/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"


@interface Settings : NSObject {
	float musicVolume;
	float soundsVolume;
	NSNumber *country;
	NSNumber *golf;
	NSNumber *garden;
	NSNumber *lastLevel;
	
	SimpleAudioEngine *sae;
}

+ (void)initialize;

- (void)setSoundsVolume:(float)volume;
- (void)setMusicVolume:(float)volume;
- (void)setCountry:(NSNumber *)set;
- (void)setGolf:(NSNumber *)set;
- (void)setGarden:(NSNumber *)set;
- (void)setLastLevel:(NSNumber *)set;

- (float)soundsVolume;
- (float)musicVolume;
- (NSNumber *)country;
- (NSNumber *)golf;
- (NSNumber *)garden;
- (NSNumber *)lastLevel;

- (SimpleAudioEngine *)sae;

- (void)saveSettings;

+ (Settings *)sharedSettings;

@end
