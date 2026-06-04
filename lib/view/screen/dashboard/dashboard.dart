import 'package:flutter/material.dart';
import 'package:pmjay/database/database_helper.dart';
import 'package:pmjay/models/masterModel/master.model.dart';
import 'package:pmjay/repository/masterRepo/master.repo.dart';
import 'package:pmjay/utils/secure.storage.dart';
import 'package:pmjay/view/screen/beneficiary/beneficiary.details.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Beneficiary> beneficiaries = [];

  bool isLoading = true;

  final TextEditingController searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMasterData();
  }

  Future<void> fetchMasterData() async {
    // API Call
      //simulating api delay
      String?  accessToken=await SecureStorage().getAccessToken();
      final response = await context.read<MasterProvider>().masterAPI(
        accessToken!,
        1,
        500,
      );

      await loadBeneficiaries();

  }


  Future<void> loadBeneficiaries() async {
    final data =
    await DatabaseHelper.instance.getBeneficiaries();

    setState(() {
      beneficiaries = data;
      isLoading = false;
    });
  }

  Future<void> searchBeneficiaries(String keyword) async {
    if (keyword.trim().isEmpty) {
      await loadBeneficiaries();
      return;
    }

    final data =
    await DatabaseHelper.instance.searchBeneficiaries(
      keyword,
    );

    setState(() {
      beneficiaries = data;
    });
    if(data.length==1){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              BeneficiaryDetailsScreen(
                aadhaarNo:
                searchController.text.trim(),
              ),
        ),
      );
    }else{

    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
/*
        child: GridView.builder(
          itemCount: dashboardItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final item = dashboardItems[index];

            return InkWell(
              onTap: () {
                print("${item['title']} clicked");
              },
              borderRadius: BorderRadius.circular(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item['icon'],
                      size: 50,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
*/
        child:  Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextFormField(
                      controller: searchController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter Aadhaar Number",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await searchBeneficiaries(searchController.text.trim());

                      },
                      icon: const Icon(Icons.search),
                      label: const Text("Search & Open form"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        side: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                    ),
                    ) ],
                ),
              ),

              Expanded(
                child: GridView.builder(
                  itemCount: beneficiaries.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, index) {
                    final beneficiary = beneficiaries[index];

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              beneficiary.applicantName,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              beneficiary.pmjayId,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              beneficiary.district,
                              style: const TextStyle(
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )
      ),
    );
  }
}