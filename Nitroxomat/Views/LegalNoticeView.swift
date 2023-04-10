//
//  LegalNoticeView.swift
//  Nitroxomat
//
//  Created by Boris Boesler on 08.06.22.
//

import SwiftUI

// MARK: - LegalNoticeView

struct LegalNoticeView: View {
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    VStack {
      Spacer()

      Text("The user confirms to be a certified Nitrox diver.")
        .multilineTextAlignment(.center)

      Text("The software is for entertaining purposes.")
        .multilineTextAlignment(.center)

      Text("Use at your own risk.")
        .multilineTextAlignment(.center)

      Text("The authors of this software are not reliable for any damage or anything else.")
        .multilineTextAlignment(.center)

      Spacer()

      Button(action: {
        print("OK")
        self.presentationMode.wrappedValue.dismiss()
      }, label: { Text("I'm a certified Nitrox diver") })
        .padding(.bottom, 50)
    }
    .padding(50)
  }
}

// MARK: - LegalNoticeView_Previews

struct LegalNoticeView_Previews: PreviewProvider {
  static var previews: some View {
    LegalNoticeView()
  }
}
