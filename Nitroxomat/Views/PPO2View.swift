//
//  PPO2View.swift
//  Nitroxomat
//
//  Created by Boris Boesler on 08.06.22.
//

import SwiftUI

// MARK: - Views: PPO2View

struct PPO2View: View {
  @Binding var PPO2Value: Double
  @Binding var MODValue: Double
  @Binding var EADValue: Double
  
  var body: some View {
    VStack {
      Text("ppO2 (bar)")
      // TODO: need continuous updates: https://stackoverflow.com/questions/56725084/swiftui-how-to-get-continuous-updates-from-slider
      Slider(value: $PPO2Value, in: PPO2Minimum ... PPO2Maximum, step: 0.1,
             onEditingChanged: { _ in
        // store value in user defaults
        defaults.set(PPO2Value, forKey: KeyPPO2)
        // log using slider
        loggerGUI.debug("slider ppO2 moved to \(PPO2Value)")
        
        // update UI
        self.MODValue = Nitrox.getMOD(withMaxPPO2: self.PPO2Value)
        self.EADValue = Nitrox.getEAD(withMaxPPO2: self.PPO2Value)
        
        loggerMix.debug("MOD (maxPPO2:\(self.PPO2Value), fO2:\(Nitrox.FractionOxygen)) = \(self.MODValue)")
        loggerMix.debug("EAD (maxPPO2:\(self.PPO2Value), MOD:\(self.MODValue) = \(self.EADValue)")
      }
             // minimumValueLabel and maximumValueLabel have no advantage here
      ) { Text("") } // don't know what this text is for, it does not appear, but is needed
        .accentColor(Color.green)
      
      HStack {
        // this is not nice, but better than fixed
        Text("\(PPO2Minimum, specifier: "%1.1f")")
        ForEach(Int(PPO2Minimum * 10.0 + 1.0) ... Int(PPO2Maximum * 10.0), id: \.self) { ppo2 in
          HStack { Spacer(); Text("\(Float(ppo2) / 10.0, specifier: "%1.1f")") }
        }
      }
    }
    // .background(Color.green, cornerRadius: 20)
    // or
    // .border(Color.green, width: 5 /* , cornerRadius: 20 */ )
    // or
    // .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
    // or
    // .padding(5).background(Color.green).cornerRadius(10)
  } // var body
}

#if TRUE_EQUALS_FALSE
struct PPO2View_Previews: PreviewProvider {
  static var previews: some View {
    PPO2View(PPO2Value: $PPO2Value, MODValue: $MODValue, EADValue: $EADValue)
  }
}
#endif
