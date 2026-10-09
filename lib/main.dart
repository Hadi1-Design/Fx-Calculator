// // lib/main.dart
// import 'package:flutter/material.dart';
// import 'formulas.dart';
// import 'ui_components.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Pip Calculator',
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: const Color(0xFF0B0F19),
//       ),
//       home: const MainNavigationShell(),
//     );
//   }
// }

// class MainNavigationShell extends StatefulWidget {
//   const MainNavigationShell({super.key});

//   @override
//   State<MainNavigationShell> createState() => _MainNavigationShellState();
// }

// class _MainNavigationShellState extends State<MainNavigationShell> {
//   int _selectedIndex = 0;
//   AssetType _selectedAsset = AssetType.xauusd;

//   @override
//   Widget build(BuildContext context) {
//     final dropdownSelector = Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1F2937),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<AssetType>(
//           value: _selectedAsset,
//           dropdownColor: const Color(0xFF111827),
//           icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF10B981)),
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//             fontSize: 14,
//           ),
//           onChanged: (AssetType? newValue) {
//             if (newValue != null) {
//               setState(() {
//                 _selectedAsset = newValue;
//               });
//             }
//           },
//           items: const [
//             DropdownMenuItem(value: AssetType.xauusd, child: Text("XAUUSD")),
//             DropdownMenuItem(value: AssetType.xagusd, child: Text("XAGUSD")),
//             DropdownMenuItem(value: AssetType.eurusd, child: Text("EURUSD")),
//             DropdownMenuItem(value: AssetType.gbpusd, child: Text("GBPUSD")),
//             DropdownMenuItem(value: AssetType.ndx100, child: Text("NDX100")),
//             DropdownMenuItem(value: AssetType.spx500, child: Text("SPX500")),
//           ],
//         ),
//       ),
//     );

//     final List<Widget> pages = [
//       ManualPipsPage(selectedAsset: _selectedAsset),
//       EntryExitPage(selectedAsset: _selectedAsset),
//       ExpectedLossPage(selectedAsset: _selectedAsset),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Ahad's FxCalculator",
//           style: TextStyle(
//             color: Colors.yellow,
//             fontSize: 15,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 1,
//           ),
//         ),
//         backgroundColor: const Color(0xFF111827),
//         elevation: 0,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 12.0),
//             child: Center(child: dropdownSelector),
//           ),
//         ],
//       ),
//       body: IndexedStack(index: _selectedIndex, children: pages),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) => setState(() => _selectedIndex = index),
//         backgroundColor: const Color(0xFF111827),
//         selectedItemColor: const Color(0xFF10B981),
//         unselectedItemColor: Colors.grey,
//         selectedLabelStyle: const TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 11,
//         ),
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.tune_rounded),
//             label: 'By Manual Pips',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.analytics_rounded),
//             label: 'By Entry/Exit',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.gavel_rounded),
//             label: 'Expected Risk',
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Utility function to get the localized pip/point name based on selected Asset
// String getUnitLabel(AssetType asset) {
//   if (asset == AssetType.ndx100 || asset == AssetType.spx500) {
//     return 'Points';
//   }
//   return 'Pips';
// }

// // ==========================================
// // SCREEN 1: BY MANUAL PIPS (ISOLATED)
// // ==========================================
// class ManualPipsPage extends StatefulWidget {
//   final AssetType selectedAsset;
//   const ManualPipsPage({super.key, required this.selectedAsset});

//   @override
//   State<ManualPipsPage> createState() => _ManualPipsPageState();
// }

// class _ManualPipsPageState extends State<ManualPipsPage> {
//   final Map<AssetType, TextEditingController> _riskControllers = {
//     AssetType.xauusd: TextEditingController(),
//     AssetType.xagusd: TextEditingController(),
//     AssetType.eurusd: TextEditingController(),
//     AssetType.gbpusd: TextEditingController(),
//     AssetType.ndx100: TextEditingController(),
//     AssetType.spx500: TextEditingController(),
//   };

//   final Map<AssetType, TextEditingController> _pipControllers = {
//     AssetType.xauusd: TextEditingController(),
//     AssetType.xagusd: TextEditingController(),
//     AssetType.eurusd: TextEditingController(),
//     AssetType.gbpusd: TextEditingController(),
//     AssetType.ndx100: TextEditingController(),
//     AssetType.spx500: TextEditingController(),
//   };

//   final Map<AssetType, TextEditingController> _rrControllers = {
//     AssetType.xauusd: TextEditingController(),
//     AssetType.xagusd: TextEditingController(),
//     AssetType.eurusd: TextEditingController(),
//     AssetType.gbpusd: TextEditingController(),
//     AssetType.ndx100: TextEditingController(),
//     AssetType.spx500: TextEditingController(),
//   };

//   double _calculatedLot = 0.00;
//   double _finalPips = 0.0;
//   double _dollarRisk = 0.0;
//   double _targetProfitCash = 0.0;

//   @override
//   void didUpdateWidget(covariant ManualPipsPage oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     _processCalculations();
//   }

//   void _processCalculations() {
//     final asset = widget.selectedAsset;
//     double dollarRiskInput =
//         double.tryParse(_riskControllers[asset]!.text) ?? 0.0;
//     double manualPips = double.tryParse(_pipControllers[asset]!.text) ?? 0.0;
//     double rrRatio = double.tryParse(_rrControllers[asset]!.text) ?? 0.0;

//     setState(() {
//       _dollarRisk = dollarRiskInput;
//       _finalPips = manualPips;

//       _calculatedLot = TradingFormulas.calculateLotSize(
//         dollarRisk: _dollarRisk,
//         slPips: _finalPips,
//         asset: asset,
//       );

//       _targetProfitCash = TradingFormulas.calculateCashAmount(
//         lotSize: _calculatedLot,
//         pips: _finalPips * (rrRatio > 0 ? rrRatio : 1.0),
//         asset: asset,
//       );
//     });
//   }

