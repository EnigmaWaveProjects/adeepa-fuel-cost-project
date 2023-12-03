import 'package:flutter/material.dart';

class TotalCostPage extends StatefulWidget {
  final double distance;
  final double fuelCost;
  final double totalCost;

  const TotalCostPage({
    Key? key,
    required this.distance,
    required this.fuelCost,
    required this.totalCost,
  }) : super(key: key);

  @override
  State<TotalCostPage> createState() => _TotalCostPageState();
}

class _TotalCostPageState extends State<TotalCostPage> {
  int _currentIndex = 0;
  double fuelCost = 0.0;
  double TotalCost = 0.0;
  int travelDays = 0;
  double foodExpense = 0.0;
  double accommodationExpense = 0.0;
  double otherExpense = 0.0;
  double tireCost = 0.0;
  double serviceCost = 0.0;
  double insuranceCost = 0.0;
  double vehicleWastage = 0.0;
  double additionalExpenses = 0.0;
  void calculateExpenses() {
    double tireWastage = (widget.distance / 40000) * tireCost;
    double serviceWastage = (widget.distance / 5000) * serviceCost;
    double insuranceWastage = (travelDays * (insuranceCost / 360));
    vehicleWastage = tireWastage + serviceWastage + insuranceWastage;
    additionalExpenses = foodExpense + accommodationExpense + otherExpense;

    TotalCost = widget.totalCost + additionalExpenses + vehicleWastage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Additional Expenses'),
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
                    color: Colors.white,
                  ),
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/fuel.jpg'),
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(
                  const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
                  BlendMode.srcATop,
                ),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Predicted Fuel Cost : ${widget.totalCost} LKR',
                      style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('No of days to Travel : '),
                        SizedBox(
                          width: 200,
                          child: SizedBox(
                            width: 100,
                            child: TextField(
                              style: const TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8.0),
                                labelText: 'No of days to Travel',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  travelDays = int.tryParse(value) ?? 0;
                                  calculateExpenses();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'Additional Expenses',
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Food:'),
                        SizedBox(
                          width: 200,
                          child: SizedBox(
                            width: 300,
                            child: TextField(
                              style: const TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8.0),
                                labelText: 'Food',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  foodExpense = double.tryParse(value) ?? 0.0;
                                  calculateExpenses();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Accommodation : '),
                        SizedBox(
                          width: 200,
                          child: SizedBox(
                            width: 300,
                            child: TextField(
                              style: const TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8.0),
                                labelText: 'Accommodation',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  accommodationExpense =
                                      double.tryParse(value) ?? 0.0;
                                  calculateExpenses();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Other'),
                        SizedBox(
                          width: 200,
                          child: SizedBox(
                            width: 300,
                            child: TextField(
                              style: const TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8.0),
                                labelText: 'Other',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  otherExpense = double.tryParse(value) ?? 0.0;
                                  calculateExpenses();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Total Additional Expenses : ${additionalExpenses.toStringAsFixed(2)} LKR',
                      style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        'Vehicle Expenses',
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tire Cost for all Tyres'),
                        SizedBox(
                          width: 200,
                          child: SizedBox(
                            width: 300,
                            child: TextField(
                              style: const TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8.0),
                                labelText: 'Tire Cost for all Tyres',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  tireCost = double.tryParse(value) ?? 0.0;
                                  calculateExpenses();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Service Cost'),
                        SizedBox(
                          width: 200,
                          child: SizedBox(
                            width: 300,
                            child: TextField(
                              style: const TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8.0),
                                labelText: 'Service Cost',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  serviceCost = double.tryParse(value) ?? 0.0;
                                  calculateExpenses();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Insurance Cost'),
                        SizedBox(
                          width: 200,
                          child: SizedBox(
                            width: 300,
                            child: TextField(
                              style: const TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: 14,
                              ),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8.0),
                                labelText: 'Insurance Cost',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  insuranceCost = double.tryParse(value) ?? 0.0;
                                  calculateExpenses();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Total Vehicle Wastage : ${vehicleWastage.toStringAsFixed(2)} LKR',
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green, // Background color
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                        ),
                        // Background color
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Total Cost : ${TotalCost.toStringAsFixed(2)} LKR',
                            style: const TextStyle(
                              fontFamily: 'DM Sans',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // Add this section
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (_currentIndex == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (_currentIndex == 1) {
            Navigator.pushNamed(context, '/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
