//
//  ChmoDropApp.swift
//  ChmoDrop
//
//  Created by 桃源老師 on 2025/07/10.
//

import SwiftUI

@main
struct ChmoDropApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // タブ（Tab）に関するメニューを無効化
        NSWindow.allowsAutomaticWindowTabbing = false
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 500, idealWidth: 600, maxWidth: 700, minHeight: 480)
                .background(WindowAccessor()) // ウィンドウ取得用の裏技
        }
        .commands {
            CommandGroup(replacing: .newItem) {
                Button(NSLocalizedString("NewWindow", comment: "")) { }.disabled(true)
            } // ファイルメニューは残し新規ウインドウを無効化（全部消してNew Windowを追加、disabledにするのがトリッキーな裏技）
            
            // 編集メニューの無効化。以下の３項目を無効化すると消せる
            CommandGroup(replacing: .pasteboard) { }
            CommandGroup(replacing: .textEditing) { }
            CommandGroup(replacing: .undoRedo) { }
        }
    }
}
