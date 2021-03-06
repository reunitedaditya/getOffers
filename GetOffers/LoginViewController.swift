//
//  LoginViewController.swift
//  GetOffers
//
//  Created by Aditya  on 05/04/17.
//  Copyright © 2017 Aditya Yadav. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire

class LoginViewController: UIViewController {
    
    var userId : String?
    var userName : String?
    var userPhoto : String?
    var email : String?
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var imageTopLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var goOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

     self.facebookButton.isHidden = false
     self.activityIndicator.isHidden = true
    self.nameTextField.delegate = self
    self.goOutlet.isHidden = true
        
    }


    @IBAction func loginWithFacebook(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
           
            self.facebookButton.isHidden = true
            self.activityIndicator.isHidden = false
        }

        facebookLogin.logIn(withReadPermissions: ["email"], from: self, handler:{(facebookResult, facebookError) -> Void in
            
           
            
            if facebookError != nil {
  
                print("facebook login failed \(String(describing: facebookError))")
                
                
            } else if (facebookResult?.isCancelled)! {
                
                print("Cancel cancel")
                self.facebookButton.isHidden = false
                self.activityIndicator.isHidden = true
      
                
            } else {
                
                print("Success")
                

                
                UserDefaults.standard.set(true, forKey: "accessStatus")
                
                //success
                
                self.fetchFacebookData()
                
            }
        })
 
    }
    
    
    
    //Fetch Data from facebook
    
    func fetchFacebookData(){
        
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,email, picture.type(large)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error: \(String(describing: error))")
            }
            else
            {
                
                
                let data:[String:AnyObject] = result as! [String : AnyObject]
                
                
                self.userId = data["id"] as! String!
                
                 self.userName = data["first_name"] as? String
                
                
                 self.userPhoto = "http://graph.facebook.com/\(self.userId!)/picture?type=large"
                
                 self.email = data["email"] as? String
                
                self.sendDataToServer(userName: self.userName!, userEmail: self.email!)
                
               

            }
            
            
        })
        
    }
    
    
    // Send Data to server
    
    func sendDataToServer(userName : String , userEmail : String){
        
        let parameters = ["userName" : userName , "userEmail" : userEmail]
        
        Alamofire.request("http://go.graymatrix.com/api/register-user", method: .post, parameters: parameters).responseJSON { response in
         
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                if let object = JSON as? NSDictionary {
                    // json is a dictionary
                    
                    let data =  object.value(forKey: "data") as! Int
                    let success = object.value(forKey: "success")  as! Int
                    
                    let userDetails = String(data)
                   UserDefaults.standard.set(userDetails, forKey: "userDetails")
                   
                    print("data is \(data) success is \(success)")
                    
                    if success == 1 {
                       
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
                        self.present(controller, animated: true, completion: nil)
                        
                    } else {
                        
                        let alert : UIAlertController = UIAlertController(title: "Login Failed", message: "Please try again", preferredStyle: .alert)
                        
                        let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                        
                        alert.addAction(alertAction)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        self.activityIndicator.isHidden = true
                        self.facebookButton.isHidden = false
                    }
                    
                }
                
               
            }
        }

    }
    
    
    @IBAction func goAction(_ sender: Any) {
        
        if nameTextField.text != "" {
            print(nameTextField.text!)
            nameTextField.resignFirstResponder()
            UserDefaults.standard.set(true, forKey: "accessStatus")
            
            let userName = nameTextField.text!
            let udid = UIDevice.current.identifierForVendor!.uuidString
            let userEmail = "\(udid)@yopmail.com"
            
            self.sendDataToServer(userName: userName, userEmail: userEmail)
            
      
            
            
            
        } else {
            
            let alert = UIAlertController(title: "Please entert your name", message: "", preferredStyle: .alert)
            let alertAction =   UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    

}

extension LoginViewController : UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
 
        self.imageTopLayoutConstraint.constant = -85.0
        self.goOutlet.isHidden = false
    }

}



