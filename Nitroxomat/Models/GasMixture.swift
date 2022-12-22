//
//  GasMixture.swift
//  Nitroxomat
//
//  Created by Boris Boesler on 08.06.22.
//

import Foundation

// MARK: Gaxmixture Constants

/// the fraction of oxygen in air
let AirFractionOxygen = 0.21

// MARK: - GasMixture

/// a gas mixture can be a combination of three gases 1) oxygen
/// 2) nitrogen and 3) helium. the fraction of all three gases
/// is between 0 and 1; the sum of all fractions equals 1; the
/// fraction of nitrogen is a computed attribute
class GasMixture {
  // MARK: Lifecycle
  
  /// default init for AIR
  convenience init() {
    self.init(withOxygen: AirFractionOxygen)
  }
  
  /// init for some Nitrox
  /// - Parameter FractionOxygen: the fraction of O2 in this gas mixture
  convenience init(withOxygen FractionOxygen: Double) {
    self.init(withOxygen: FractionOxygen, withHelium: 0.0)
  }
  
  /// init for some Trimix
  /// - Parameters:
  ///   - FractionOxygen: the fraction of O2 in this gas mixture
  ///   - FractionHelium: the fraction of Helium in this gas mixture
  init(withOxygen FractionOxygen: Double, withHelium FractionHelium: Double) {
    // setter should assert that FractionOxygen + FractionHelium <= 1.0 is true
    self.FractionOxygen = FractionOxygen
    self.FractionHelium = FractionHelium
  }
  
  // MARK: Properties with getter/setter Methods
  
  /// fraction of oxygen in this gas mixture
  var FractionOxygen: Double {
    didSet {
      if FractionOxygen < 0 {
        FractionOxygen = AirFractionOxygen
      } else if FractionOxygen > 1.0 {
        FractionOxygen = 1.0 - FractionHelium
      }
      // re-size to fit current fraction of helium
      if FractionOxygen + FractionHelium > 1.0 {
        FractionOxygen = 1.0 - FractionHelium
      }
      FractionOxygen = round(FractionOxygen * 100.0) / 100.0
    }
  }
  
  /// fraction of helium in this gas mixture
  var FractionHelium: Double {
    didSet {
      if FractionHelium < 0 {
        FractionHelium = 0.0
      } else if FractionHelium > 1.0 {
        FractionHelium = 1.0 - FractionOxygen
      } else if FractionOxygen + FractionHelium > 1.0 {
        FractionHelium = 1.0 - FractionOxygen
      }
      FractionHelium = round(FractionHelium * 100.0) / 100.0
    }
  }
  
  /// fraction of nitrogen in this gas mixture
  var FractionNitrogen: Double {
    return (1.0 - FractionOxygen - FractionHelium)
  }
  
  // MARK: - Public Methods
  
  /// get the Maximum Operation of Depth (MOD) for this gas mixture and a given maximum partial pressure of O2
  /// - Parameter maxPPO2: the maximum partial pressure of O2
  /// - Returns: the MOD for this gas mixture and a given maximum partial pressure of O2
  func getMOD(withMaxPPO2 maxPPO2: Double) -> Double {
    let MOD = ((maxPPO2 / FractionOxygen) - 1.0) * 10.0
    return MOD
  }
  
  /// get the Equivalent Air Depth (EAD) for this gas mixture and a given maximum partial pressure of O2
  /// - Parameter maxPPO2: the maximum partial pressure of O2
  /// - Returns: the EAD for this gas mixture and the given maximal partial pressure of O2
  func getEAD(withMaxPPO2 maxPPO2: Double) -> Double {
    var EAD = (((100.0 - (FractionOxygen * 100.0)) * (getMOD(withMaxPPO2: maxPPO2) + 10.0)) / 79.0) - 10.0
    if EAD < 0.0 {
      EAD = 0.0
    }
    return EAD
  }
  
  /// END = ((fN2 * (Tiefe + 10)) / 0,79) - 10m
  
  /// Equivalent Narcotic Depth
  /// - Parameter Depth: the depth for which the END is computed
  /// - Returns: the END for the given depth
  func getEND(withDepth Depth: Double) -> Double {
    var END = ((FractionNitrogen * (Depth + 10.0)) / 0.79) - 10.0
    if END < 0.0 {
      END = 0.0
    }
    return END
  }
  
  /// get the best oxygen fraction for this given gas mixture and a given maximum operation of depth
  /// - Parameters:
  ///   - MaxDepth: the maximum operation of depth
  ///   - PPO2Max: the maximum partial pressure of O2
  /// - Returns: the best fraction of oxygen for this gas mixture and the given maximum of depth
  func getBestFractionO2(forMOD MaxDepth: Double, withPPO2 PPO2Max: Double) -> Double {
    var BestFracO2 = PPO2Max / ((MaxDepth / 10.0) + 1.0)
    // rounding
    BestFracO2 = round(BestFracO2 * 100.0) / 100.0
    // limit
    if BestFracO2 > 1.0 {
      BestFracO2 = 1.0
    }
    return BestFracO2
  }
} // class GasMixture
