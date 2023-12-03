import 'package:flutter/material.dart';
import 'package:fuelcost/pages/total_cost_page.dart';

class ResultPage extends StatelessWidget {
  final double distance;
  final double fuelCost;
  final double totalCost;

  const ResultPage({
    Key? key,
    required this.distance,
    required this.fuelCost,
    required this.totalCost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Cost Result'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () {
                // Navigate to profile page
                Navigator.pushNamed(context, '/profile');
              },
              icon: const Icon(Icons.person),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Row(
                // Wrap the child elements in a Column
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const BackButtonIcon(),
                      color: Colors.white),
                  const Text(
                    'Fuel Cost',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () {
                // Perform sign-out logic and navigate to sign-in page
                Navigator.pushReplacementNamed(context, '/signin');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/fuel.jpeg'), // Add your image here
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue, // Choose your desired color
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      'Distance:           $distance km',
                      style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Fuel Cost per 1L: $fuelCost LKR',
                      style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                        height: 3, color: Color.fromARGB(255, 255, 255, 255)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Total Fuel Cost: $totalCost LKR',
                      style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TotalCostPage(
                          distance: distance,
                          fuelCost: fuelCost,
                          totalCost: totalCost,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Additional Expenses',
                    style: TextStyle(fontFamily: 'DM Sans', fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
