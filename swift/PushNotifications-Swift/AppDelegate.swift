//
//  AppDelegate.swift
//  PushNotifications-Swift
//
//  Created by Jovan Stanimirovic on 10/12/2018.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		self.requestPushNotificationPermissions()
		return true
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
	{
		let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
		print("Push Notification Token: \(deviceTokenString)")
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		// could not register a Push Notification token at this time.
	}
	
//	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler:
//		@escaping (UIBackgroundFetchResult) -> Void
//		) {
//		// app has received a push notification
//	}
	
	
	func requestPushNotificationPermissions() -> Void
	{
		if #available(iOS 10.0, *)
		{
			let center = UNUserNotificationCenter.current()
			center.requestAuthorization(options:[.badge, .alert, .sound])
			{
				granted, error in
				
				guard granted else { return }
				
				UNUserNotificationCenter.current().getNotificationSettings {settings in
					guard settings.authorizationStatus == .authorized else { return }
					
					switch (settings.authorizationStatus) {
					case .notDetermined:
						UIApplication.shared.registerForRemoteNotifications()
						break
					case .provisional: break
					case .authorized:
						UIApplication.shared.registerForRemoteNotifications()
						break
					case .denied:
						// notify user to enable push notification permission in settings
						break
					}
				}
			}
		}
	}
}

