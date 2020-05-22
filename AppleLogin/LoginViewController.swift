//
//  LoginViewController.swift
//  AppleLogin
//
//  Created by Thidar Phyo on 5/23/20.
//  Copyright © 2020 Thidar Phyo. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: MyAuthorizationAppleIDButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //performExistingAccountSetupFlows()
    }
    @objc
    func didTapAppleButton() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
    }
    private func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
            
        case let credentials as ASAuthorizationAppleIDCredential:
            //let user = User(credentials: credentials)
            
            KeychainItem.currentUserIdentifier = credentials.user
            KeychainItem.currentUserFirstName = "\(credentials.fullName?.givenName ?? "") \(credentials.fullName?.familyName ?? "")"
            KeychainItem.currentUserLastName = credentials.fullName?.familyName
            KeychainItem.currentUserEmail = credentials.email
            let token = credentials.identityToken
            let identityTokenString = String(data: token!, encoding: .utf8)
            KeychainItem.currentToken = identityTokenString
            
            let nav = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeNav") as! UINavigationController
            let vc = nav.viewControllers[0] as! HomeViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
            
        default: break
            
        }
        
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("something bad happened", error)
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return view.window!
        
    }
    
    
}
