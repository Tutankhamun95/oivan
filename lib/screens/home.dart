import 'dart:convert';
import 'package:oivan/model/bookmarks.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oivan/model/user.dart';
import 'package:oivan/model/userDetails.dart';
import 'package:oivan/provider/bookmark_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> users = [];
  List<UserDetails> usersDetails = [];
  late SharedPreferences sharedPreferences;

  void initialiseSavedData() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    var bookmarkModel = Provider.of<BookmarkModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rest API Call'),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BookmarksPage()));
                  },
                  icon: const Icon(Icons.bookmarks)),
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(""),
              )
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final displayName = user.displayName;
          final reputation = user.reputation;
          final profileImage = user.profileImage;
          final location = user.location;
          final userID = user.userID;
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UserDetailsScreen(
                            userIDTrans: users[index].userID)));
                  },
                  leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(profileImage)),
                  title: Text('$displayName, $userID'),
                  subtitle: Text(reputation.toString()),
                  trailing: Text(location.toString()),
                  visualDensity: VisualDensity.comfortable,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          bookmarkModel.addUsers(user);
                        },
                        icon: bookmarkModel.isExist(user)
                            ? const Icon(
                                Icons.bookmark,
                                color: Colors.red,
                              )
                            : const Icon(Icons.bookmark_border))
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void fetchUsers() async {
    const url =
        'https://api.stackexchange.com/2.2/users?page=1&pagesize=30&site=stackoverflow';
    final uri = Uri.parse(url);
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Accept-Language': 'application/json;charset=utf-t'
    };
    final response = await http.get(uri, headers: requestHeaders);
    final body = response.body;
    final json = jsonDecode(body);
    final items = json['items'] as List<dynamic>;
    final transformed = items.map((e) {
      return User(
          displayName: e['display_name'],
          reputation: e['reputation'],
          profileImage: e['profile_image'],
          location: e['location'],
          userID: e['user_id']);
    }).toList();
    setState(() {
      users = transformed;
    });
  }
}
