//
//  AppDelegate.swift
//  Cloudonix Example Dialer
//
//  Authors:
//   - Igor Nazarov, 2017-08-15
//   - Oded Arbel, 2022-06-21
//
//  Copyright © 2017 Cloudonix, Inc.
//  Modification, in whole or in part, including copying portions of the work - for use
//  in other software that uses the Cloudonix Mobile SDK - is permitted, without limitation.
//  All other rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	let notFirstLaunch = "not_first_launch"
	var window: UIWindow?
	var waitingForBackgroundCallToComplete = false
	var sipClient: CloudonixSDKClient?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let isFirstLaunch = !UserDefaults.standard.bool(forKey: self.notFirstLaunch)
		if isFirstLaunch {
			SipSettings.shared.save()
			UserDefaults.standard.set(true, forKey: self.notFirstLaunch)
		}

		SipSettings.shared.fetch()
		sipClient = CloudonixSDKClient()
		return true
	}

	func getClient() -> CloudonixSDKClient {
		return sipClient!;
	}

	func applicationWillResignActive(_ application: UIApplication) {
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		sipClient!.registerAccount()
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
	}

	func applicationWillTerminate(_ application: UIApplication) {
	}

	func applicationDidFinishLaunching(_ application: UIApplication) {
	}

}

