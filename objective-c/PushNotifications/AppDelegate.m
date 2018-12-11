//
//  AppDelegate.m
//  PushNotifications
//
//  Created by Jovan Stanimirovic on 09/12/2018.
//  Copyright © 2018 Medium. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>


@interface AppDelegate() <UNUserNotificationCenterDelegate>

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[self requestPushNotificationPermissions];

	return YES;
}

- (void)application:(UIApplication*)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)devToken
{
	const char *data = [devToken bytes];
	NSMutableString *token = [NSMutableString string];
	for (NSUInteger i = 0; i < [devToken length]; i++)
	{
		[token appendFormat:@"%02.2hhX", data[i]];
	}
	NSLog(@"Push Notification Token: %@", [token copy]);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
	// could not register a Push Notification token at this time.
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
	// app has received a push notification
}

- (void)requestPushNotificationPermissions
{
	// iOS 10+
	UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
	[center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
		
		switch (settings.authorizationStatus)
		{
			case UNAuthorizationStatusNotDetermined:
			{
				center.delegate = self;
				[center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
				 {
					 if(granted)
					 {
						 [[UIApplication sharedApplication] registerForRemoteNotifications];
					 }
					 else
					 {
						 // notify user to enable push notification permission in settings
					 }
				 }];
				break;
			}
			case UNAuthorizationStatusDenied:
			{
				// notify user to enable push notification permission in settings
				break;
			}
			case UNAuthorizationStatusAuthorized:
			{
				[[UIApplication sharedApplication] registerForRemoteNotifications];
				break;
			}
			default:
				break;
		}
	}];
}


@end