//   @override
//   void dispose() {
//     for (final c in _riskControllers.values) c.dispose();
//     for (final c in _pipControllers.values) c.dispose();
//     for (final c in _rrControllers.values) c.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final asset = widget.selectedAsset;
//     final unitLabel = getUnitLabel(asset);

//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // ── Input Card ──────────────────────────────────────
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF111827),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   children: [
//                     CustomInputField(
//                       label: 'Risk in (\$)',
//                       controller: _riskControllers[asset]!,
//                       onChanged: _processCalculations,
//                     ),
//                     CustomInputField(
//                       label: 'Stop Loss ($unitLabel)',
//                       controller: _pipControllers[asset]!,
//                       onChanged: _processCalculations,
//                     ),
//                     CustomInputField(
//                       label: 'Take Profit (R:R Ratio)',
//                       controller: _rrControllers[asset]!,
//                       onChanged: _processCalculations,
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // ── Output Card ─────────────────────────────────────
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF111827),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: const Color(0xFF1F2937)),
//                 ),
//                 child: Column(
//                   children: [
//                     const Text(
//                       'Calculated LOT Size',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 11,
//                         letterSpacing: 1,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       _calculatedLot.toStringAsFixed(
//                         _calculatedLot % 0.01 == 0 ? 2 : 3,
//                       ),
//                       style: const TextStyle(
//                         color: Color(0xFF10B981),
//                         fontSize: 52,
//                         fontWeight: FontWeight.w800,
//                         fontFamily: 'monospace',
//                       ),
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 10),
//                       child: Divider(color: Color(0xFF1F2937)),
//                     ),

//                     OutputRow(
//                       label: 'SL in $unitLabel:',
//                       value: _finalPips.toStringAsFixed(2),
//                       valueColor: Colors.white,
//                     ),

//                     OutputRow(
//                       label: 'Expected Max Loss:',
//                       value: '\$${_dollarRisk.toStringAsFixed(2)}',
//                       valueColor: const Color(0xFFEF4444),
//                     ),
//                     OutputRow(
//                       label: 'Expected Target Profit:',
//                       value: '\$${_targetProfitCash.toStringAsFixed(2)}',
//                       valueColor: const Color(0xFF10B981),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ==========================================
// // SCREEN 2: BY ENTRY / EXIT PRICES (ISOLATED)
// // ==========================================
// class EntryExitPage extends StatefulWidget {
//   final AssetType selectedAsset;
//   const EntryExitPage({super.key, required this.selectedAsset});

//   @override
//   State<EntryExitPage> createState() => _EntryExitPageState();
// }

// class _EntryExitPageState extends State<EntryExitPage> {
//   final Map<AssetType, TextEditingController> _riskControllers = {
//     AssetType.xauusd: TextEditingController(),
//     AssetType.xagusd: TextEditingController(),
//     AssetType.eurusd: TextEditingController(),
//     AssetType.gbpusd: TextEditingController(),
//     AssetType.ndx100: TextEditingController(),
//     AssetType.spx500: TextEditingController(),
//   };

//   final Map<AssetType, TextEditingController> _entryControllers = {
//     AssetType.xauusd: TextEditingController(),
//     AssetType.xagusd: TextEditingController(),
//     AssetType.eurusd: TextEditingController(),
//     AssetType.gbpusd: TextEditingController(),
//     AssetType.ndx100: TextEditingController(),
//     AssetType.spx500: TextEditingController(),
//   };

//   final Map<AssetType, TextEditingController> _slControllers = {
//     AssetType.xauusd: TextEditingController(),
//     AssetType.xagusd: TextEditingController(),
//     AssetType.eurusd: TextEditingController(),
//     AssetType.gbpusd: TextEditingController(),
//     AssetType.ndx100: TextEditingController(),
//     AssetType.spx500: TextEditingController(),
//   };

//   final Map<AssetType, TextEditingController> _tpControllers = {
//     AssetType.xauusd: TextEditingController(),
//     AssetType.xagusd: TextEditingController(),
//     AssetType.eurusd: TextEditingController(),
//     AssetType.gbpusd: TextEditingController(),
//     AssetType.ndx100: TextEditingController(),
//     AssetType.spx500: TextEditingController(),
//   };

//   // Ask (red) controller — used for spread, XAGUSD + XAUUSD
//   final Map<AssetType, TextEditingController> _askControllers = {
//     AssetType.xauusd: TextEditingController(),
//     AssetType.xagusd: TextEditingController(),
//     AssetType.eurusd: TextEditingController(),
//     AssetType.gbpusd: TextEditingController(),
//     AssetType.ndx100: TextEditingController(),
//     AssetType.spx500: TextEditingController(),
//   };

//   // Bid (green) controller — used for spread, XAGUSD + XAUUSD
//   final Map<AssetType, TextEditingController> _bidControllers = {
//     AssetType.xauusd: TextEditingController(),
//     AssetType.xagusd: TextEditingController(),
//     AssetType.eurusd: TextEditingController(),
//     AssetType.gbpusd: TextEditingController(),
//     AssetType.ndx100: TextEditingController(),
//     AssetType.spx500: TextEditingController(),
//   };

//   // Buy/Sell toggle — XAGUSD + XAUUSD only (others unaffected)
//   final Map<AssetType, bool> _isBuy = {
//     AssetType.xauusd: true,
//     AssetType.xagusd: true,
//     AssetType.eurusd: true,
//     AssetType.gbpusd: true,
//     AssetType.ndx100: true,
//     AssetType.spx500: true,
//   };

//   double _calculatedLot = 0.00;
//   double _slPips = 0.0;
//   double _tpPips = 0.0;
//   double _actualLossCash = 0.0;
//   double _actualProfitCash = 0.0;
//   double _spreadPips = 0.0; // XAGUSD/XAUUSD only
//   double _effectiveSlPips = 0.0; // XAGUSD/XAUUSD only (SL pips +/- spread)

