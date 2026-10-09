enum AssetType { xauusd, eurusd, gbpusd, xagusd, ndx100, spx500 }

class TradingFormulas {
  /// Raw values ka difference calculate karne ke liye (Absolute values)
  static double calculateValue(double priceA, double priceB) {
    return (priceA - priceB).abs();
  }

  /// Asset ke mutabiq raw value ko Pips ya Points mein convert karna (100% Accurate)
  static double valueToPips(double value, AssetType asset) {
    switch (asset) {
      case AssetType.xauusd:
        // Gold Multiplier = 10 (0.10 price move = 1 Pip)
        return double.parse((value * 10).toStringAsFixed(2));
      case AssetType.xagusd:
        // Silver Multiplier = 1000 (0.001 price move = 1 Pip) — fixed to match broker tick size
        return double.parse((value * 1000).toStringAsFixed(2));
      case AssetType.eurusd:
      case AssetType.gbpusd:
        // Forex Majors Multiplier = 10000 (0.0001 price move = 1 Pip)
        return double.parse((value * 10000).toStringAsFixed(1));
      case AssetType.ndx100:
      case AssetType.spx500:
        // Indices direct points par move karte hain (No multiplier)
        return double.parse(value.toStringAsFixed(2));
    }
  }

  /// SPREAD-ONLY conversion: raw price difference (Ask - Bid) ko pips mein convert karna.
  /// Yeh function sirf Ask/Bid spread ke liye hai — valueToPips ko bilkul touch nahi karta.
  /// Direct pip-size division use hoti hai (jo manual confirmed example se match karti hai):
  ///   XAGUSD: pip size = 0.001  → 0.100 / 0.001 = 100 pips
  ///   XAUUSD: pip size = 0.01
  ///   EURUSD/GBPUSD: pip size = 0.0001
  ///   NDX100/SPX500: pip size = 1 (point)
  static double valueToPipsForSpread(double value, AssetType asset) {
    double pipSize;
    switch (asset) {
      case AssetType.xauusd:
        pipSize = 0.01;
        break;
      case AssetType.xagusd:
        pipSize = 0.001;
        break;
      case AssetType.eurusd:
      case AssetType.gbpusd:
        pipSize = 0.0001;
        break;
      case AssetType.ndx100:
      case AssetType.spx500:
        pipSize = 1.0;
        break;
    }
    return double.parse((value / pipSize).toStringAsFixed(2));
  }

  /// Lot size calculate karne ka exact formula matching institutional rules
  static double calculateLotSize({
    required double dollarRisk,
    required double slPips, // Points function for indices
    required AssetType asset,
  }) {
    if (slPips <= 0 || dollarRisk <= 0) return 0.00;

    double calculatedLot;
    switch (asset) {
      case AssetType.xagusd:
        // Silver Institutional Formula: Risk $ / (SL Pips * 50)
        calculatedLot = dollarRisk / (slPips * 50);
        break;
      case AssetType.ndx100:
        // NDX100 (Nasdaq) Formula: Risk $ / (SL Points * 20 Contract Size)
        calculatedLot = dollarRisk / (slPips * 20);
        break;
      case AssetType.spx500:
        // SPX500 (S&P 500) Formula: Risk $ / (SL Points * 50 Contract Size)
        calculatedLot = dollarRisk / (slPips * 50);
        break;
      case AssetType.xauusd:
      case AssetType.eurusd:
      case AssetType.gbpusd:
        // Gold aur Forex Majors Formula: Risk $ / (SL Pips * 10)
        calculatedLot = dollarRisk / (slPips * 10);
        break;
    }

    return double.parse(calculatedLot.toStringAsFixed(3));
  }

  /// Cash amount (Profit or Loss) calculate karne ka formula matching contract size
  static double calculateCashAmount({
    required double lotSize,
    required double pips,
    required AssetType asset,
  }) {
    if (lotSize <= 0 || pips <= 0) return 0.00;

    switch (asset) {
      case AssetType.xagusd:
        // Silver P&L Engine: Lot Size * Pips * 50
        return double.parse((lotSize * pips * 50).toStringAsFixed(2));
      case AssetType.ndx100:
        // NDX100 P&L Engine: Lot Size * Points * 20 Contract Size
        return double.parse((lotSize * pips * 20).toStringAsFixed(2));
      case AssetType.spx500:
        // SPX500 P&L Engine: Lot Size * Points * 50 Contract Size
        return double.parse((lotSize * pips * 50).toStringAsFixed(2));
      case AssetType.xauusd:
      case AssetType.eurusd:
      case AssetType.gbpusd:
        // Gold/Forex P&L Engine: Lot Size * Pips * 10
        return double.parse((lotSize * pips * 10).toStringAsFixed(2));
    }
  }

  /// Custom calculation for reverse engineering expected loss from Lot and Pips
  static double calculateExpectedLoss({
    required double lotSize,
    required double slPips,
    required AssetType asset,
  }) {
    if (lotSize <= 0 || slPips <= 0) return 0.00;

    switch (asset) {
      case AssetType.xagusd:
        return double.parse((lotSize * slPips * 50).toStringAsFixed(2));
      case AssetType.ndx100:
        return double.parse((lotSize * slPips * 20).toStringAsFixed(2));
      case AssetType.spx500:
        return double.parse((lotSize * slPips * 50).toStringAsFixed(2));
      case AssetType.xauusd:
      case AssetType.eurusd:
      case AssetType.gbpusd:
        return double.parse((lotSize * slPips * 10).toStringAsFixed(2));
    }
  }
}
