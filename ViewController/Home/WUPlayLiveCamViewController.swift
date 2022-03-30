       //
//  WUPlayLiveCamViewController.swift
//  Wussup
//
//  Created by MAC26 on 18/06/18.
//  Copyright © 2018 MAC26. All rights reserved.
//
/*
import UIKit
import AVKit
import youtube_ios_player_helper

class WUPlayLiveCamViewController: UIViewController {
    
    @IBOutlet weak var viewContain: UIView!
    @IBOutlet weak var btnClose: UIButton!
    
    // MARK: - Play Video Variables
     var player : AVPlayer!
    private var playerController : AVPlayerViewController!
    var isFromPlayLiveVC : Bool = true
    
    var videoStringUrl : String! = ""
    var playLiveCamArray : [WUVenueLiveCams] = []
    
    
    private var arrVideoUrls : [String]!
    private var currentVideoUrlIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIDeviceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
        self.initialInterfaceSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initialInterfaceSetup(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        self.playVideo()
    }
    
    
    //To change video contiouesly in header
    @objc func playerDidFinishPlaying(notification: NSNotification) {
        Utill.printInTOConsole(printData:"Video Finished")
        self.currentVideoUrlIndex = self.currentVideoUrlIndex + 1
        if self.currentVideoUrlIndex == self.playLiveCamArray.count{
            self.currentVideoUrlIndex = 0
        }
        self.playVideo()
    }
    
    private func playVideo() {
        if self.playerController == nil {
            self.playerController = AVPlayerViewController()
        }
        if currentVideoUrlIndex >= playLiveCamArray.count
        {
            currentVideoUrlIndex = 0
        }
        if (playLiveCamArray.count > 0)
        {
            let url = playLiveCamArray[currentVideoUrlIndex].LiveCamURL
            if url != ""
            {
                if let urlVideo = URL(string: url){
                    let avplayerItem = AVPlayerItem(url: urlVideo)
                    self.player = AVPlayer(playerItem: avplayerItem)
                    self.player?.rate = 1.0;
                    self.player?.isMuted = false
                    self.playerController.player = self.player
                    self.playerController.view.isUserInteractionEnabled = true
                    self.playerController.view.frame = self.view.bounds
                    self.playerController.updatesNowPlayingInfoCenter = false
                    if #available(iOS 11.0, *) {
                        self.playerController.entersFullScreenWhenPlaybackBegins = true
                    } else {
                        // Fallback on earlier versions
                    }
//                                        self.playerController.showsPlaybackControls = false
                    //                    self.playerController.updatesNowPlayingInfoCenter = false
                    self.view.addSubview(self.playerController.view)
                    self.player?.play()
                    self.view.bringSubview(toFront: self.btnClose)
                    //                    self.loopVideo()
                }
            }
        }
    }
    
    
//    private func playYouTubeVideo(){
//        let playerVars = ["playsinline": 1] // 0: will play video in fullscreen
//        let arr =  self.videoStringUrl.components(separatedBy: "/")
//        self.viewContain.load(withVideoId: arr.last, playerVars: playerVars)
//    }
    @IBAction func buttonCloseAction(_ sender: Any) {
        self.player?.pause()
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
        self.navigationController?.popViewController(animated: true)
    }
}

        
*/
