//
//  ContentView.swift
//  Nitroxomat
//
//  Created by Boris Boesler on 08.06.22.
//

import os
import SwiftUI

// MARK: - General Constant Values

/// default value for minimal partial pressure of O2
let PPO2Minimum = 1.2
/// default value for maximal partial pressure of O2
let PPO2Maximum = 1.6
/// default value for partial pressure of O2
let defaultPPO2Value = 1.4

/// default value for minimal fraction of O2
let FO2Minimum = 0.15
/// default value for maximal fraction of O2
let FO2Maximum = 1.0
/// default value for fraction of O2
let defaultFO2Value = 0.21

/// default value for minimal MOD
let MODMinimum = 0.0
/// default value for maximal MOD
let MODMaximum = 100.0

/// default value for minimal EAD
let EADMinimum = 0.0
/// default value for maximal EAD
let EADMaximum = 110.0

// MARK: - Nitroxomat Constants

/// the appname
let appName = "Nitroxomat"

// MARK: - Nitroxomat Loggers

import XCGLogger
// In your AppDelegate (or other global file), declare a global constant to the default XCGLogger instance.

let loggerMix = XCGLogger(identifier: "Nitroxomoat (Mixture)")
let loggerGUI = XCGLogger(identifier: "Nitroxomoat (GUI)")

// MARK: - Nitroxomat User Defaults

/// key to store the PPO2 value
let keyPPO2 = "ppO2"
/// key to store the FO2 value
let keyFO2 = "fO2"
/// key to store if the legal notice should be displayed
let keyShowLegalNotice = "showLegalNotice"

let defaults = UserDefaults.standard

/// read partial pressure of O2 from settings or use defaultPPO2Value
let defaultPPO2: Double = defaults.object(forKey: keyPPO2) as? Double ?? defaultPPO2Value
/// read fraction of O2 from settings or use defaultFO2Value
let defaultFO2: Double = defaults.object(forKey: keyFO2) as? Double ?? defaultFO2Value

/// check if the user confirmed to be a certified Nitrox diver
#if DEBUG
private let defaultShowLegalNotice = true
#else
private let defaultShowLegalNotice = defaults.object(forKey: keyShowLegalNotice) as? Bool ?? true
#endif

// MARK: - Nitroxomat UI Configurtion

// MARK: - Nitroxomat Global Variables

/// create a nitrox calculator with default PPO2 and PO2
var gasMixture = GasMixture(withOxygen: defaultFO2)

// MARK: - Views: ContentView

struct ContentView: View {
  /// the current PPO2
  @State private var PPO2Value: Double = defaultPPO2
  /// the current fO2
  @State private var FO2Value: Double = defaultFO2
  /// the current MOD
  @State private var MODValue: Double = gasMixture.getMOD(withMaxPPO2: defaultPPO2)
  /// the current EAD
  @State private var EADValue: Double = gasMixture.getEAD(withMaxPPO2: defaultPPO2)

  @State private var showLegalNotice: Bool = defaultShowLegalNotice

  // the interface on the screen
  var body: some View {
    NavigationView {
      VStack {
        // the PPO2 Slider
        PPO2View(PPO2Value: $PPO2Value, MODValue: $MODValue, EADValue: $EADValue)

        // second Spacer
        Spacer()

        // the FO2 slider with a label
        FO2View(PPO2Value: $PPO2Value, FO2Value: $FO2Value, MODValue: $MODValue, EADValue: $EADValue)

        // third Spacer
        Spacer()

        // the MOD slider with a label
        MODView(PPO2Value: $PPO2Value, FO2Value: $FO2Value, MODValue: $MODValue, EADValue: $EADValue)

        // fourth spacer
        Spacer()

        // the EAD slider with a label
        EADView(PPO2Value: $PPO2Value, FO2Value: $FO2Value, MODValue: $MODValue, EADValue: $EADValue)
      } // VStack
      .padding(30)
      .navigationBarTitle(appName)
      .navigationBarItems(
        leading:
          Button(action: {
            // reset to default PPO2 and gas-mixture AIR
            self.PPO2Value = defaultPPO2Value
            defaults.set(PPO2Value, forKey: keyPPO2)

            self.FO2Value = defaultFO2Value
            defaults.set(FO2Value, forKey: keyFO2)
            gasMixture.fractionOxygen = FO2Value

            // update UI - does not work
            self.MODValue = gasMixture.getMOD(withMaxPPO2: self.PPO2Value)
            self.EADValue = gasMixture.getEAD(withMaxPPO2: self.PPO2Value)

            loggerGUI.debug("reset sliders")
            loggerMix.debug("MOD (maxPPO2:\(self.PPO2Value), fO2:\(gasMixture.fractionOxygen)) = \(self.MODValue)")
            loggerMix.debug("EAD (maxPPO2:\(self.PPO2Value), MOD:\(self.MODValue) = \(self.EADValue)")
          }, label: { Text("Reset") }),
        trailing:
          NavigationLink(destination: AboutView()) {
            HStack {
              Image(systemName: "info.circle")
                .imageScale(.large)
            }
          }
      )

    } // NavigationView
    .navigationViewStyle(StackNavigationViewStyle())
    // let the user confirm that (s)he is a certified nitrox diver
    .sheet(isPresented: self.$showLegalNotice,
           onDismiss: {
      self.showLegalNotice = false
      defaults.set(self.showLegalNotice, forKey: keyShowLegalNotice)
      loggerGUI.debug("set defaults.\(keyShowLegalNotice) notice to \(self.showLegalNotice)")
    },
           content: { LegalNoticeView() })
  } // var body: some View
} // struct ContentView: View

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
