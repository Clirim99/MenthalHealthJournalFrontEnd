//
//  ChangePasswordController.swift
//  MenthalHealthJournal
//
//  Created by TokioMac on 5.5.26.
//

import UIKit
import SwiftUI

class ChangePasswordController: UIViewController {

    
    @IBOutlet var ChangePasswordView: UIView!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ConfirmPassword: UITextField!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            addSwiftUIBackground()
            setupUI()
        }
        
    @IBAction func ChangePasswordFunc(_ sender: Any) {
        // api qe ka me ndrru passwordin
    }
    
    // MARK: - Injects SwiftUI Gradient into UIKit
        private func addSwiftUIBackground() {
            // Create a SwiftUI view with your exact AppTheme gradient
            let gradientView = AppTheme.backgroundGradient.ignoresSafeArea()
            let hostingController = UIHostingController(rootView: gradientView)
            
            // Add it as a child view controller
            addChild(hostingController)
            
            // Insert the gradient view at the very back (index 0) so it doesn't cover your inputs
            view.insertSubview(hostingController.view, at: 0)
            
            // Make sure it stretches to fill the whole screen
            hostingController.view.frame = view.bounds
            hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            hostingController.didMove(toParent: self)
        }
        
        private func setupUI() {
            // MARK: - Make Background Transparent
            // Keep these clear so the gradient we just added at index 0 shows through!
            self.view.backgroundColor = .clear
            ChangePasswordView.backgroundColor = .clear
                
            // MARK: - Text Field Styling Helper
            func styleTextField(_ textField: UITextField) {
                textField.backgroundColor = UIColor(AppTheme.inputBg)
                textField.textColor = UIColor(AppTheme.textPrimary)
                textField.layer.cornerRadius = 12
                textField.layer.borderWidth = 1
                textField.layer.borderColor = UIColor(AppTheme.border).cgColor
                
                // Mask the typed text for security
                textField.isSecureTextEntry = true
                    
                // Add internal padding to match SwiftUI's .padding(14)
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 50))
                textField.leftView = paddingView
                textField.rightView = paddingView
                textField.leftViewMode = .always
                textField.rightViewMode = .always
            }
                
            // Apply the styling to both password fields
            styleTextField(PasswordTextField)
            styleTextField(ConfirmPassword)
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
