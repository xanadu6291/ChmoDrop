//
//  ContentView.swift
//  ChmoDrop
//
//  Created by 桃源老師 on 2025/07/10.
//

import SwiftUI

struct ContentView: View {
    @State private var folderPath: String = ""
    @State private var message: String = ""
    @State private var chmodStatus: Bool = false
    // アンロックするかどうかのトグル用
    @State private var isUnlocked: Bool = false
    // アンロック時にアイコンを付与するかどうかのトグル用
    @State private var skipUnlockIcon: Bool = false
    
    @State private var processedFolders: [URL] = []

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                // トグル（チェックボックス）で、動作モードを切り替える
                Toggle("Unlock", isOn: $isUnlocked)
                    .padding()
                Toggle("Don't attach icon on unlock", isOn: $skipUnlockIcon)
                    .disabled(!isUnlocked)
            }
            // ドロップを受け入れる設定をしたText
            Text(folderPath.starts(with: "/") ?
                 folderPath :
                 (isUnlocked ? NSLocalizedString("Drop folder you wish to unlock here", comment: "") : NSLocalizedString("Drop folder you wish to lock here", comment: "")))
                .padding()
                .frame(height: 240)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                // ドロップを受け入れる設定
                .dropDestination(for: URL.self) { urls, _ in
                    var successCount = 0
                    processedFolders = []
                    
                    // 複数フォルダのドロップ対応
                    for folderURL in urls where isDirectory(url: folderURL) {
                        chmodStatus = setIconAndCallChmod(at: folderURL, isUnlocked: isUnlocked, skipUnlockIcon: skipUnlockIcon)
                        
                        successCount += 1
                        
                        processedFolders.append(folderURL)
                    }
                    
                    // 処理フォルダ表示をロック/ロック解除で切り替える
                    var processedCountString: String = ""
                    if isUnlocked {
                        processedCountString = String(format: NSLocalizedString("ProcessedFolderCountUnlockedFormat", comment: ""), successCount)
                    } else {
                        processedCountString = String(format: NSLocalizedString("ProcessedFolderCountLockedFormat", comment: ""), successCount)
                    }
                    
                    message = chmodStatus ? processedCountString : "Failed to chmod"
                    return successCount > 0
                }
            // 動作メッセージ表示用
            Text(message)
                .foregroundColor(.red)
            
            // Finder更新ボタン（補助）
            if !processedFolders.isEmpty {
                Button("Reload Finder") {
                    for url in processedFolders {
                        NSWorkspace.shared.activateFileViewerSelecting([url])
                    }
                }
                .font(.footnote)
                .foregroundColor(.blue)
            }
        }
        .padding(30)
    }
}

#Preview {
    ContentView()
}
