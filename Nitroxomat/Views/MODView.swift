//
//  MODView.swift
//  Nitroxomat
//
//  Created by Boris Boesler on 08.06.22.
//

import SwiftUI

// MARK: - Views: ModView

struct MODView: View {
  @Binding var PPO2Value: Double
  @Binding var FO2Value: Double
  @Binding var MODValue: Double
  @Binding var EADValue: Double
  
  var body: some View {
    VStack {
      Text("MOD: \(MODValue, specifier: "%3.1f")m") // round up
      Slider(value: $MODValue, in: MODMinimum ... MODMaximum, step: 1.0,
             onEditingChanged: { _ in
        FO2Value = gasMixture.getBestFractionO2(forMOD: MODValue, withPPO2: PPO2Value)
        defaults.set(FO2Value, forKey: keyFO2)
        // set FO2 in gas mixture
        gasMixture.fractionOxygen = FO2Value
        
        loggerGUI.debug("slider MOD moved to \(MODValue)")
        
        // update UI - does not work
        self.MODValue = gasMixture.getMOD(withMaxPPO2: self.PPO2Value)
        self.EADValue = gasMixture.getEAD(withMaxPPO2: self.PPO2Value)
        
        loggerMix.debug("MOD (maxPPO2:\(self.PPO2Value), fO2:\(gasMixture.fractionOxygen)) = \(self.MODValue)")
        loggerMix.debug("EAD (maxPPO2:\(self.PPO2Value), MOD:\(self.MODValue) = \(self.EADValue)")
      },
             minimumValueLabel: Text("\(Int(MODMinimum))m"),
             maximumValueLabel: Text("\(Int(MODMaximum))m")) { Text("") } // don't know what tis text is for, it does not appear
        .accentColor(Color.blue)
    }
    // .background(Color.gray)
    // or
    // .border(Color.purple, width: 5/*, cornerRadius: 20*/)
    // or
    // .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
    // or
    // .padding(5).background(Color.blue).cornerRadius(10)
  } // var body
}

#if TRUE_EQUALS_FALSE
struct MODView_Previews: PreviewProvider {
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
    MODView(PPO2Value: $PPO2Value, FO2Value: $FO2Value, MODValue: $MODValue, EADValue: $EADValue)
  }
}
#endif
