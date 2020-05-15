//
//  UnityUIView.swift
//  NativeiOSApp
//
//  Created by 児玉広樹 on 2020/05/13.
//  Copyright © 2020 unity. All rights reserved.
//

import UIKit

class UnityUIView: UIView {
    private lazy var showUnityOffButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Main", for: .normal)
        button.frame = CGRect(x:0, y:0, width:100, height:44)
        button.center = CGPoint(x:50, y:300)
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(showHostMainWindow), for: .primaryActionTriggered)
        return button
    }()
    private lazy var btnSendMsg: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Msg", for: .normal)
        button.frame = CGRect(x:0, y:0, width:100, height:44)
        button.center = CGPoint(x:150, y:300)
        button.backgroundColor = .yellow
        button.addTarget(self, action: #selector(sendMsg), for: .primaryActionTriggered)
        return button
    }()
    private lazy var unloadBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Unload", for: .normal)
        button.frame = CGRect(x:0, y:0, width:100, height:44)
        button.center = CGPoint(x:250, y:300)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(unloadButtonTouched), for: .primaryActionTriggered)
        return button
    }()
    private lazy var quitBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Quit", for: .normal)
        button.frame = CGRect(x:250, y:0, width:100, height:44)
        button.center = CGPoint(x:250, y:350)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(quitButtonTouched), for: .primaryActionTriggered)
        return button
    }()
    private var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        //        super.init(frame: frame)
        super.init(frame: CGRect(x:0, y:200, width:300, height:400))
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }

    func setup(){
        self.addSubview(showUnityOffButton)
        self.addSubview(btnSendMsg)
        
        // Unload
        self.addSubview(unloadBtn)
        
        // Quit
        self.addSubview(quitBtn)
    }

    @objc func showHostMainWindow(){
       self.delegate.showHostMainWindow()
    }
    @objc func sendMsg(){
        self.delegate.sendMsgToUnity()
    }
    
    @objc func unloadButtonTouched(sender: UIButton){
        self.delegate.unloadButtonTouched(sender)
    }
    
    @objc func quitButtonTouched(sender: UIButton){
        self.delegate.quitButtonTouched(sender)
    }
}
