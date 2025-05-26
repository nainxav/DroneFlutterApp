import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plisss/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic> responseData = {};
  int _selectedIndex = 0;
  // final ApiService apiService = ApiService();
  ApiService? apiService;
  final TextEditingController _baseUrlController = TextEditingController();
  String responseText = 'No data received yet';

  @override
  void initState() {
    super.initState();
    _promptForBaseUrl();
  }

  void _promptForBaseUrl() async {
    await Future.delayed(Duration.zero);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('Enter Base URL'),
        content: TextField(
          controller: _baseUrlController,
          decoration:
              InputDecoration(hintText: 'e.g. http://192.168.0.101:5000'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final inputUrl = _baseUrlController.text.trim();

              // Check if the input URL is empty or invalid
              if (inputUrl.isEmpty) {
                setState(() {
                  responseText = 'Base URL cannot be empty';
                });
                return;
              }

              setState(() {
                // Initialize the ApiService with the provided base URL
                apiService = ApiService(baseUrl: inputUrl);
                responseText = 'Base URL set successfully';
              });
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Fetch the data from API and update the response data
  void _getData() async {
    // final data = await apiService.getRequest();

    // setState(() {
    //   if (data.containsKey('error')) {
    //     responseText = data['error']; // Display error message if any
    //   } else {
    //     responseData =
    //         data['data'] ?? {}; // Access the data field and update responseData
    //     responseText = 'Data received successfully';
    //   }
    // });
    if (apiService == null) {
      setState(() => responseText = 'Base URL not set');
      return;
    }

    final result = await apiService!.getRequest();

    setState(() {
      if (result.containsKey('error')) {
        responseText = result['error'];
      } else {
        final data = result['data'];
        responseData = data['target'] ?? {};
        responseText = 'Data received successfully';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 30),
                        title: Text('Hello, user!',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: Colors.white)),
                        subtitle: Text('Good Afternoon',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white54)),
                        trailing: const CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              AssetImage('assets/images/download.png'),
                        ),
                      ),
                      const SizedBox(height: 30)
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  color: Theme.of(context).primaryColor,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(200))),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 40,
                      mainAxisSpacing: 40,
                      children: [
                        itemDashboard('Latitude', CupertinoIcons.location_solid,
                            const Color.fromARGB(255, 189, 0, 0),
                            value:
                                responseData['latitude']?.toStringAsFixed(5)),
                        itemDashboard(
                            'Longitude',
                            CupertinoIcons.location_solid,
                            const Color.fromARGB(255, 0, 37, 124),
                            value:
                                responseData['longitude']?.toStringAsFixed(5)),
                        itemDashboard('Altitude',
                            CupertinoIcons.graph_square_fill, Colors.black,
                            value: responseData['altitude']?.toString()),
                        itemDashboard(
                            'Sat Count', CupertinoIcons.globe, Colors.black,
                            value: responseData['satcount']?.toString()),
                        ElevatedButton(
                          onPressed: _getData,
                          child: Text('GET'),
                        ),
                        SizedBox(height: 60),
                        Text(
                          'Response: $responseText',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            )
          : (_selectedIndex == 1
              ? const SecondPage()
              : (_selectedIndex == 3
                  ? const ProfileScreen()
                  : Center(
                      child: Text(
                        "Selected Page: ${_navBarItems[_selectedIndex].label}",
                      ),
                    ))),
      bottomNavigationBar: NavigationBar(
        animationDuration: const Duration(seconds: 1),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _navBarItems,
      ),
    );
  }

  itemDashboard(String title, IconData iconData, Color background,
          {String? value}) =>
      Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 5),
                  color: Theme.of(context).primaryColor.withOpacity(.2),
                  spreadRadius: 2,
                  blurRadius: 5)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: Colors.white)),
            const SizedBox(height: 8),
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              value ?? 'Loading...',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      );
}

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  Future<void> postRequest() async {
    var baseUrl = 'http://192.168.1.222:5000';
    var response = await http.post(
      Uri.parse('$baseUrl/command'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'command': 'arm',
      }),
    );
    if (response.statusCode == 200) {
      print('Post request successful');
    } else {
      print('Failed to post request');
    }
  }

  Future<void> postRequest2() async {
    var baseUrl = 'http://192.168.1.222:5000';
    var response = await http.post(
      Uri.parse('$baseUrl/command'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'command': 'disarm',
      }),
    );
    if (response.statusCode == 200) {
      print('Post request successful');
    } else {
      print('Failed to post request');
    }
  }

  Future<void> postRequest3() async {
    var baseUrl = 'http://192.168.1.222:5000';
    var response = await http.post(
      Uri.parse('$baseUrl/command'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'command': 'testmotor,1,10',
      }),
    );
    if (response.statusCode == 200) {
      print('Post request successful');
    } else {
      print('Failed to post request');
    }
  }

  Future<void> postRequest4() async {
    var baseUrl = 'http://192.168.1.222:5000';
    var response = await http.post(
      Uri.parse('$baseUrl/command'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'command': 'testmotor,2,10',
      }),
    );
    if (response.statusCode == 200) {
      print('Post request successful');
    } else {
      print('Failed to post request');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control Page')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            ElevatedButton(
              onPressed: () => postRequest(),
              child: const Text('Arm'),
            ),
            ElevatedButton(
              onPressed: () => postRequest2(),
              child: const Text('Disarm'),
            ),
            ElevatedButton(
              onPressed: () => postRequest3(),
              child: const Text('Motor Test 1'),
            ),
            ElevatedButton(
              onPressed: () => postRequest4(),
              child: const Text('Motor Test 2'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Motor Test 3'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Motor Test 4'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "My Account",
              icon: "assets/icons/User Icon.svg",
              press: () => {},
            ),
            ProfileMenu(
              text: "Notifications",
              icon: "assets/icons/Bell.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Settings",
              icon: "assets/icons/Settings.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Help Center",
              icon: "assets/icons/Question mark.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(
            backgroundImage:
                NetworkImage("https://i.postimg.cc/0jqKB6mS/Profile-Image.png"),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: () {},
                child: SvgPicture.string(cameraIcon),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFFF7643),
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              colorFilter:
                  const ColorFilter.mode(Color(0xFFFF7643), BlendMode.srcIn),
              width: 22,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF757575),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF757575),
            ),
          ],
        ),
      ),
    );
  }
}

