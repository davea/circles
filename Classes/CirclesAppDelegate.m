//
//  CirclesAppDelegate.m
//  Circles
//
//  Created by Dave Arter on 25/04/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "CirclesAppDelegate.h"
#import "CirclesViewController.h"
#import "CirclesView.h"

@implementation CirclesAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize session;
@synthesize remotePeerID;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];

	picker = [[GKPeerPickerController alloc] init];
	picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
	picker.delegate = self;
	[picker show];
	
	[UIAccelerometer sharedAccelerometer].delegate = self;
	[UIAccelerometer sharedAccelerometer].updateInterval = 1.0/30.0;
}

- (void)peerPickerController:(GKPeerPickerController *)aPicker didConnectPeer:(NSString *)peerID toSession:(GKSession *)aSession
{
	if (aPicker != picker)
		return;
	
	self.session = aSession;
	session.delegate = self;
	NSLog(@"Connected to %@", peerID);
}

- (void)session:(GKSession *)aSession peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
	if (session != aSession)
		return;
	
	NSLog(@"Peer %@ went to state %d", peerID, state);
	switch (state) {
		case GKPeerStateConnected:
			[aSession setDataReceiveHandler:self withContext:nil];
			self.remotePeerID = peerID;
			[picker dismiss];
			[picker autorelease];
			picker = nil;
			break;
		default:
			break;
	}
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)aPicker
{
	if (picker != aPicker)
		return;
	[picker autorelease];
	picker = nil;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	if (session == nil)
		return;

	CGFloat b = MAX(0.25, MIN(1.0, acceleration.x*2.0));
	CGFloat g = MAX(0.25, MIN(1.0, acceleration.y*2.0));
	CGFloat r = MAX(0.25, MIN(1.0, acceleration.z*-2.0));
	
	NSMutableData *data = [NSMutableData data];
	NSKeyedArchiver *ka = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
	[ka encodeFloat:r forKey:@"r"];
	[ka encodeFloat:g forKey:@"g"];
	[ka encodeFloat:b forKey:@"b"];
	
	[ka finishEncoding];
	
	[session sendData:data toPeers:[NSArray arrayWithObject:remotePeerID] withDataMode:GKSendDataReliable error:nil];
	[ka release];
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
	if (![peer isEqualToString:remotePeerID])
		return;
	
	NSKeyedUnarchiver *kua = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	
	CGFloat r = [kua decodeFloatForKey:@"r"];
	CGFloat g = [kua decodeFloatForKey:@"g"];
	CGFloat b = [kua decodeFloatForKey:@"b"];
	
	[(CirclesView *)viewController.view setR:r G:g B:b];
	[kua release];
}



- (BOOL)respondsToSelector:(SEL)aSelector
{
	BOOL responds = [super respondsToSelector:aSelector];
	NSLog(@"%@ %@ %@", [[self class] description], NSStringFromSelector(aSelector), (responds) ? @"YES" : @"NO");
	return responds;
}

- (void)dealloc {
	self.session = nil;
    [viewController release];
    [window release];
    [super dealloc];
}


@end
