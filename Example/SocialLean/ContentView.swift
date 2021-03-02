//
//  ContentView.swift
//  Shared
//
//  Created by Alan Ostanik on 23/02/2021.
//

import SwiftUI

private enum LoginMethod: String {
    case facebook
}

struct ContentView: View {
    @ObservedObject var facebookViewModel = FacebookViewModel()
    @State var showError: Bool = false
    @State var showDetail: Bool = false
    @State private var loginMethod: LoginMethod?

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Button(action: facebookViewModel.performLogin) {
                    HStack(spacing: 10) {
                        Image("facebook")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Continue with Facebook")
                    }
                }.padding(.horizontal)
                NavigationLink(
                    destination: DetailView(loginPlatform: loginMethod?.rawValue.capitalized ?? ""),
                    isActive: $showDetail) { EmptyView() }
            }
        }
        .alert(isPresented: $showError) {
            return Alert(
                    title: Text("Error"),
                    message: Text("There is some error in your login"),
                    dismissButton: .default(Text("Ok")))
        }
        .onReceive(self.facebookViewModel.$state) { state in
            switch state {
            case .logged:
                self.loginMethod = .facebook
                self.showDetail = true
            case .failed:
                self.showError = true
            default: return
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
