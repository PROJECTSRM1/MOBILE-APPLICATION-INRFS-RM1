import '../models/investment.dart';
import '../models/bond_model.dart';

class InvestmentStore {
  static final List<Investment> investments = [];

  /// BONDS (Derived)
  static List<BondModel> get bonds {
    return investments.map((i) {
      return BondModel(
        bondId: i.investmentId,
        planName: i.planName,
        investedAmount: i.investedAmount,
        maturityValue: i.maturityValue,
        tenure: i.tenure,
        interest: i.interest,
        status: i.status,
        date: i.date.toIso8601String().split('T').first,
      );
    }).toList();
  }

  /// RECENT INVESTMENTS
  static List<Investment> get recent =>
      investments.take(5).toList();
}
