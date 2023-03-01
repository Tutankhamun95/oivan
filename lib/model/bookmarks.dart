import 'package:flutter/material.dart';
import 'package:oivan/model/user.dart';
import 'package:oivan/model/userDetails.dart';
import 'package:oivan/provider/bookmark_model.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  List<User> users = [];
  @override
  Widget build(BuildContext context) {
    var bookmarkModel = Provider.of<BookmarkModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarks"),
      ),
      body: ListView.builder(
          itemCount: bookmarkModel.users.length,
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserDetailsScreen(
                              userIDTrans: bookmarkModel.users[index].userID)));
                    },
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                            bookmarkModel.users[index].profileImage)),
                    title: Text(bookmarkModel.users[index].displayName +
                        bookmarkModel.users[index].userID.toString()),
                    subtitle:
                        Text(bookmarkModel.users[index].reputation.toString()),
                    trailing:
                        Text(bookmarkModel.users[index].location.toString()),
                    visualDensity: VisualDensity.comfortable,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
