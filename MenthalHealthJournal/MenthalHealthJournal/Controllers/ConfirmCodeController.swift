//
//  ConfirmCodeController.swift
//  MenthalHealthJournal
//
//  Created by TokioMac on 5.5.26.
//

import UIKit
import SwiftUI

class ConfirmCodeController: UIViewController {

    @IBOutlet var ConfirmCodeView: UIView!
    @IBOutlet weak var ConfirmCodeTextField: UITextField!
    @IBOutlet weak var SendCode: UIButton!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            addSwiftUIBackground() // 1. Inject the SwiftUI gradient
            setupUI()              // 2. Setup the rest of your UI
        }
        
    @IBAction func SendCodeFunc(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            // 2. Instantiate the next controller
            let nextVC = storyboard.instantiateViewController(withIdentifier: "ConfirmCodeController")
            
            self.navigationController?.pushViewController(nextVC, animated: true)

    }
    
    // Create a SwiftUI view with your exact AppTheme gradient
    private func addSwiftUIBackground() {
            let gradientView = AppTheme.backgroundGradient.ignoresSafeArea()
            let hostingController = UIHostingController(rootView: gradientView)
            
            // Add it as a child view controller
            addChild(hostingController)
            
            // Insert the gradient view at the very back (index 0) so it doesn't cover your buttons
            view.insertSubview(hostingController.view, at: 0)
            
            // Make sure it stretches to fill the whole screen
            hostingController.view.frame = view.bounds
            hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            hostingController.didMove(toParent: self)
        }
        
        private func setupUI() {
            // Keep these clear so the gradient we just added at index 0 shows through!
            self.view.backgroundColor = .clear
            ConfirmCodeView.backgroundColor = .clear
                
            // MARK: - Text Field Styling
            ConfirmCodeTextField.backgroundColor = UIColor(AppTheme.inputBg)
            ConfirmCodeTextField.textColor = UIColor(AppTheme.textPrimary)
            ConfirmCodeTextField.layer.cornerRadius = 12
            ConfirmCodeTextField.layer.borderWidth = 1
            ConfirmCodeTextField.layer.borderColor = UIColor(AppTheme.border).cgColor
                
            // Add internal padding
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 50))
            ConfirmCodeTextField.leftView = paddingView
            ConfirmCodeTextField.rightView = paddingView
            ConfirmCodeTextField.leftViewMode = .always
            ConfirmCodeTextField.rightViewMode = .always
                
            // MARK: - Button Styling
            SendCode.backgroundColor = UIColor(AppTheme.accent)
            SendCode.tintColor = .white
            SendCode.layer.cornerRadius = 14
            SendCode.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        }
    }
