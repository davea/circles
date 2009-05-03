//
//  CirclesAppDelegate.h
//  Circles
//
//  Created by Dave Arter on 25/04/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@class CirclesViewController;

@interface CirclesAppDelegate : NSObject <UIApplicationDelegate, GKPeerPickerControllerDelegate, GKSessionDelegate, UIAccelerometerDelegate> {
    UIWindow *window;
    CirclesViewController *viewController;
	GKSession *session;
	GKPeerPickerController *picker;
	NSString *remotePeerID;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CirclesViewController *viewController;
@property (nonatomic, retain) GKSession *session;
@property (nonatomic, retain) NSString *remotePeerID;

@end

