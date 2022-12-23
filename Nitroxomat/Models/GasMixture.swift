//
//  GasMixture.swift
//  Nitroxomat
//
//  Created by Boris Boesler on 08.06.22.
//

import Foundation

// MARK: Gaxmixture Constants

/// the fraction of oxygen in air
let airFractionOxygen = 0.21

// MARK: - GasMixture

/// a gas mixture can be a combination of three gases 1) oxygen
/// 2) nitrogen and 3) helium. the fraction of all three gases
/// is between 0 and 1; the sum of all fractions equals 1; the
/// fraction of nitrogen is a computed attribute
class GasMixture {
  // MARK: Lifecycle
  
  /// default init for AIR
  convenience init() {
    self.init(withOxygen: airFractionOxygen)
  }
  
  /// init for some Nitrox
  /// - Parameter FractionOxygen: the fraction of O2 in this gas mixture
  convenience init(withOxygen fractionOxygen: Double) {
    self.init(withOxygen: fractionOxygen, withHelium: 0.0)
  }
  
  /// init for some Trimix
  /// - Parameters:
  ///   - FractionOxygen: the fraction of O2 in this gas mixture
  ///   - FractionHelium: the fraction of Helium in this gas mixture
  init(withOxygen fractionOxygen: Double, withHelium fractionHelium: Double) {
    // setter should assert that FractionOxygen + FractionHelium <= 1.0 is true
    self.fractionOxygen = fractionOxygen
    self.fractionHelium = fractionHelium
  }
  
  // MARK: Properties with getter/setter Methods
  
  /// fraction of oxygen in this gas mixture
  var fractionOxygen: Double {
    didSet {
      if fractionOxygen < 0 {
        fractionOxygen = airFractionOxygen
      } else if fractionOxygen > 1.0 {
        fractionOxygen = 1.0 - fractionHelium
      }
      // re-size to fit current fraction of helium
      if fractionOxygen + fractionHelium > 1.0 {
        fractionOxygen = 1.0 - fractionHelium
      }
      fractionOxygen = round(fractionOxygen * 100.0) / 100.0
    }
  }
  
  /// fraction of helium in this gas mixture
  var fractionHelium: Double {
    didSet {
      if fractionHelium < 0 {
        fractionHelium = 0.0
      } else if fractionHelium > 1.0 {
        fractionHelium = 1.0 - fractionOxygen
      } else if fractionOxygen + fractionHelium > 1.0 {
        fractionHelium = 1.0 - fractionOxygen
      }
      fractionHelium = round(fractionHelium * 100.0) / 100.0
    }
  }
  
  /// fraction of nitrogen in this gas mixture
  var fractionNitrogen: Double {
    return (1.0 - fractionOxygen - fractionHelium)
  }
  
  // MARK: - Public Methods
  
  /// get the Maximum Operation of Depth (MOD) for this gas mixture and a given maximum partial pressure of O2
  /// - Parameter maxPPO2: the maximum partial pressure of O2
  /// - Returns: the MOD for this gas mixture and a given maximum partial pressure of O2
  func getMOD(withMaxPPO2 maxPPO2: Double) -> Double {
    let MOD = ((maxPPO2 / fractionOxygen) - 1.0) * 10.0
    return MOD
  }
  
  /// get the Equivalent Air Depth (EAD) for this gas mixture and a given maximum partial pressure of O2
  /// - Parameter maxPPO2: the maximum partial pressure of O2
  /// - Returns: the EAD for this gas mixture and the given maximal partial pressure of O2
  func getEAD(withMaxPPO2 maxPPO2: Double) -> Double {
    var EAD = (((100.0 - (fractionOxygen * 100.0)) * (getMOD(withMaxPPO2: maxPPO2) + 10.0)) / 79.0) - 10.0
    if EAD < 0.0 {
      EAD = 0.0
    }
    return EAD
  }
  
  /// END = ((fN2 * (Tiefe + 10)) / 0,79) - 10m
  
  /// Equivalent Narcotic Depth
  /// - Parameter Depth: the depth for which the END is computed
  /// - Returns: the END for the given depth
  func getEND(withDepth depth: Double) -> Double {
    var END = ((fractionNitrogen * (depth + 10.0)) / 0.79) - 10.0
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
  func getBestFractionO2(forMOD maxDepth: Double, withPPO2 maxPPO2: Double) -> Double {
    var bestFracO2 = maxPPO2 / ((maxDepth / 10.0) + 1.0)
    // rounding
    bestFracO2 = round(bestFracO2 * 100.0) / 100.0
    // limit
    if bestFracO2 > 1.0 {
      bestFracO2 = 1.0
    }
    return bestFracO2
  }
} // class GasMixture
