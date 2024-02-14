import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuelcost/pages/chart_screen.dart';

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
  double vehicleWastage = 0.0;
  double additionalExpenses = 0.0;

  TextEditingController fuelCostController = TextEditingController();
  TextEditingController totalCostController = TextEditingController();
  TextEditingController travelDaysController = TextEditingController();
  TextEditingController foodExpenseController = TextEditingController();
  TextEditingController accommodationExpenseController =
      TextEditingController();
  TextEditingController otherExpenseController = TextEditingController();
  TextEditingController tireCostController = TextEditingController();
  TextEditingController serviceCostController = TextEditingController();
  TextEditingController insuranceCostController = TextEditingController();

  void calculateExpenses() {
    double tireWastageTxt =
        (double.tryParse((tireCostController.text.toString())) ?? 0);
    double insuranceWastageTxt =
        (double.tryParse((insuranceCostController.text.toString())) ?? 0);
    double serviceWastageTxt =
        (double.tryParse((serviceCostController.text.toString())) ?? 0);

    double foodExpense =
        (double.tryParse((foodExpenseController.text.toString())) ?? 0);
    double accommodationExpense =
        (double.tryParse((accommodationExpenseController.text.toString())) ??
            0);
    double otherExpense =
        (double.tryParse((otherExpenseController.text.toString())) ?? 0);

    double tireWastage = (widget.distance / 40000) * tireWastageTxt;
    double serviceWastage = (widget.distance / 5000) * serviceWastageTxt;
    double insuranceWastage = (travelDays * insuranceWastageTxt);

    vehicleWastage = tireWastage + serviceWastage + insuranceWastage;
    additionalExpenses = foodExpense + accommodationExpense + otherExpense;

    setState(() {
      TotalCost = widget.totalCost + additionalExpenses + vehicleWastage;
    });
  }

  int selectedPageIndex = 0;

  @override
  void initState() {
    calculateExpenses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> options = [
      VehicleExpenses(
        tireCostController: tireCostController,
        serviceCostController: serviceCostController,
        insuranceCostController: insuranceCostController,
        vehicleWastage: vehicleWastage,
        onTireCostChanged: () {
          calculateExpenses();
        },
        onServiceCostChanged: () {
          setState(() {
            calculateExpenses();
          });
        },
        onInsuranceChanged: () {
          setState(() {
            calculateExpenses();
          });
        },
      ),
      AdditionalExpenses(
        accommodationExpenseController: accommodationExpenseController,
        otherExpenseController: otherExpenseController,
        foodExpenseController: foodExpenseController,
        additionalExpense: additionalExpenses,
        onFoodValueChanged: () {
          calculateExpenses();
        },
        onAccommodationValueChanged: () {
          calculateExpenses();
        },
        onOtherChanged: () {
          calculateExpenses();
        },
      )
    ];
    int index = 0;
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
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

            Expanded(
              child: Center(
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      selectedPageIndex = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    return options[selectedPageIndex];
                  },
                ),
              ),
            ),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  options.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: selectedPageIndex == index ? 25 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(1000)),
                    ),
                  ),
                ),
              ),
            ),
            // Text(
            //   'Total Additional Expenses : ${additionalExpenses.toStringAsFixed(2)} LKR',
            //   style: const TextStyle(
            //       fontFamily: 'DM Sans',
            //       fontSize: 14,
            //       fontWeight: FontWeight.bold),
            // ),
            const SizedBox(height: 20),

            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChartScreen(
                          totalFuelCost: widget.totalCost,
                          tireCost:
                              double.tryParse(tireCostController.text) ?? 0,
                          serviceCost:
                              double.tryParse(serviceCostController.text) ?? 0,
                          insCost:
                              double.tryParse(insuranceCostController.text) ??
                                  0,
                          foodCost:
                              double.tryParse(foodExpenseController.text) ?? 0,
                          roomCost: double.tryParse(
                                  accommodationExpenseController.text) ??
                              0,
                          otherCost:
                              double.tryParse(otherExpenseController.text) ?? 0,
                        ),
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green, // Background color
                    borderRadius: BorderRadius.circular(10), // Rounded corners
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
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
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

