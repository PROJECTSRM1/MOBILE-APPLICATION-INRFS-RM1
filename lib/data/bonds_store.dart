import '../models/bond_model.dart';

class BondsStore {
  static final List<BondModel> bonds = [];

  static void addBond(BondModel bond) {
    bonds.insert(0, bond);
  }

  static bool get isEmpty => bonds.isEmpty;
}
