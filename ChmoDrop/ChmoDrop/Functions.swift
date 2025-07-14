//
//  SetIcon.swift
//  ChmoDrop
//
//  Created by 桃源老師 on 2025/07/10.
//

import AppKit

// フォルダかどうかをチェックする関数
func isDirectory(url: URL) -> Bool {
    var isDir: ObjCBool = false
    FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir)
    return isDir.boolValue
}

// カスタムアイコンファイル"Icon\r"を削除する関数
func removeIconFile(in folderURL: URL) {
    // 改行文字 \r を含むファイル名を組み立てる
    let iconFileName = "Icon\r"
    let iconFileURL = folderURL.appendingPathComponent(iconFileName)

    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: iconFileURL.path) {
        do {
            try fileManager.removeItem(at: iconFileURL)
            #if DEBUG
                print("✅ Icon file removed: \(iconFileURL.path)")
            #endif
        } catch {
            #if DEBUG
                print("❌ Failed to remove Icon file: \(error.localizedDescription)")
            #endif
        }
    } else {
        #if DEBUG
            print("ℹ️ Icon file does not exist at: \(iconFileURL.path)")
        #endif
    }
}

// setFolderIcon()関数とchmodFolder()関数を行うラッパー関数
func setIconAndCallChmod(at url: URL, isUnlocked: Bool, skipUnlockIcon: Bool) -> Bool {
    
    var chmodStatus: Bool = false
    
    if isUnlocked {
        // アンロック時はchmodでアクセス権を回復してから、アイコンを変更
        chmodStatus = chmodFolder(at: url, isUnlocked: isUnlocked)
        
        // skipUnlockIconトグル（チェックボックス）の状態により、アイコン付与/しないを切り替える
        if !skipUnlockIcon {
            removeIconFile(in: url)
            setFolderIcon(imageName: "unlockIcon", at: url)
        } else {
            removeIconFile(in: url)
        }
    } else {
        // ロック時は先にアイコンを設定し、chmodで制限
        removeIconFile(in: url)
        setFolderIcon(imageName: "lockIcon", at: url)
        chmodStatus = chmodFolder(at: url, isUnlocked: isUnlocked)
    }
    
    return chmodStatus
}

// chmod を実行する関数
func chmodFolder(at url: URL, isUnlocked: Bool) -> Bool {
    let path = url.path
    let mode = isUnlocked ? "755" : "555"
    
    let process = Process()
    process.launchPath = "/bin/chmod"
    process.arguments = [mode, path]
    
    do {
        
        try process.run()
        process.waitUntilExit()
        return process.terminationStatus == 0
    } catch {
        return false
    }
}

// カスタムアイコンを設定する関数
func setFolderIcon(imageName: String, at url: URL) {
    
    guard let image = NSImage(named: imageName) else {
        #if DEBUG
            print("❌ Can't find out icon file: \(imageName)")
        #endif
        return
    }

    NSWorkspace.shared.setIcon(image, forFile: url.path, options: [])
    #if DEBUG
        print("✅ Successfully set icon: \(imageName)")
    #endif
}
