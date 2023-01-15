//
//  AppDelegate.swift
//  SIMD_Accelerate_Matrix_Math
//
//  Created by Eric Kampman on 1/15/23.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

	


	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// FIXME -- Testing matrix math here -- no UI, remove
		determinant2x2Test()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}


}

