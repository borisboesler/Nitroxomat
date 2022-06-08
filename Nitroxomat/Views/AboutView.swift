//
//  AboutView.swift
//  Nitroxomat
//
//  Created by Boris Boesler on 08.06.22.
//

import SwiftUI

private let BundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "no build"
private let BundleShortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "no version"

// MARK: - Views: AboutView

struct AboutView: View {
  var body: some View {
    VStack {
      Spacer()
      Text(AppName)
        .font(.title)
      Spacer()
      Text("Copyright ©2022 Boris Boesler")
        .font(.title2)
      Spacer()
      Text("Version: \(BundleShortVersion)")
        .font(.title2)
#if DEBUG
      Spacer()
      VStack {
        Text("DEBUG Build")
        Text("Bundle version: \(BundleVersion)")
      }
      .padding(5)
      .background(Color.red)
      .cornerRadius(10)
#endif
      Spacer()
    }
    .padding(5)
    .navigationBarTitle("About " + AppName, displayMode: .inline)
  }
}

// MARK: - AboutView_Previews

struct AboutView_Previews: PreviewProvider {
  static var previews: some View {
    AboutView()
  }
}