//   @override
//   void didUpdateWidget(covariant EntryExitPage oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     _processCalculations();
//   }

//   void _processCalculations() {
//     final asset = widget.selectedAsset;
//     double dollarRiskInput =
//         double.tryParse(_riskControllers[asset]!.text) ?? 0.0;
//     double entry = double.tryParse(_entryControllers[asset]!.text) ?? 0.0;

//     double slPrice = double.tryParse(_slControllers[asset]!.text) ?? 0.0;
//     double tpPrice = double.tryParse(_tpControllers[asset]!.text) ?? 0.0;

//     // Spread inputs — meaningful for XAGUSD and XAUUSD, kept isolated per-asset
//     double ask = double.tryParse(_askControllers[asset]!.text) ?? 0.0;
//     double bid = double.tryParse(_bidControllers[asset]!.text) ?? 0.0;
//     bool isBuyTrade = _isBuy[asset] ?? true;

//     setState(() {
//       if (entry > 0 && slPrice > 0) {
//         double rawSlValue = TradingFormulas.calculateValue(entry, slPrice);
//         _slPips = TradingFormulas.valueToPips(rawSlValue, asset);
//       } else {
//         _slPips = 0.0;
//       }

//       if (entry > 0 && tpPrice > 0) {
//         double rawTpValue = TradingFormulas.calculateValue(entry, tpPrice);
//         _tpPips = TradingFormulas.valueToPips(rawTpValue, asset);
//       } else {
//         _tpPips = 0.0;
//       }

//       // ── XAGUSD, XAUUSD, EURUSD, GBPUSD spread logic (each asset uses its OWN pip size) ──
//       double effectiveSlForLot = _slPips;
//       if (asset == AssetType.xagusd ||
//           asset == AssetType.xauusd ||
//           asset == AssetType.eurusd ||
//           asset == AssetType.gbpusd) {
//         // valueToPipsForSpread internally switches on `asset`, so XAUUSD
//         // automatically uses its own pip size (0.01) and XAGUSD uses its
//         // own (0.001) — no cross-mixing of values between the two.
//         _spreadPips = (ask > 0 && bid > 0 && ask > bid)
//             ? TradingFormulas.valueToPipsForSpread(ask - bid, asset)
//             : 0.0;

//         // Buy: SL pips + spread (entry executes at Ask, spread works against)
//         // Sell: SL pips - spread (entry executes at Bid, spread reduces distance)
//         double effSL = isBuyTrade
//             ? _slPips + _spreadPips
//             : (_slPips - _spreadPips).clamp(0.0, double.infinity);

//         _effectiveSlPips = effSL;
//         effectiveSlForLot = _spreadPips > 0 ? effSL : _slPips;
//       } else {
//         _spreadPips = 0.0;
//         _effectiveSlPips = 0.0;
//       }

//       // calculateLotSize / calculateCashAmount also switch on `asset`,
//       // so XAUUSD always uses its own multiplier (*10) and XAGUSD its
//       // own (*50) — formulas are never shared between assets.
//       _calculatedLot = TradingFormulas.calculateLotSize(
//         dollarRisk: dollarRiskInput,
//         slPips: effectiveSlForLot,
//         asset: asset,
//       );

//       _actualLossCash = TradingFormulas.calculateCashAmount(
//         lotSize: _calculatedLot,
//         pips: effectiveSlForLot,
//         asset: asset,
//       );
//       _actualProfitCash = TradingFormulas.calculateCashAmount(
//         lotSize: _calculatedLot,
//         pips: _tpPips,
//         asset: asset,
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final asset = widget.selectedAsset;
//     final unitLabel = getUnitLabel(asset);
//     final bool showSpreadUI =
//         asset == AssetType.xagusd ||
//         asset == AssetType.xauusd ||
//         asset == AssetType.eurusd ||
//         asset == AssetType.gbpusd;
//     final String spreadAssetLabel = asset == AssetType.xagusd
//         ? 'XAGUSD'
//         : asset == AssetType.xauusd
//         ? 'XAUUSD'
//         : asset == AssetType.eurusd
//         ? 'EURUSD'
//         : 'GBPUSD';
//     final bool isBuyTrade = _isBuy[asset] ?? true;
//     final bool hasSpread = _spreadPips > 0;

//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF111827),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   children: [
//                     CustomInputField(
//                       label: 'Risk in (\$)',
//                       controller: _riskControllers[asset]!,
//                       onChanged: _processCalculations,
//                     ),
//                     CustomInputField(
//                       label: 'Broker Entry Price',
//                       controller: _entryControllers[asset]!,
//                       onChanged: _processCalculations,
//                     ),
//                     CustomInputField(
//                       label: 'Broker Stop Loss Price',
//                       controller: _slControllers[asset]!,
//                       onChanged: _processCalculations,
//                     ),
//                     CustomInputField(
//                       label: 'Take Profit Price',
//                       controller: _tpControllers[asset]!,
//                       onChanged: _processCalculations,
//                     ),

//                     // ── XAGUSD / XAUUSD: Spread Section ──────────
//                     if (showSpreadUI) ...[
//                       const SizedBox(height: 12),
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF0B0F19),
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: const Color(0xFF1F2937)),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'SPREAD — OPTIONAL ($spreadAssetLabel)',
//                               style: const TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 10,
//                                 letterSpacing: 1.2,
//                               ),
//                             ),
//                             const SizedBox(height: 10),

