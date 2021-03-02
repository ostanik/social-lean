//
//  FacebookView.swift
//  SocialLean_Example
//
//  Created by Alan Ostanik on 25/02/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    let loginPlatform: String

    var body: some View {
        Text("You Logged with: \(loginPlatform)")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(loginPlatform: "")
    }
}
