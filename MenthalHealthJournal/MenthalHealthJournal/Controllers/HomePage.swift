//
//  HomePage.swift
//  MenthalHealthJournal
//
//  Created by TokioMac on 28.5.25.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        ZStack{
            Text("Menthal health journal")
                .fontWeight(.ultraLight)
                .font(.system(size: 40))
            VStack{
                Image("menthalHealthLogo")
                    .resizable()
                    .frame(width: 120,height: 120)
                    .padding(.top,180)
                Spacer()
                Button("Get started") {
                    print("Button tapped!")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                Button("Already user? Log in"){
                }
                .buttonStyle(.bordered)
                .cornerRadius(10)
                .foregroundColor(.white)
            }.padding(.bottom,80)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand to fill the screen
                .background(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .ignoresSafeArea() // Optional: extend under the safe area

    }
}

#Preview {
    HomePage()
}
