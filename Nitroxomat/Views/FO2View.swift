//
//  FO2View.swift
//  Nitroxomat
//
//  Created by Boris Boesler on 08.06.22.
//

import SwiftUI

// MARK: - FO2View

struct FO2View: View {
  @Binding var PPO2Value: Double
  @Binding var FO2Value: Double
  @Binding var MODValue: Double
  @Binding var EADValue: Double

  var body: some View {
    VStack {
      Text("fO2: \(Int(FO2Value * 100.0))%")
      Slider(value: $FO2Value, in: FO2Minimum ... FO2Maximum, step: 0.010,
             onEditingChanged: { _ in
               // round FO2Value properly, this is a bugfix
               FO2Value = Double(Int(FO2Value * 100.0)) / 100.0
               // store value in user defaults
               defaults.set(FO2Value, forKey: keyFO2)
               // set FO2 in gas mixture
               gasMixture.fractionOxygen = FO2Value
               // log using slider
               loggerGUI.debug("slider fO2 moved to \(FO2Value)")

               // update UI - does not work
               self.MODValue = gasMixture.getMOD(withMaxPPO2: self.PPO2Value)
               self.EADValue = gasMixture.getEAD(withMaxPPO2: self.PPO2Value)

               loggerMix.debug("MOD (maxPPO2:\(self.PPO2Value), fO2:\(gasMixture.fractionOxygen)) = \(self.MODValue)")
               loggerMix.debug("EAD (maxPPO2:\(self.PPO2Value), MOD:\(self.MODValue) = \(self.EADValue)")
             },
             minimumValueLabel: Text("\(Int(FO2Minimum * 100.0))%"),
             maximumValueLabel: Text("\(Int(FO2Maximum * 100.0))%"),
             label: { Text("") })
        .accentColor(Color.green)
    }
    // .background(Color.gray)
    // or
    // .border(Color.purple, width: 5/*, cornerRadius: 20*/)
    // or
    // .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
  } // var body
}

#if TRUE_EQUALS_FALSE
  struct FO2View_Previews: PreviewProvider {
    static var previews: some View {
      // FIXME: How do we fix this?
      FO2View(PPO2Value: $PPO2Value, FO2Value: $FO2Value, MODValue: $MODValue, EADValue: $EADValue)
    }
  }
#endif