//                             // Buy / Sell Toggle
//                             Row(
//                               children: [
//                                 const Text(
//                                   'Trade Type:',
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       _isBuy[asset] = true;
//                                       _processCalculations();
//                                     });
//                                   },
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 16,
//                                       vertical: 6,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: isBuyTrade
//                                           ? const Color(0xFF10B981)
//                                           : const Color(0xFF1F2937),
//                                       borderRadius: const BorderRadius.only(
//                                         topLeft: Radius.circular(6),
//                                         bottomLeft: Radius.circular(6),
//                                       ),
//                                     ),
//                                     child: Text(
//                                       'BUY',
//                                       style: TextStyle(
//                                         color: isBuyTrade
//                                             ? Colors.black
//                                             : Colors.grey,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       _isBuy[asset] = false;
//                                       _processCalculations();
//                                     });
//                                   },
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 16,
//                                       vertical: 6,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: !isBuyTrade
//                                           ? const Color(0xFFEF4444)
//                                           : const Color(0xFF1F2937),
//                                       borderRadius: const BorderRadius.only(
//                                         topRight: Radius.circular(6),
//                                         bottomRight: Radius.circular(6),
//                                       ),
//                                     ),
//                                     child: Text(
//                                       'SELL',
//                                       style: TextStyle(
//                                         color: !isBuyTrade
//                                             ? Colors.white
//                                             : Colors.grey,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             const SizedBox(height: 10),

//                             // Ask + Bid fields side by side
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: CustomInputField(
//                                     label: '🔴 Ask Price',
//                                     controller: _askControllers[asset]!,
//                                     onChanged: _processCalculations,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Expanded(
//                                   child: CustomInputField(
//                                     label: '🟢 Bid Price',
//                                     controller: _bidControllers[asset]!,
//                                     onChanged: _processCalculations,
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             const SizedBox(height: 8),
//                             Text(
//                               isBuyTrade
//                                   ? '📌 BUY: Entry = Ask (red). Spread ADDED to SL distance.'
//                                   : '📌 SELL: Entry = Bid (green). Spread SUBTRACTED from SL distance.',
//                               style: const TextStyle(
//                                 color: Color(0xFFF59E0B),
//                                 fontSize: 11,
//                               ),
//                             ),

//                             if (hasSpread) ...[
//                               const SizedBox(height: 10),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                   vertical: 8,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFF1F2937),
//                                   borderRadius: BorderRadius.circular(6),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       'Spread:',
//                                       style: TextStyle(
//                                         color: Colors.grey[400],
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                     Text(
//                                       '${_spreadPips.toStringAsFixed(2)} $unitLabel',
//                                       style: const TextStyle(
//                                         color: Color(0xFFF59E0B),
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 13,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF111827),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: const Color(0xFF1F2937)),
//                 ),
//                 child: Column(
//                   children: [
//                     const Text(
//                       'Calculated LOT Size',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 11,
//                         letterSpacing: 1,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       _calculatedLot.toStringAsFixed(
//                         _calculatedLot % 0.01 == 0 ? 2 : 3,
//                       ),
//                       style: const TextStyle(
//                         color: Color(0xFF10B981),
//                         fontSize: 52,
//                         fontWeight: FontWeight.w800,
//                         fontFamily: 'monospace',
//                       ),
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 10),
//                       child: Divider(color: Color(0xFF1F2937)),
//                     ),
//                     OutputRow(
//                       label: 'Stop Loss in $unitLabel:',
//                       value: _slPips.toStringAsFixed(2),
//                       valueColor: Colors.white,
//                     ),

//                     // XAGUSD/XAUUSD-only spread + effective SL output
//                     if (showSpreadUI && hasSpread) ...[
//                       OutputRow(
//                         label: 'Spread in $unitLabel:',
//                         value: _spreadPips.toStringAsFixed(2),
//                         valueColor: const Color(0xFFF59E0B),
//                       ),
//                       OutputRow(
//                         label: 'Effective SL (incl. Spread):',
//                         value: _effectiveSlPips.toStringAsFixed(2),
//                         valueColor: const Color(0xFF60A5FA),
//                       ),
//                     ],

//                     OutputRow(
//                       label: 'Take Profit in $unitLabel:',
//                       value: _tpPips.toStringAsFixed(2),
//                       valueColor: Colors.white,
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 6),
//                       child: Divider(color: Color(0xFF1F2937), thickness: 0.5),
//                     ),
//                     OutputRow(
//                       label: 'Calculated Loss Amount:',
//                       value: '-\$${_actualLossCash.toStringAsFixed(2)}',
//                       valueColor: const Color(0xFFEF4444),
//                     ),
//                     OutputRow(
//                       label: 'Calculated Profit Amount:',
//                       value: '+\$${_actualProfitCash.toStringAsFixed(2)}',
//                       valueColor: const Color(0xFF10B981),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ==========================================
// // SCREEN 3: EXPECTED RISK (ISOLATED MAPS)
// // ==========================================
// class ExpectedLossPage extends StatefulWidget {
//   final AssetType selectedAsset;
//   const ExpectedLossPage({super.key, required this.selectedAsset});

//   @override
//   State<ExpectedLossPage> createState() => _ExpectedLossPageState();
// }

// class _ExpectedLossPageState extends State<ExpectedLossPage> {
//   final Map<AssetType, TextEditingController> _lotControllers = {
//     AssetType.xauusd: TextEditingController(),
//     AssetType.xagusd: TextEditingController(),
//     AssetType.eurusd: TextEditingController(),
//     AssetType.gbpusd: TextEditingController(),
//     AssetType.ndx100: TextEditingController(),
//     AssetType.spx500: TextEditingController(),
//   };

//   final Map<AssetType, TextEditingController> _slPipsControllers = {
//     AssetType.xauusd: TextEditingController(),
//     AssetType.xagusd: TextEditingController(),
//     AssetType.eurusd: TextEditingController(),
//     AssetType.gbpusd: TextEditingController(),
//     AssetType.ndx100: TextEditingController(),
//     AssetType.spx500: TextEditingController(),
//   };

//   double _expectedLossOutput = 0.00;

