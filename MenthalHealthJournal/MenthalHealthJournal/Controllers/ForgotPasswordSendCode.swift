//
//  ForgotPasswordSendCode.swift
//  MenthalHealthJournal
//
//  Created by TokioMac on 5.5.26.
//

import UIKit

class ForgotPasswordSendCode: UIViewController {

    @IBOutlet var SendCodeView: UIView!
    @IBOutlet weak var SendCodeButton: UIButton!
    @IBOutlet weak var EmailTextField: UITextField!
    override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
        }
    
    
    @IBAction func SendCodeFunc(_ sender: Any) {
            // 1. Get the current storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            // 2. Instantiate the next controller using its Storyboard ID.
            // Replace "ConfirmCodeVC" with the actual Storyboard ID you set in Xcode.
            let nextVC = storyboard.instantiateViewController(withIdentifier: "ConfirmCodeController")
            
            // 3. Choose how you want it to appear:
            
            // --> Use this to slide it up over the current screen (Modal)
            self.navigationController?.pushViewController(nextVC, animated: true)
            
            // --> OR use this to slide it in from the right (Requires a Navigation Controller)
            // self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
        
        private func setupUI() {
            // MARK: - Make Background Transparent
            // This allows the SwiftUI gradient to show through from behind
            self.view.backgroundColor = .clear
            SendCodeView.backgroundColor = .clear
            
            // MARK: - Email Text Field Styling
            EmailTextField.backgroundColor = UIColor(AppTheme.inputBg)
            EmailTextField.textColor = UIColor(AppTheme.textPrimary)
            EmailTextField.layer.cornerRadius = 12
            EmailTextField.layer.borderWidth = 1
            EmailTextField.layer.borderColor = UIColor(AppTheme.border).cgColor
            
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 50))
            EmailTextField.leftView = paddingView
            EmailTextField.rightView = paddingView
            EmailTextField.leftViewMode = .always
            EmailTextField.rightViewMode = .always
            
            // MARK: - Send Code Button Styling
            SendCodeButton.backgroundColor = UIColor(AppTheme.accent)
            SendCodeButton.setTitleColor(.white, for: .normal)
            SendCodeButton.layer.cornerRadius = 14
            SendCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        }
    }
