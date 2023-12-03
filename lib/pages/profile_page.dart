import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'User Profile ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/signin');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/profile.png', width: 100),
            const SizedBox(height: 20),
            if (user != null)
              Text(
                'Email: ${user.email ?? 'N/A'}',
                style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/signin');
              },
              child: const Text('Sign Out'),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        icon: const Column(
                          children: [
                            Icon(Icons.home),
                          ],
                        ),
                      ),
                      const Text(
                        'Home',
                        style: TextStyle(fontFamily: 'DM Sans'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/profile');
                        },
                        icon: const Column(
                          children: [
                            Icon(Icons.person),
                          ],
                        ),
                      ),
                      const Text(
                        'Profile',
                        style: TextStyle(fontFamily: 'DM Sans'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          const mobileNumber =
                              '123-456-7890'; // Replace with your actual mobile number
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Row(
                                children: [
                                  Icon(Icons.phone),
                                  SizedBox(width: 8),
                                  Text('Mobile Number: $mobileNumber'),
                                ],
                              ),
                              action: SnackBarAction(
                                label: 'Copy',
                                onPressed: () {
                                  // Logic to copy the mobile number
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                },
                              ),
                            ),
                          );
                        },
                        icon: const Column(
                          children: [
                            Icon(Icons.phone),
                          ],
                        ),
                      ),
                      const Text(
                        'Contact Us',
                        style: TextStyle(fontFamily: 'DM Sans'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: const Text('FAQ'),
                                content: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Q1: How do I do this?'),
                                    Text('A1: You can do it like this...'),
                                    Text('Q2: What about that?'),
                                    Text(
                                        'A2: Here\'s how you can handle that...'),
                                    // Add more questions and answers as needed
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Column(
                          children: [
                            Icon(Icons.help),
                          ],
                        ),
                      ),
                      const Text(
                        'FAQ',
                        style: TextStyle(fontFamily: 'DM Sans'),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (_currentIndex == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (_currentIndex == 1) {
            // Already on the ProfilePage
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
