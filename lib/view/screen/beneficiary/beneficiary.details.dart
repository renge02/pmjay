import 'package:flutter/material.dart';
import 'package:pmjay/database/database_helper.dart';
import 'package:pmjay/models/masterModel/master.model.dart';

class BeneficiaryDetailsScreen extends StatefulWidget {
  final String aadhaarNo;

  const BeneficiaryDetailsScreen({super.key, required this.aadhaarNo});

  @override
  State<BeneficiaryDetailsScreen> createState() =>
      _BeneficiaryDetailsScreenState();
}

class _BeneficiaryDetailsScreenState extends State<BeneficiaryDetailsScreen> {
  Beneficiary? beneficiary;
  bool isLoading = true;
  Map<String, String> exclusionAnswers = {
    "Family Income > 8 lakh per year": "",
    "Any member paying Income Tax": "",
    "Pending under SIR Adjudication": "",
    "Pending CAA Application": "",
    "Found in ASDD List": "",
  };

  @override
  void initState() {
    super.initState();
    loadBeneficiary();
  }

  Future<void> loadBeneficiary() async {
    beneficiary = await DatabaseHelper.instance.getBeneficiary(
      widget.aadhaarNo,
    );

    setState(() {
      isLoading = false;
    });
  }

  Widget buildField(
    String label,
    String value, {
    double width = double.infinity,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          TextFormField(
            initialValue: value,
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget exclusionCard(String title) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Yes"),
                    value: "Yes",
                    groupValue: exclusionAnswers[title],
                    onChanged: (value) {
                      setState(() {
                        exclusionAnswers[title] = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: const Text("No"),
                    value: "No",
                    groupValue: exclusionAnswers[title],
                    onChanged: (value) {
                      setState(() {
                        exclusionAnswers[title] = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Beneficiary Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// BASIC DETAILS
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      color: Colors.green,
                      child: const Text(
                        "A. Basic Beneficiary Details",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: buildField(
                            "Aadhaar Number",
                            beneficiary!.aadhaarNo,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: buildField(
                            "Applicant Name",
                            beneficiary!.applicantName,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: buildField(
                            "Mobile Number",
                            beneficiary!.mobileNumber,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: buildField("Gender", beneficiary!.gender),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    buildField("Address", beneficiary!.address),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: buildField("District", beneficiary!.district),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: buildField("Block", beneficiary!.block),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: buildField(
                            "Gram Panchayat",
                            beneficiary!.gramPanchayat,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: buildField("Ward", beneficiary!.ward ?? ""),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: buildField(
                            "Family Head Name",
                            beneficiary!.familyHeadName,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: buildField(
                            "Family Members",
                            beneficiary!.familyMembersCount.toString(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// EXCLUSION CRITERIA
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      color: Colors.green,
                      child: const Text(
                        "B. Exclusive Criteria Check",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    exclusionCard("Family Income > 8 lakh per year"),

                    exclusionCard("Any member paying Income Tax"),

                    exclusionCard("Pending under SIR Adjudication"),

                    exclusionCard("Pending CAA Application"),

                    exclusionCard("Found in ASDD List"),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          print(exclusionAnswers);
                          await DatabaseHelper.instance.updateExclusionCriteria(
                            beneficiary!.aadhaarNo,
                            '1',
                            DateTime.now().toIso8601String(),
                            exclusionAnswers,
                          );
                        },
                        child: const Text("Submit"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