//   @override
//   void didUpdateWidget(covariant ExpectedLossPage oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     _processCalculations();
//   }

//   void _processCalculations() {
//     final asset = widget.selectedAsset;
//     double rawLot = double.tryParse(_lotControllers[asset]!.text) ?? 0.0;
//     double rawPips = double.tryParse(_slPipsControllers[asset]!.text) ?? 0.0;

//     setState(() {
//       _expectedLossOutput = TradingFormulas.calculateExpectedLoss(
//         lotSize: rawLot,
//         slPips: rawPips,
//         asset: asset,
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final asset = widget.selectedAsset;
//     final unitLabel = getUnitLabel(asset);

//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF111827),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   children: [
//                     CustomInputField(
//                       label: 'Lot Size',
//                       controller: _lotControllers[asset]!,
//                       onChanged: _processCalculations,
//                     ),
//                     CustomInputField(
//                       label: 'Stop Loss ($unitLabel)',
//                       controller: _slPipsControllers[asset]!,
//                       onChanged: _processCalculations,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF111827),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: const Color(0xFF1F2937)),
//                 ),
//                 child: Column(
//                   children: [
//                     const Text(
//                       'TOTAL EXPECTED LOSS',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 11,
//                         letterSpacing: 1,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '\$${_expectedLossOutput.toStringAsFixed(2)}',
//                       style: const TextStyle(
//                         color: Color(0xFFEF4444),
//                         fontSize: 52,
//                         fontWeight: FontWeight.w800,
//                         fontFamily: 'monospace',
//                       ),
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 10),
//                       child: Divider(color: Color(0xFF1F2937)),
//                     ),
//                     OutputRow(
//                       label: 'Active Lot Allocation:',
//                       value: rawLotDisplay(asset),
//                       valueColor: Colors.white,
//                     ),
//                     OutputRow(
//                       label: 'SL $unitLabel Distance:',
//                       value: rawPipsDisplay(asset),
//                       valueColor: Colors.white,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String rawLotDisplay(AssetType asset) {
//     double val = double.tryParse(_lotControllers[asset]!.text) ?? 0.0;
//     return val.toStringAsFixed(2);
//   }

//   String rawPipsDisplay(AssetType asset) {
//     double val = double.tryParse(_slPipsControllers[asset]!.text) ?? 0.0;
//     return val.toStringAsFixed(1);
//   }
// }

// lib/main.dart
import 'package:flutter/material.dart';
import 'formulas.dart';
import 'ui_components.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pip Calculator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
      ),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;
  AssetType _selectedAsset = AssetType.xauusd;

  @override
  Widget build(BuildContext context) {
    final dropdownSelector = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AssetType>(
          value: _selectedAsset,
          dropdownColor: const Color(0xFF111827),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF10B981)),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 14,
          ),
          onChanged: (AssetType? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedAsset = newValue;
              });
            }
          },
          items: const [
            DropdownMenuItem(value: AssetType.xauusd, child: Text("XAUUSD")),
            DropdownMenuItem(value: AssetType.xagusd, child: Text("XAGUSD")),
            DropdownMenuItem(value: AssetType.eurusd, child: Text("EURUSD")),
            DropdownMenuItem(value: AssetType.gbpusd, child: Text("GBPUSD")),
            DropdownMenuItem(value: AssetType.ndx100, child: Text("NDX100")),
            DropdownMenuItem(value: AssetType.spx500, child: Text("SPX500")),
          ],
        ),
      ),
    );

    final List<Widget> pages = [
      ManualPipsPage(selectedAsset: _selectedAsset),
      EntryExitPage(selectedAsset: _selectedAsset),
      ExpectedLossPage(selectedAsset: _selectedAsset),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ahad's FxCalculator",
          style: TextStyle(
            color: Colors.yellow,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: const Color(0xFF111827),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Center(child: dropdownSelector),
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: const Color(0xFF111827),
        selectedItemColor: const Color(0xFF10B981),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.tune_rounded),
            label: 'By Manual Pips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_rounded),
            label: 'By Entry/Exit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gavel_rounded),
            label: 'Expected Risk',
          ),
        ],
      ),
    );
  }
}

// Utility function to get the localized pip/point name based on selected Asset
String getUnitLabel(AssetType asset) {
  if (asset == AssetType.ndx100 || asset == AssetType.spx500) {
    return 'Points';
  }
  return 'Pips';
}

// ==========================================
// SCREEN 1: BY MANUAL PIPS (ISOLATED)
// ==========================================
class ManualPipsPage extends StatefulWidget {
  final AssetType selectedAsset;
  const ManualPipsPage({super.key, required this.selectedAsset});

  @override
  State<ManualPipsPage> createState() => _ManualPipsPageState();
}

class _ManualPipsPageState extends State<ManualPipsPage> {
  final Map<AssetType, TextEditingController> _riskControllers = {
    AssetType.xauusd: TextEditingController(),
    AssetType.xagusd: TextEditingController(),
    AssetType.eurusd: TextEditingController(),
    AssetType.gbpusd: TextEditingController(),
    AssetType.ndx100: TextEditingController(),
    AssetType.spx500: TextEditingController(),
  };

  final Map<AssetType, TextEditingController> _pipControllers = {
    AssetType.xauusd: TextEditingController(),
    AssetType.xagusd: TextEditingController(),
    AssetType.eurusd: TextEditingController(),
    AssetType.gbpusd: TextEditingController(),
    AssetType.ndx100: TextEditingController(),
    AssetType.spx500: TextEditingController(),
  };

  final Map<AssetType, TextEditingController> _rrControllers = {
    AssetType.xauusd: TextEditingController(),
    AssetType.xagusd: TextEditingController(),
    AssetType.eurusd: TextEditingController(),
    AssetType.gbpusd: TextEditingController(),
    AssetType.ndx100: TextEditingController(),
    AssetType.spx500: TextEditingController(),
  };

