//
//  HomeViewController.swift
//  AppleLogin
//
//  Created by Thidar Phyo on 5/23/20.
//  Copyright © 2020 Thidar Phyo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var idTF: UITextField!
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var tokenTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idTF.isEnabled = false
        nameTF.isEnabled = false
        emailTF.isEnabled = false
        tokenTF.isEnabled = false
        navigationItem.hidesBackButton = true
        showData()
    }
    func showData() {
        idTF.text = KeychainItem.currentUserIdentifier
        nameTF.text = KeychainItem.currentUserFirstName
        emailTF.text = KeychainItem.currentUserEmail
        tokenTF.text = KeychainItem.currentToken
    }
    static func Push() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "homeVC") as? HomeViewController else {
            return
        }
        guard let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
            return
        }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    @IBAction func logoutAction(_ sender: UIBarButtonItem) {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: "Are you sure to signout?", preferredStyle: .actionSheet)

         // create an action
         let firstAction: UIAlertAction = UIAlertAction(title: "Confirm", style: .default) { action -> Void in
             print("First Action pressed")
            KeychainItem.currentUserIdentifier = nil
            KeychainItem.currentUserFirstName = nil
            KeychainItem.currentUserLastName = nil
            KeychainItem.currentUserEmail = nil
            KeychainItem.currentToken = nil
             DispatchQueue.main.async {
                 
                 let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
                 vc.modalPresentationStyle = .fullScreen
                 self.present(vc, animated: true, completion: nil)
             }
         }

         let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }

         // add actions
         actionSheetController.addAction(firstAction)
        
         

         if let popoverPresentationController = actionSheetController.popoverPresentationController {
             popoverPresentationController.barButtonItem = sender
             
         }
         else {
              actionSheetController.addAction(cancelAction)
         }
         
         present(actionSheetController, animated: true) {
             print("option menu presented")
         }
    }
    

}
