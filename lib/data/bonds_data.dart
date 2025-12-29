import '../models/bond_model.dart';

final List<BondModel> bondsList = [
  BondModel(
    name: "Government Bond",
    amount: 10000,
    interest: 7.2,
    tenure: 5,
    status: "Active",
    rating: "CRISIL AAA",
    issuer: "Government of India",
    ipoDate: "15 Jan 2025",
    pros: [
      "Extremely low credit risk as the bond is backed by the Government of India, ensuring high safety of principal.",
      "Predictable and stable interest income, making it suitable for conservative and long-term investors.",
      "High credit rating (CRISIL AAA) reflects strong repayment capacity and financial stability.",
      "Provides portfolio diversification and reduces overall investment risk.",
      "Ideal for retirement planning due to steady returns and low volatility.",
      "Highly trusted investment instrument with strong regulatory oversight.",
    ],
    cons: [
      "Lower interest returns compared to corporate or high-risk bonds.",
      "Longer lock-in period may reduce liquidity before maturity.",
      "Returns may not beat inflation in high inflationary periods.",
      "Limited opportunity for capital appreciation.",
      "Interest income is taxable as per applicable income tax slab.",
    ],
    about:
        "Government Bonds are issued by the Government of India and are considered "
        "one of the safest investment instruments. These bonds provide stable "
        "returns and are suitable for risk-averse investors seeking predictable "
        "income.\n\n"
        "Use of Proceeds:\n"
        "Funds raised are primarily used for government expenditure, infrastructure "
        "development, and fiscal management.",
  ),

  BondModel(
    name: "Corporate Bond",
    amount: 25000,
    interest: 9.5,
    tenure: 3,
    status: "Upcoming",
    rating: "CRISIL AA+",
    issuer: "ABC Finance Ltd",
    ipoDate: "02 Feb 2025",
    pros: [
      "Offers higher interest rates compared to government bonds, enhancing return potential.",
      "Shorter tenure allows quicker capital rotation and reinvestment opportunities.",
      "Strong credit rating (CRISIL AA+) indicates good financial health of the issuer.",
      "Suitable for investors seeking better returns with moderate risk exposure.",
      "Regular interest payouts provide steady income flow.",
      "Diversifies fixed-income investments beyond government securities.",
    ],
    cons: [
      "Higher credit risk compared to government-backed bonds.",
      "Issuer performance directly impacts repayment capability.",
      "Market value may fluctuate with interest rate changes.",
      "Early exit may result in lower liquidity or price discount.",
      "Interest income is subject to taxation.",
      "Economic downturns may affect corporate profitability and bond stability.",
    ],
    about:
        "ABC Finance Ltd is a non-banking financial company providing credit solutions "
        "to mid-sized businesses. The company focuses on structured lending and "
        "corporate debt instruments.\n\n"
        "Use of Proceeds:\n"
        "The proceeds from this bond issue will be used for onward lending, repayment "
        "of existing borrowings, and general corporate purposes.",
  ),
];
