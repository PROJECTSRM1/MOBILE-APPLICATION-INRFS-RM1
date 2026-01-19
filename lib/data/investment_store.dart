import '../models/investment.dart';
import '../models/bond.dart';

class InvestmentStore {
  /// All investments
  static List<Investment> investments = [];

  /// Generated bonds (PDF based)
  static List<Bond> bonds = [];
}
