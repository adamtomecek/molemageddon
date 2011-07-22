#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "cocos2d.h"

@interface MovieViewController : UIViewController {
	MPMoviePlayerViewController *moviePlayer;
	NSURL *movieURL;
	CCLayer *scene;
}

@property (readwrite, retain) MPMoviePlayerViewController *moviePlayer;
@property (nonatomic, retain) NSURL *movieURL;

- (id)delegate;
- (void)setDelegate: (id)newDelegate;
- (void)initAndPlayMovie:(NSURL *)movieURL layer:(CCLayer *) layer;

@end