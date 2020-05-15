//
//  AppDelegate.swift
//  NativeiOSApp
//
//  Created by 児玉広樹 on 2020/05/14.
//  Copyright © 2020 unity. All rights reserved.
//

import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UnityFrameworkListener, NativeCallsProtocol {
    var window: UIWindow?
    var application: UIApplication?
    var storyboard: UIStoryboard?
    var hostViewController: HostViewController!
    var appLaunchOpts: [UIApplication.LaunchOptionsKey: Any]?
    var unityView: UnityUIView?
    var didQuit: Bool = false

    @objc var currentUnityController: UnityAppController!
    @objc var ufw: UnityFramework?

    func UnityFrameworkLoad() -> UnityFramework {
        let bundlePath = Bundle.main.bundlePath
        let frameworkPath = bundlePath + "/Frameworks/UnityFramework.framework"
        let bundle = Bundle(path: frameworkPath)!
        if !bundle.isLoaded {
            bundle.load()
        }
        let frameworkClass = bundle.principalClass as! UnityFramework.Type
        let ufw = frameworkClass.getInstance()!
        if ufw.appController() == nil {
            var header = _mh_execute_header
            ufw.setExecuteHeader(&header)
        }
        return ufw
    }

    func showAlert(_ title:String, _ msg:String) {
        let alert: UIAlertController = UIAlertController(title: title, message: msg, preferredStyle:  .alert)

        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
        })
        
        alert.addAction(defaultAction)
        window?.rootViewController?.present(alert, animated: true)
    }
    
    func unityIsInitialized()->Bool {
        return (self.ufw != nil && self.ufw?.appController() != nil)
    }

    //Unityのウインドウを表示する
    func showMainView() {
        if(!unityIsInitialized()) {
            showAlert("Unity is not initialized", "Initialize Unity first");
        } else {
            //Unityのウインドウを表示する
            self.ufw?.showUnityWindow();
        }
    }
    
    func showHostMainWindow() {
        self.showHostMainWindow("")
    }

    func showHostMainWindow(_ color: String!) {
        if(color == "blue") {
            self.hostViewController.unpauseBtn.backgroundColor = .blue
        } else if(color == "red") {
            self.hostViewController.unpauseBtn.backgroundColor = .red
        }else if(color == "yellow") {
            self.hostViewController.unpauseBtn.backgroundColor = .yellow
        }
        
        //windowを前面に
        window?.makeKeyAndVisible()
    }
    
    func sendMsgToUnity() {
    //ここでufwにメッセージを送信する
        self.ufw?.sendMessageToGO(withName: "Cube", functionName: "ChangeColor", message: "yellow");
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.application = application
        ufw = UnityFrameworkLoad()

        appLaunchOpts = launchOptions
        
        storyboard = UIStoryboard(name: "Main", bundle: .main)
        hostViewController = storyboard?.instantiateViewController(withIdentifier: "Host") as! HostViewController
        
        // Set root view controller and make windows visible
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = hostViewController;
        
        window?.makeKeyAndVisible()
        return true
    }

    func initUnity(){
        if(unityIsInitialized()) {
            showAlert("Unity already initialized", "Unload Unity first")
            return
        }
        
        if(didQuit) {
            showAlert("Unity cannot be initialized after quit", "Use unload instead")
            return
        }

        ufw?.register(self)
        FrameworkLibAPI.registerAPIforNativeCalls(self)
        ufw?.setDataBundleId("com.unity3d.framework")
        ufw?.runEmbedded(withArgc: CommandLine.argc, argv: CommandLine.unsafeArgv, appLaunchOpts: appLaunchOpts)
        
        // set quit handler to change default behavior of exit app
//        ufw.appController()?.quitHandler
        
        //ufwのUIView
        let view:UIView? = ufw?.appController()?.rootView;
        
        //各種ボタンが配置されていない場合にviewにボタンを再配置する
        if self.unityView == nil {
            self.unityView = UnityUIView()
            view?.addSubview(self.unityView as! UnityUIView)
        }
    }

    func unloadButtonTouched(_ sender: UIButton)
    {
        if(!unityIsInitialized()) {
            showAlert("Unity is not initialized", "Initialize Unity first")
        } else {
            UnityFrameworkLoad().unloadApplication()
        }
    }
    
    func quitButtonTouched(_ sender:UIButton)
    {
        if(!unityIsInitialized()) {
            showAlert("Unity is not initialized", "Initialize Unity first");
        } else {
            UnityFrameworkLoad().quitApplication(0)
        }
    }
    
    //UnityFramework.h にて　UnityFrameworkListenerとして宣言されている
    func unityDidUnload(notification: Notification)
    {
        print("unityDidUnload called")
        self.ufw?.unregisterFrameworkListener(self)
        self.ufw = nil
        self.showHostMainWindow("")
    }
    
    //UnityFramework.h にて　UnityFrameworkListenerとして宣言されている
    func unityDidQuit(notification: Notification)
    {
        print("unityDidQuit called")
        self.ufw?.unregisterFrameworkListener(self)
        self.ufw = nil
        self.didQuit = true
        self.showHostMainWindow("")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        self.ufw?.appController()?.applicationWillResignActive(application)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.ufw?.appController()?.applicationDidEnterBackground(application)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        self.ufw?.appController()?.applicationWillEnterForeground(application)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.ufw?.appController()?.applicationDidBecomeActive(application)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.ufw?.appController()?.applicationWillTerminate(application)
    }
}