class AdditionalExpenses extends StatefulWidget {
  final double additionalExpense;
  final Function() onFoodValueChanged;
  final Function() onAccommodationValueChanged;
  final Function() onOtherChanged;

  final TextEditingController foodExpenseController;
  final TextEditingController accommodationExpenseController;
  final TextEditingController otherExpenseController;

  const AdditionalExpenses({
    Key? key,
    required this.additionalExpense,
    required this.onFoodValueChanged,
    required this.onAccommodationValueChanged,
    required this.onOtherChanged,
    required this.foodExpenseController,
    required this.accommodationExpenseController,
    required this.otherExpenseController,
  }) : super(key: key);

  @override
  State<AdditionalExpenses> createState() => _AdditionalExpensesState();
}

class _AdditionalExpensesState extends State<AdditionalExpenses> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Additional Expenses',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${widget.additionalExpense.toStringAsFixed(2)} LKR",
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 20,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Food:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              'Enter the total amount spent on meals and groceries for a specified period.',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: widget.foodExpenseController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                widget.onFoodValueChanged();
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Accommodation : ',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              'Input the total expenses related to lodging, such as rent or hotel charges.',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: widget.accommodationExpenseController,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8.0),
                labelText: 'Accommodation',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                widget.onAccommodationValueChanged();
                // setState(() {
                //   accommodationExpense = double.tryParse(value) ?? 0.0;
                //   calculateExpenses();
                // });
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Other',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              'Specify miscellaneous expenses not covered in specific categories.',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            TextField(
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 14,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8.0),
                labelText: 'Other',
              ),
              controller: widget.otherExpenseController,
              onChanged: (value) {
                widget.onOtherChanged();

                // setState(() {
                //   otherExpense = double.tryParse(value) ?? 0.0;
                //   calculateExpenses();
                // });
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class VehicleExpenses extends StatefulWidget {
  final double vehicleWastage;
  final Function() onTireCostChanged;
  final Function() onServiceCostChanged;
  final Function() onInsuranceChanged;

  final TextEditingController tireCostController;
  final TextEditingController serviceCostController;
  final TextEditingController insuranceCostController;

  const VehicleExpenses({
    Key? key,
    required this.vehicleWastage,
    required this.onTireCostChanged,
    required this.onServiceCostChanged,
    required this.onInsuranceChanged,
    required this.tireCostController,
    required this.serviceCostController,
    required this.insuranceCostController,
  }) : super(key: key);

  @override
  State<VehicleExpenses> createState() => _VehicleExpensesState();
}

class _VehicleExpensesState extends State<VehicleExpenses> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Vehicle Expenses',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${widget.vehicleWastage.toStringAsFixed(2)} LKR",
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 20,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tire Cost for all Tyres',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              'Enter the total cost of purchasing or replacing tires for your vehicle.',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            TextField(
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 14,
              ),
              controller: widget.tireCostController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8.0),
                labelText: 'Tire Cost for all Tyres',
              ),
              onChanged: (value) {
                widget.onTireCostChanged();
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Service Cost',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              'Input the overall cost of regular maintenance and servicing for your vehicle.Consider expenses for oil changes, inspections, and general upkeep.',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            TextField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 14,
              ),
              controller: widget.serviceCostController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8.0),
                labelText: 'Service Cost',
              ),
              onChanged: (value) {
                widget.onServiceCostChanged();

                // setState(() {
                //   serviceCost = double.tryParse(value) ?? 0.0;
                //   calculateExpenses();
                // });
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Insurance Cost',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              'Specify the total cost of insurance coverage for your vehicle.',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: widget.insuranceCostController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                widget.onInsuranceChanged();
                // setState(() {
                //   insuranceCost = double.tryParse(value) ?? 0.0;
                //   calculateExpenses();
                // });
              },
            ),
          ],
        ),
        // const SizedBox(height: 10),
        // Text(
        //   'Total Vehicle Wastage : ${widget.vehicleWastage.toStringAsFixed(2)} LKR',
        //   style: const TextStyle(
        //     fontFamily: 'DM Sans',
        //     fontSize: 14,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 10),
      ],
    );
  }
}
