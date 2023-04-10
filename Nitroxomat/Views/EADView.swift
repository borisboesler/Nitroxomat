//
//  EADView.swift
//  Nitroxomat
//
//  Created by Boris Boesler on 08.06.22.
//

import SwiftUI

// MARK: - EADView

struct EADView: View {
  @Binding var PPO2Value: Double
  @Binding var FO2Value: Double
  @Binding var MODValue: Double
  @Binding var EADValue: Double

  var body: some View {
    VStack {
      // Text("EAD: \(Nitrox.getEAD(withMaxPPO2: PPO2Value), specifier: "%3.1f")m")
      Text("EAD: \(EADValue + 0.05, specifier: "%3.1f")m") // round down
      /* */
      Slider(value: $EADValue, in: EADMinimum ... EADMaximum, step: 1.0,
             minimumValueLabel: Text("\(Int(EADMinimum))m"),
             maximumValueLabel: Text("\(Int(EADMaximum))m"),
             label: { Text("") }) // TODO: Give the label some sense to live.
        .accentColor(Color.blue)
        .disabled(true)
    }
    // .background(Color.gray)
    // or
    // .border(Color.purple, width: 5/*, cornerRadius: 20*/)
    // or
    // .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
    // or
    // .padding(5).background(Color.gray).cornerRadius(10)
  } // var body
}

#if TRUE_EQUALS_FALSE
  struct EADView_Previews: PreviewProvider {
    /// the current PPO2
    @State private var PPO2Value: Double = defaultPPO2
    /// the current fO2
    @State private var FO2Value: Double = defaultFO2
    /// the current MOD
    @State private var MODValue: Double = gasMixture.getMOD(withMaxPPO2: defaultPPO2)
    /// the current EAD
    @State private var EADValue: Double = gasMixture.getEAD(withMaxPPO2: defaultPPO2)

    static var previews: some View {
      // FIXME: How do we fix this?
      EADView(PPO2Value: $PPO2Value, FO2Value: $FO2Value,
              MODValue: $MODValue, EADValue: $EADValue)
    }
  }
#endif