const cameraIcon =
    '''<svg width="20" height="16" viewBox="0 0 20 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M10 12.0152C8.49151 12.0152 7.26415 10.8137 7.26415 9.33902C7.26415 7.86342 8.49151 6.6619 10 6.6619C11.5085 6.6619 12.7358 7.86342 12.7358 9.33902C12.7358 10.8137 11.5085 12.0152 10 12.0152ZM10 5.55543C7.86698 5.55543 6.13208 7.25251 6.13208 9.33902C6.13208 11.4246 7.86698 13.1217 10 13.1217C12.133 13.1217 13.8679 11.4246 13.8679 9.33902C13.8679 7.25251 12.133 5.55543 10 5.55543ZM18.8679 13.3967C18.8679 14.2226 18.1811 14.8935 17.3368 14.8935H2.66321C1.81887 14.8935 1.13208 14.2226 1.13208 13.3967V5.42346C1.13208 4.59845 1.81887 3.92664 2.66321 3.92664H4.75C5.42453 3.92664 6.03396 3.50952 6.26604 2.88753L6.81321 1.41746C6.88113 1.23198 7.06415 1.10739 7.26604 1.10739H12.734C12.9358 1.10739 13.1189 1.23198 13.1877 1.41839L13.734 2.88845C13.966 3.50952 14.5755 3.92664 15.25 3.92664H17.3368C18.1811 3.92664 18.8679 4.59845 18.8679 5.42346V13.3967ZM17.3368 2.82016H15.25C15.0491 2.82016 14.867 2.69466 14.7972 2.50917L14.2519 1.04003C14.0217 0.418041 13.4113 0 12.734 0H7.26604C6.58868 0 5.9783 0.418041 5.74906 1.0391L5.20283 2.50825C5.13302 2.69466 4.95094 2.82016 4.75 2.82016H2.66321C1.19434 2.82016 0 3.98846 0 5.42346V13.3967C0 14.8326 1.19434 16 2.66321 16H17.3368C18.8057 16 20 14.8326 20 13.3967V5.42346C20 3.98846 18.8057 2.82016 17.3368 2.82016Z" fill="#757575"/>
</svg>
''';

const _navBarItems = [
  NavigationDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home_rounded),
    label: 'Home',
  ),
  NavigationDestination(
    icon: Icon(Icons.control_point_outlined),
    selectedIcon: Icon(Icons.control_point_rounded),
    label: 'Control',
  ),
  NavigationDestination(
    icon: Icon(Icons.collections_outlined),
    selectedIcon: Icon(Icons.collections_rounded),
    label: 'Map',
  ),
  NavigationDestination(
    icon: Icon(Icons.person_outline_rounded),
    selectedIcon: Icon(Icons.person_rounded),
    label: 'Profile',
  ),
];
