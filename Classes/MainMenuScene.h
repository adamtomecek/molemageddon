//
//  MainMenuScene.h
//  Molemageddon
//
//  Created by Adam Tomeček on 6/8/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MovieViewController.h"

@interface MainMenuScene : CCLayer {
	MovieViewController *videoController;
}

@property (readwrite, retain) MovieViewController *videoController;

+ (id) scene;

@end
