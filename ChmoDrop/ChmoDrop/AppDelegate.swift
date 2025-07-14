//
//  AppDelegate.swift
//  ChmoDrop
//
//  Created by 桃源老師 on 2025/07/11.
//

import Cocoa

// ウインドウが閉じたらAppを終了
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true // ウィンドウをすべて閉じたらアプリ終了
    }
}
