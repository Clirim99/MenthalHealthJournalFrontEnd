//
//  test.swift
//  MenthalHealthJournal
//
//  Created by TokioMac on 5.5.26.
//

import SwiftUI
import UIKit

struct ForgotPasswordViewWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        // Change "Main" to your actual storyboard name if it's different
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Ensure you set the Storyboard ID of your View Controller to "ForgotPasswordVC" in Interface Builder
        return storyboard.instantiateViewController(withIdentifier: "ForgotPasswordSendCode")
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates needed for a simple presentation
    }
}
