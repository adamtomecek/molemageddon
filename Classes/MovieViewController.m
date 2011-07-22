	//
	//  MovieViewController.m
	//  Cocos.iPad
	//
	//  Created by Marc Lee on 27/05/10.
	//  jTribe Holdings Pty Ltd & Adviso Technologies 2010
	//

#import "MovieViewController.h"

@implementation MovieViewController

@synthesize moviePlayer;
@synthesize movieURL;

	// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:[moviePlayer moviePlayer]];
}

-(void)initAndPlayMovie:(NSURL *)mURL layer:(CCLayer*) layer
{
	scene = layer;
		//Initialize a movie player object with the specified URL
	MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:mURL];
	mp.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
	[mp shouldAutorotateToInterfaceOrientation:YES];
	[mp setEditing:YES];
	
		// save the movie play object
	self.moviePlayer = mp;
	[mp release];
	
	[self presentMoviePlayerViewControllerAnimated:self.moviePlayer];
}

- (void)movieFinishedCallback:(NSNotification*) aNotification
{
	MPMoviePlayerController *player = [aNotification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
	[player stop];
	[self dismissMoviePlayerViewControllerAnimated];
	[scene movieFinishedCallback];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
		// Overriden to allow any orientation.
    return YES;
}

- (void)didReceiveMemoryWarning {
		// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
		// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
		// Release any retained subviews of the main view.
}

- (void)dealloc {
    [super dealloc];
}

@end