  double _calculatedLot = 0.00;
  double _finalPips = 0.0;
  double _dollarRisk = 0.0;
  double _targetProfitCash = 0.0;

  @override
  void didUpdateWidget(covariant ManualPipsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _processCalculations();
  }

  void _processCalculations() {
    final asset = widget.selectedAsset;
    double dollarRiskInput =
        double.tryParse(_riskControllers[asset]!.text) ?? 0.0;
    double manualPips = double.tryParse(_pipControllers[asset]!.text) ?? 0.0;
    double rrRatio = double.tryParse(_rrControllers[asset]!.text) ?? 0.0;

    setState(() {
      _dollarRisk = dollarRiskInput;
      _finalPips = manualPips;

      _calculatedLot = TradingFormulas.calculateLotSize(
        dollarRisk: _dollarRisk,
        slPips: _finalPips,
        asset: asset,
      );

      _targetProfitCash = TradingFormulas.calculateCashAmount(
        lotSize: _calculatedLot,
        pips: _finalPips * (rrRatio > 0 ? rrRatio : 1.0),
        asset: asset,
      );
    });
  }

  @override
  void dispose() {
    for (final c in _riskControllers.values) c.dispose();
    for (final c in _pipControllers.values) c.dispose();
    for (final c in _rrControllers.values) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asset = widget.selectedAsset;
    final unitLabel = getUnitLabel(asset);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Input Card ──────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    CustomInputField(
                      label: 'Risk in (\$)',
                      controller: _riskControllers[asset]!,
                      onChanged: _processCalculations,
                    ),
                    CustomInputField(
                      label: 'Stop Loss ($unitLabel)',
                      controller: _pipControllers[asset]!,
                      onChanged: _processCalculations,
                    ),
                    CustomInputField(
                      label: 'Take Profit (R:R Ratio)',
                      controller: _rrControllers[asset]!,
                      onChanged: _processCalculations,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Output Card ─────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1F2937)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Calculated LOT Size',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _calculatedLot.toStringAsFixed(
                        _calculatedLot % 0.01 == 0 ? 2 : 3,
                      ),
                      style: const TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 52,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: Color(0xFF1F2937)),
                    ),

                    OutputRow(
                      label: 'SL in $unitLabel:',
                      value: _finalPips.toStringAsFixed(2),
                      valueColor: Colors.white,
                    ),

                    OutputRow(
                      label: 'Expected Max Loss:',
                      value: '\$${_dollarRisk.toStringAsFixed(2)}',
                      valueColor: const Color(0xFFEF4444),
                    ),
                    OutputRow(
                      label: 'Expected Target Profit:',
                      value: '\$${_targetProfitCash.toStringAsFixed(2)}',
                      valueColor: const Color(0xFF10B981),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 2: BY ENTRY / EXIT PRICES (ISOLATED)
// ==========================================
class EntryExitPage extends StatefulWidget {
  final AssetType selectedAsset;
  const EntryExitPage({super.key, required this.selectedAsset});

  @override
  State<EntryExitPage> createState() => _EntryExitPageState();
}

class _EntryExitPageState extends State<EntryExitPage> {
  final Map<AssetType, TextEditingController> _riskControllers = {
    AssetType.xauusd: TextEditingController(),
    AssetType.xagusd: TextEditingController(),
    AssetType.eurusd: TextEditingController(),
    AssetType.gbpusd: TextEditingController(),
    AssetType.ndx100: TextEditingController(),
    AssetType.spx500: TextEditingController(),
  };

  final Map<AssetType, TextEditingController> _entryControllers = {
    AssetType.xauusd: TextEditingController(),
    AssetType.xagusd: TextEditingController(),
    AssetType.eurusd: TextEditingController(),
    AssetType.gbpusd: TextEditingController(),
    AssetType.ndx100: TextEditingController(),
    AssetType.spx500: TextEditingController(),
  };

  final Map<AssetType, TextEditingController> _slControllers = {
    AssetType.xauusd: TextEditingController(),
    AssetType.xagusd: TextEditingController(),
    AssetType.eurusd: TextEditingController(),
    AssetType.gbpusd: TextEditingController(),
    AssetType.ndx100: TextEditingController(),
    AssetType.spx500: TextEditingController(),
  };

  final Map<AssetType, TextEditingController> _tpControllers = {
    AssetType.xauusd: TextEditingController(),
    AssetType.xagusd: TextEditingController(),
    AssetType.eurusd: TextEditingController(),
    AssetType.gbpusd: TextEditingController(),
    AssetType.ndx100: TextEditingController(),
    AssetType.spx500: TextEditingController(),
  };

  // Ask (red) controller — used for spread, XAGUSD + XAUUSD
  final Map<AssetType, TextEditingController> _askControllers = {
    AssetType.xauusd: TextEditingController(),
    AssetType.xagusd: TextEditingController(),
    AssetType.eurusd: TextEditingController(),
    AssetType.gbpusd: TextEditingController(),
    AssetType.ndx100: TextEditingController(),
    AssetType.spx500: TextEditingController(),
  };

  // Bid (green) controller — used for spread, XAGUSD + XAUUSD
  final Map<AssetType, TextEditingController> _bidControllers = {
    AssetType.xauusd: TextEditingController(),
    AssetType.xagusd: TextEditingController(),
    AssetType.eurusd: TextEditingController(),
    AssetType.gbpusd: TextEditingController(),
    AssetType.ndx100: TextEditingController(),
    AssetType.spx500: TextEditingController(),
  };

  // Buy/Sell toggle — XAGUSD + XAUUSD only (others unaffected)
  final Map<AssetType, bool> _isBuy = {
    AssetType.xauusd: true,
    AssetType.xagusd: true,
    AssetType.eurusd: true,
    AssetType.gbpusd: true,
    AssetType.ndx100: true,
    AssetType.spx500: true,
  };

  double _calculatedLot = 0.00;
  double _slPips = 0.0;
  double _tpPips = 0.0;
  double _actualLossCash = 0.0;
  double _actualProfitCash = 0.0;
  double _spreadPips = 0.0; // XAGUSD/XAUUSD only
  double _effectiveSlPips = 0.0; // XAGUSD/XAUUSD only (SL pips +/- spread)

  @override
  void didUpdateWidget(covariant EntryExitPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _processCalculations();
  }

  void _processCalculations() {
    final asset = widget.selectedAsset;
    double dollarRiskInput =
        double.tryParse(_riskControllers[asset]!.text) ?? 0.0;
    double entry = double.tryParse(_entryControllers[asset]!.text) ?? 0.0;

    double slPrice = double.tryParse(_slControllers[asset]!.text) ?? 0.0;
    double tpPrice = double.tryParse(_tpControllers[asset]!.text) ?? 0.0;

    // Spread inputs — meaningful for XAGUSD and XAUUSD, kept isolated per-asset
    double ask = double.tryParse(_askControllers[asset]!.text) ?? 0.0;
    double bid = double.tryParse(_bidControllers[asset]!.text) ?? 0.0;
    bool isBuyTrade = _isBuy[asset] ?? true;

    setState(() {
      if (entry > 0 && slPrice > 0) {
        double rawSlValue = TradingFormulas.calculateValue(entry, slPrice);
        _slPips = TradingFormulas.valueToPips(rawSlValue, asset);
      } else {
        _slPips = 0.0;
      }

      if (entry > 0 && tpPrice > 0) {
        double rawTpValue = TradingFormulas.calculateValue(entry, tpPrice);
        _tpPips = TradingFormulas.valueToPips(rawTpValue, asset);
      } else {
        _tpPips = 0.0;
      }

      // ── XAGUSD, XAUUSD, EURUSD, GBPUSD spread logic (each asset uses its OWN pip size) ──
      double effectiveSlForLot = _slPips;
      if (asset == AssetType.xagusd ||
          asset == AssetType.xauusd ||
          asset == AssetType.eurusd ||
          asset == AssetType.gbpusd) {
        // valueToPipsForSpread internally switches on `asset`, so XAUUSD
        // automatically uses its own pip size (0.01) and XAGUSD uses its
        // own (0.001) — no cross-mixing of values between the two.
        _spreadPips = (ask > 0 && bid > 0 && ask > bid)
            ? TradingFormulas.valueToPipsForSpread(ask - bid, asset)
            : 0.0;

        // Buy: SL pips + spread (entry executes at Ask, spread works against)
        // Sell: SL pips - spread (entry executes at Bid, spread reduces distance)
        double effSL = isBuyTrade
            ? _slPips + _spreadPips
            : (_slPips - _spreadPips).clamp(0.0, double.infinity);

        _effectiveSlPips = effSL;
        effectiveSlForLot = _spreadPips > 0 ? effSL : _slPips;
      } else {
        _spreadPips = 0.0;
        _effectiveSlPips = 0.0;
      }

      // calculateLotSize / calculateCashAmount also switch on `asset`,
      // so XAUUSD always uses its own multiplier (*10) and XAGUSD its
      // own (*50) — formulas are never shared between assets.
      _calculatedLot = TradingFormulas.calculateLotSize(
        dollarRisk: dollarRiskInput,
        slPips: effectiveSlForLot,
        asset: asset,
      );

      _actualLossCash = TradingFormulas.calculateCashAmount(
        lotSize: _calculatedLot,
        pips: effectiveSlForLot,
        asset: asset,
      );
      _actualProfitCash = TradingFormulas.calculateCashAmount(
        lotSize: _calculatedLot,
        pips: _tpPips,
        asset: asset,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final asset = widget.selectedAsset;
    final unitLabel = getUnitLabel(asset);
    final bool showSpreadUI =
        asset == AssetType.xagusd ||
        asset == AssetType.xauusd ||
        asset == AssetType.eurusd ||
        asset == AssetType.gbpusd;
    final String spreadAssetLabel = asset == AssetType.xagusd
        ? 'XAGUSD'
        : asset == AssetType.xauusd
        ? 'XAUUSD'
        : asset == AssetType.eurusd
        ? 'EURUSD'
        : 'GBPUSD';
    final bool isBuyTrade = _isBuy[asset] ?? true;
    final bool hasSpread = _spreadPips > 0;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // ── Buy/Sell Toggle (Top - All Pairs) ──────────────
                    Row(
                      children: [
                        const Text(
                          'Trade Type:',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isBuy[asset] = true;
                              _processCalculations();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isBuyTrade
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF1F2937),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                bottomLeft: Radius.circular(6),
                              ),
                            ),
                            child: Text(
                              'BUY',
                              style: TextStyle(
                                color: isBuyTrade ? Colors.black : Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isBuy[asset] = false;
                              _processCalculations();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: !isBuyTrade
                                  ? const Color(0xFFEF4444)
                                  : const Color(0xFF1F2937),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(6),
                                bottomRight: Radius.circular(6),
                              ),
                            ),
                            child: Text(
                              'SELL',
                              style: TextStyle(
                                color: !isBuyTrade ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ── Input Fields ──────────────────────────────────
                    CustomInputField(
                      label: 'Risk in (\$)',
                      controller: _riskControllers[asset]!,
                      onChanged: _processCalculations,
                    ),
                    CustomInputField(
                      label: 'Broker Entry Price',
                      controller: _entryControllers[asset]!,
                      onChanged: _processCalculations,
                    ),
                    CustomInputField(
                      label: 'Broker Stop Loss Price',
                      controller: _slControllers[asset]!,
                      onChanged: _processCalculations,
                    ),
                    CustomInputField(
                      label: 'Take Profit Price',
                      controller: _tpControllers[asset]!,
                      onChanged: _processCalculations,
                    ),
                    if (showSpreadUI) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B0F19),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF1F2937)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SPREAD — OPTIONAL ($spreadAssetLabel)',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Ask + Bid fields side by side
                            Row(
                              children: [
                                Expanded(
                                  child: CustomInputField(
                                    label: '🔴 Ask Price',
                                    controller: _askControllers[asset]!,
                                    onChanged: _processCalculations,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: CustomInputField(
                                    label: '🟢 Bid Price',
                                    controller: _bidControllers[asset]!,
                                    onChanged: _processCalculations,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),
                            Text(
                              isBuyTrade
                                  ? '📌 BUY: Entry = Ask (red). Spread ADDED to SL distance.'
                                  : '📌 SELL: Entry = Bid (green). Spread SUBTRACTED from SL distance.',
                              style: const TextStyle(
                                color: Color(0xFFF59E0B),
                                fontSize: 11,
                              ),
                            ),

                            if (hasSpread) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1F2937),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Spread:',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '${_spreadPips.toStringAsFixed(2)} $unitLabel',
                                      style: const TextStyle(
                                        color: Color(0xFFF59E0B),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1F2937)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Calculated LOT Size',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _calculatedLot.toStringAsFixed(
                        _calculatedLot % 0.01 == 0 ? 2 : 3,
                      ),
                      style: const TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 52,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: Color(0xFF1F2937)),
                    ),
                    OutputRow(
                      label: 'Stop Loss in $unitLabel:',
                      value: _slPips.toStringAsFixed(2),
                      valueColor: Colors.white,
                    ),

                    // XAGUSD/XAUUSD-only spread + effective SL output
                    if (showSpreadUI && hasSpread) ...[
                      OutputRow(
                        label: 'Spread in $unitLabel:',
                        value: _spreadPips.toStringAsFixed(2),
                        valueColor: const Color(0xFFF59E0B),
                      ),
                      OutputRow(
                        label: 'Effective SL (incl. Spread):',
                        value: _effectiveSlPips.toStringAsFixed(2),
                        valueColor: const Color(0xFF60A5FA),
                      ),
                    ],

                    OutputRow(
                      label: 'Take Profit in $unitLabel:',
                      value: _tpPips.toStringAsFixed(2),
                      valueColor: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Divider(color: Color(0xFF1F2937), thickness: 0.5),
                    ),
                    OutputRow(
                      label: 'Calculated Loss Amount:',
                      value: '-\$${_actualLossCash.toStringAsFixed(2)}',
                      valueColor: const Color(0xFFEF4444),
                    ),
                    OutputRow(
                      label: 'Calculated Profit Amount:',
                      value: '+\$${_actualProfitCash.toStringAsFixed(2)}',
                      valueColor: const Color(0xFF10B981),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// SCREEN 3: EXPECTED RISK (ISOLATED MAPS)
// ==========================================
class ExpectedLossPage extends StatefulWidget {
  final AssetType selectedAsset;
  const ExpectedLossPage({super.key, required this.selectedAsset});

  @override
  State<ExpectedLossPage> createState() => _ExpectedLossPageState();
}

class _ExpectedLossPageState extends State<ExpectedLossPage> {
  final Map<AssetType, TextEditingController> _lotControllers = {
    AssetType.xauusd: TextEditingController(),
    AssetType.xagusd: TextEditingController(),
    AssetType.eurusd: TextEditingController(),
    AssetType.gbpusd: TextEditingController(),
    AssetType.ndx100: TextEditingController(),
    AssetType.spx500: TextEditingController(),
  };

  final Map<AssetType, TextEditingController> _slPipsControllers = {
    AssetType.xauusd: TextEditingController(),
    AssetType.xagusd: TextEditingController(),
    AssetType.eurusd: TextEditingController(),
    AssetType.gbpusd: TextEditingController(),
    AssetType.ndx100: TextEditingController(),
    AssetType.spx500: TextEditingController(),
  };

  double _expectedLossOutput = 0.00;

  @override
  void didUpdateWidget(covariant ExpectedLossPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _processCalculations();
  }

  void _processCalculations() {
    final asset = widget.selectedAsset;
    double rawLot = double.tryParse(_lotControllers[asset]!.text) ?? 0.0;
    double rawPips = double.tryParse(_slPipsControllers[asset]!.text) ?? 0.0;

    setState(() {
      _expectedLossOutput = TradingFormulas.calculateExpectedLoss(
        lotSize: rawLot,
        slPips: rawPips,
        asset: asset,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final asset = widget.selectedAsset;
    final unitLabel = getUnitLabel(asset);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    CustomInputField(
                      label: 'Lot Size',
                      controller: _lotControllers[asset]!,
                      onChanged: _processCalculations,
                    ),
                    CustomInputField(
                      label: 'Stop Loss ($unitLabel)',
                      controller: _slPipsControllers[asset]!,
                      onChanged: _processCalculations,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1F2937)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'TOTAL EXPECTED LOSS',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${_expectedLossOutput.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFFEF4444),
                        fontSize: 52,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: Color(0xFF1F2937)),
                    ),
                    OutputRow(
                      label: 'Active Lot Allocation:',
                      value: rawLotDisplay(asset),
                      valueColor: Colors.white,
                    ),
                    OutputRow(
                      label: 'SL $unitLabel Distance:',
                      value: rawPipsDisplay(asset),
                      valueColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String rawLotDisplay(AssetType asset) {
    double val = double.tryParse(_lotControllers[asset]!.text) ?? 0.0;
    return val.toStringAsFixed(2);
  }

  String rawPipsDisplay(AssetType asset) {
    double val = double.tryParse(_slPipsControllers[asset]!.text) ?? 0.0;
    return val.toStringAsFixed(1);
  }
}
