//
//  Settings.m
//  Molemageddon
//
//  Created by Adam Tomeček on 6/16/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import "Settings.h"
#import "MolemageddonAppDelegate.h"
#import "SimpleAudioEngine.h"


@implementation Settings

static Settings *settings;

+ (Settings *)sharedSettings{
	NSAssert(settings != nil, @" settings not yet initialized!");
	
	return settings;
}

- (id)init{
	settings = self;
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
	
	NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
	
	NSNumber *sounds = [dictionary objectForKey:@"SoundsVolume"];
	NSNumber *music = [dictionary objectForKey:@"MusicVolume"];
	
	[NSDictionary release];
	
	soundsVolume = [sounds floatValue];
	musicVolume = [music floatValue];
	golf = [dictionary objectForKey:@"Golf"];
	country = [dictionary objectForKey:@"Country"];
	garden = [dictionary objectForKey:@"Garden"];
	lastLevel = [dictionary objectForKey:@"LastLevel"];
	
	sae = [SimpleAudioEngine sharedEngine];
	
	[sae setEffectsVolume:settings.soundsVolume];
	
	[sounds release];
	[music release];
	
	return [super init];
}

- (void)saveSettings{
	NSNumber *sounds = [NSNumber numberWithFloat:soundsVolume];
	NSNumber *music = [NSNumber numberWithFloat:musicVolume];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
	
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	
	[dictionary setValue:sounds forKey:@"SoundsVolume"];
	[dictionary setObject:music forKey:@"MusicVolume"];
	[dictionary setObject:self.golf forKey:@"Golf"];
	[dictionary setValue:self.country forKey:@"Country"];
	[dictionary setValue:self.garden forKey:@"Garden"];
	[dictionary setValue:self.lastLevel forKey:@"LastLevel"];
	
	[dictionary writeToFile:path atomically:YES];

	[sounds release];
	[music release];
}

- (void)setSoundsVolume:(float)volume{
	soundsVolume = volume;
}

- (void)setMusicVolume:(float)volume{
	musicVolume = volume;
}

- (void)setCountry:(NSNumber *)set{
	country = set;
}

- (void)setGolf:(NSNumber *)set{
	golf = set;
}

- (void)setGarden:(NSNumber *)set{
	garden = set;
}

- (void)setLastLevel:(NSNumber *)set{
	lastLevel = set;
}

- (NSNumber *)golf{
	return golf;
}

- (NSNumber *)country{
	return country;
}

- (NSNumber *)garden{
	return garden;
}

- (NSNumber *)lastLevel{
	return lastLevel;
}

- (float)soundsVolume{
	return soundsVolume;
}

- (float)musicVolume{
	return musicVolume;
}

- (void) dealloc{
	[SimpleAudioEngine release];
	sae = nil;
	[super dealloc];
}

- (SimpleAudioEngine *)sae{
	return sae;
}

@end
