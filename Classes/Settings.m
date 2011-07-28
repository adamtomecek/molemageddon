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
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
		//NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
	
		//NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
	
	NSNumber *sounds = [defaults objectForKey:@"MMSoundsVolume"];
	NSNumber *music = [defaults objectForKey:@"MMMusicVolume"];
	
	[NSDictionary release];
	
	soundsVolume = [sounds floatValue];
	musicVolume = [music floatValue];
	golf = [defaults objectForKey:@"MMGolf"];
	country = [defaults objectForKey:@"MMCountry"];
	garden = [defaults objectForKey:@"MMGarden"];
	lastLevel = [defaults objectForKey:@"MMLastLevel"];
	intro = [defaults objectForKey:@"MMIntro"];
	
	sae = [SimpleAudioEngine sharedEngine];
	
	[sae setEffectsVolume:settings.soundsVolume];
	[sae setBackgroundMusicVolume:musicVolume];
	
	return [super init];
}

- (void)saveSettings{
	[sae setEffectsVolume:soundsVolume];
	[sae setBackgroundMusicVolume:musicVolume];
	
	NSNumber *sounds = [NSNumber numberWithFloat:soundsVolume];
	NSNumber *music = [NSNumber numberWithFloat:musicVolume];
	
		//NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
	
		//NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:sounds forKey:@"MMSoundsVolume"];
	[defaults setObject:music forKey:@"MMMusicVolume"];
	[defaults setObject:golf forKey:@"MMGolf"];
	[defaults setObject:country forKey:@"MMCountry"];
	[defaults setObject:garden forKey:@"MMGarden"];
	[defaults setObject:lastLevel forKey:@"MMLastLevel"];
	[defaults setObject:intro forKey:@"MMIntro"];
	
	[defaults synchronize];
		//[dictionary writeToFile:path atomically:YES];
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

- (void)setIntro:(NSNumber *)set{
	intro = set;
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

- (NSNumber *)intro{
	return intro;
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
