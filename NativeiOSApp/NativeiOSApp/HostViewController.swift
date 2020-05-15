//
//  HomeViewController.swift
//  NativeiOSApp
//
//  Created by 児玉広樹 on 2020/05/11.
//  Copyright © 2020 unity. All rights reserved.
//

import Foundation
import UIKit

class HostViewController: UIViewController {
    public var unityInitBtn:UIButton!
    public var unpauseBtn:UIButton!
    public var unloadBtn:UIButton!
    public var quitBtn:UIButton!
    private var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .blue
        
        // INIT UNITY
        self.unityInitBtn = UIButton(type: .system)
        self.unityInitBtn.setTitle("Init", for: .normal)
        self.unityInitBtn.frame = CGRect(x:0, y:0, width:100, height:44)
        self.unityInitBtn.center = CGPoint(x:50, y:120)
        self.unityInitBtn.backgroundColor = .green
        //タップ時のアクション:AppDelegate内に定義したメソッドを利用する
        self.unityInitBtn.addTarget(self, action: #selector(initUnity), for: .primaryActionTriggered)
        self.view.addSubview(self.unityInitBtn)

        // SHOW UNITY
        self.unpauseBtn = UIButton(type: .system)
        self.unpauseBtn.setTitle("Show Unity",for: .normal)
        self.unpauseBtn.frame = CGRect(x:100, y:0, width:100, height:44)
        self.unpauseBtn.center = CGPoint(x:150, y:120);
        self.unpauseBtn.backgroundColor = .lightGray
        //タップ時のアクション:AppDelegate内に定義したメソッドを利用する
        self.unpauseBtn.addTarget(self, action: #selector(showMainView), for: .primaryActionTriggered)
        self.view.addSubview(self.unpauseBtn)

        // UNLOAD UNITY
        self.unloadBtn = UIButton(type: .system)
        self.unloadBtn.setTitle("Unload", for: .normal)
        self.unloadBtn.frame = CGRect(x:200, y:0, width:100, height:44)
        self.unloadBtn.center = CGPoint(x:250, y:120)
        self.unloadBtn.backgroundColor = .red
        //タップ時のアクション:AppDelegate内に定義したメソッドを利用する
        self.unloadBtn.addTarget(self, action: #selector(unloadButtonTouched), for: .primaryActionTriggered)
        self.view.addSubview(self.unloadBtn)

        // QUIT UNITY
        self.quitBtn = UIButton(type: .system)
        self.quitBtn.setTitle("Quit",for: .normal)
        self.quitBtn.frame = CGRect(x:300, y:0, width:100, height:44)
        self.quitBtn.center = CGPoint(x:250, y:170)
        self.quitBtn.backgroundColor = .red
        //タップ時のアクション:AppDelegate内に定義したメソッドを利用する
        self.quitBtn.addTarget(self, action: #selector(quitButtonTouched), for: .primaryActionTriggered)
        self.view.addSubview(self.quitBtn)
    }
    
    @objc func initUnity(){
        self.delegate.initUnity()
    }
    
    @objc func showMainView(){
        self.delegate.showMainView()
    }
    
    @objc func unloadButtonTouched(_ sender:UIButton){
        self.delegate.unloadButtonTouched(sender)
    }
    
    @objc func quitButtonTouched(_ sender:UIButton){
        self.delegate.quitButtonTouched(sender)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
