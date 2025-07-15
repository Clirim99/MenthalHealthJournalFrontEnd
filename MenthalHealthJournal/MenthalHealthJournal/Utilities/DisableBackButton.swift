//
//  DisableBackButton.swift
//  MenthalHealthJournal
//
//  Created by TokioMac on 15.7.25.
//

import SwiftUI

struct DisableBackSwipe: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        DispatchQueue.main.async {
            if let navController = controller.navigationController {
                navController.interactivePopGestureRecognizer?.isEnabled = false
                navController.setNavigationBarHidden(true, animated: false)
            }
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
