//
//  QQMusicTool.swift
//  仿写QQ音乐
//
//  Created by CoderXu on 16/7/17.
//  Copyright © 2016年 CoderXu. All rights reserved.
//

import UIKit
import AVFoundation
let kPlayerDidFinishPlaying = "playerDidFinishPlaying"
class QQMusicTool: NSObject {
    override init() {
        super.init()
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
        }catch {
            //不成功打印错误
            print(error)
            return
        }
    }
    var player : AVAudioPlayer?
    func playMusic(_ name : String) -> () {
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else {
            return
        }
        //和正在播放的url相同,则继续播放
        if url == player?.url {
            player?.play()
            return
        }
        //不一样播放新歌曲
        do {
            player = try AVAudioPlayer(contentsOf: url)
        }catch {
            print(error)
            return
        }
        player?.delegate = self
        player?.prepareToPlay()
        player?.play()
    }
    func pauseCurrentMusic() -> () {
        player?.pause()
    }
    func resumeCurrentMusic() -> () {
        player?.play()
    }
    func seekTo(_ interval : TimeInterval) -> () {
        player?.currentTime = interval
    }
}
///代理方法,一曲播放完毕发通知
extension QQMusicTool : AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: kPlayerDidFinishPlaying), object: nil)
    }
}
