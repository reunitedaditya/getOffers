//
//  ViewController.swift
//  GetOffers
//
//  Created by Aditya  on 04/04/17.
//  Copyright © 2017 Aditya Yadav. All rights reserved.
//

import UIKit
import CallKit
import UserNotifications
import UserNotificationsUI
import SDWebImage
import Alamofire


class ViewController: UIViewController, CXCallObserverDelegate {
    
    var callObserver = CXCallObserver()
    let requestIdentifier = "SampleRequest" //identifier is to cancel the notification request
    @IBOutlet weak var productImageView: UIImageView!
    var downloadImage : Bool = true

    var timer = Timer()
    var backgroundTask = BackgroundTask()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        self.sendDataToServer()
        self.scheduledTimerWithTimeInterval()
        
        callObserver.setDelegate(self, queue: nil)
        
        backgroundTask.startBackgroundTask()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        
    }
    

    
    func timerAction() {
        
        
        switch UIApplication.shared.applicationState {
            
        case .background:
            
            print("background")
            
            
        default:
            print("")
        }
       
    }
    
    
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {   // Call related delegate function
        
        if call.hasConnected {
            
            print("call connected")
        }
        
        if call.isOutgoing {
            
            print("user Called")
        }
        
        if call.hasEnded {
            
            print("Call ended from delegate")
            self.triggerNotification()
        }
        
        if call.isOnHold {
            
            print("Call on hold")
        }
    }
    
    
    @IBAction func refreshOffer(_ sender: Any) {
        
        self.sendDataToServer()
    }
    
    
    
    @IBAction func logout(_ sender: Any) {
       
        UserDefaults.standard.set(false, forKey: "accessStatus")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Login")
        self.present(controller, animated: true, completion: nil)

    }
    
    

    func triggerNotification(){   //Handle Notification
        
        print("notification will be triggered in a second")
        let content = UNMutableNotificationContent()
        content.title = "Get Offer"
        content.subtitle = "Checkout this latest offer"
        content.body = "Tap to open"
        content.sound = UNNotificationSound.default()
        
        // Deliver the notification in one second.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1.0, repeats: false)
        let request = UNNotificationRequest(identifier:requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil){
                
              
            }
        }
        
    }

    
    // SEND USER DETAILS
    
    func sendDataToServer(){

        
        let parameters = ["userId" : UserDefaults.standard.value(forKey: "userDetails") as! String, "udid" : UIDevice.current.identifierForVendor!.uuidString] as [String : Any]
        
        Alamofire.request("http://go.graymatrix.com/api/go", method: .post, parameters: parameters).responseJSON { response in

            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                if let object = JSON as? NSDictionary {
                    // json is a dictionary
                    
                    let data =  object.value(forKey: "data") as! String
                    
                    self.productImageView.sd_setImage(with: URL(string: data), placeholderImage: #imageLiteral(resourceName: "search-3-512"), options: [.continueInBackground , .progressiveDownload])
                    
                    print("this is Json")
                }

            }
        }
        
    }
    
    var timer2 = Timer()
    
  
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function **Countdown** with the interval of 1 seconds
        
        timer2 = Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    func updateCounting(){
        NSLog("counting..")
        
        backgroundTask.stopBackgroundTask()
        backgroundTask.startBackgroundTask()
    }
}

extension ViewController:UNUserNotificationCenterDelegate {
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")

    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier{
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}


