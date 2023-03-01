import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oivan/model/user.dart';
import 'package:http/http.dart' as http;

class UserDetailsScreen extends StatefulWidget {
  final int userIDTrans;
  const UserDetailsScreen({super.key, required this.userIDTrans});
  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  List<UserDetails> usersDetails = [];
  @override
  void initState() {
    super.initState();
    fetchUserDetails(widget.userIDTrans);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("SOF User Reputation"),
        ),
        body: ListView.builder(
          itemCount: usersDetails.length,
          itemBuilder: (context, index) {
            final user = usersDetails[index];
            final reputationHistoryType = user.reputationHistoryType;
            final reputationChange = user.reputationChange;
            final creationDate = user.creationDate;
            final postID = user.postID;
            return Card(
              child: ExpansionTile(
                title: Text(
                  'Post ID: ' '$postID',
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                children: <Widget>[
                  Row(
                    children: [
                      const Text(
                        'Reputation Type: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(reputationHistoryType),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'Reputation Change: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(reputationChange.toString()),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Created At: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(creationDate.toString()),
                    ],
                  ),
                ],
              ),
            );
          },
        ));
  }

  void fetchUserDetails(userid) async {
    final uri = Uri.parse(
        "https://api.stackexchange.com/2.2/users/$userid/reputation-history?page=1&pagesize=30&site=stackoverflow");
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'Accept-Language': 'application/json;charset=utf-t'
    };
    final response = await http.get(uri, headers: requestHeaders);
    final body = response.body;
    final json = jsonDecode(body);
    // print(body);
    final items = json['items'] as List<dynamic>;
    final transformedDetails = items.map((e) {
      return UserDetails(
          reputationHistoryType: e['reputation_history_type'],
          reputationChange: e['reputation_change'],
          creationDate: e['creation_date'],
          postID: e['post_id']);
    }).toList();
    setState(() {
      usersDetails = transformedDetails;
    });
  }
}
