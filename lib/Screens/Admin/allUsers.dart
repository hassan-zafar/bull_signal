import 'package:bull_signal/Models/users.dart';
import 'package:bull_signal/Screens/comments_n_chat.dart';
import 'package:bull_signal/Screens/credentials/loginRelated/login_page.dart';
import 'package:bull_signal/Services/authentication_service.dart';
import 'package:bull_signal/Utils/consts.dart';
import 'package:bull_signal/tools/custom_toast.dart';
import 'package:bull_signal/tools/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserNSearch extends StatefulWidget {
  const UserNSearch({Key? key}) : super(key: key);

  // final UserModel currentUser;
  // UserNSearch({this.currentUser});
  @override
  _UserNSearchState createState() => _UserNSearchState();
}

class _UserNSearchState extends State<UserNSearch>
    with AutomaticKeepAliveClientMixin<UserNSearch> {
  Future<QuerySnapshot>? searchResultsFuture;
  TextEditingController searchController = TextEditingController();

  String typeSelected = 'users';
  handleSearch(String query) {
    if (currentUser!.isAdmin!) {
      Future<QuerySnapshot> users =
          userRef.where("name", isGreaterThanOrEqualTo: query).get();
      setState(() {
        searchResultsFuture = users;
      });
    } else {
      Future<QuerySnapshot> users = userRef
          .where("name", isGreaterThanOrEqualTo: query)
          .where("isAdmin", isNotEqualTo: true)
          .get();
      setState(() {
        searchResultsFuture = users;
      });
    }
  }

  clearSearch() {
    searchController.clear();
  }

  AppBar buildSearchField(context) {
    return AppBar(
      backgroundColor: Theme.of(context).accentColor,
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
            hintText: "Search",
            // hintStyle: TextStyle(color: Colors.black),
            prefixIcon: const Icon(
              Icons.search,
              // color: ColorsConsts.subTitle,
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.clear,
                // color: ColorsConsts.subTitle,
              ),
              onPressed: clearSearch,
            )),
        onFieldSubmitted: handleSearch,
      ),
    );
  }

  buildSearchResult() {
    return FutureBuilder<QuerySnapshot>(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoadingIndicator();
        }
        List<UserResult> searchResults = [];
        snapshot.data!.docs.forEach((doc) {
          String completeName = doc["name"].toString().toLowerCase().trim();
          if (completeName.contains(searchController.text)) {
            AppUserModel user = AppUserModel.fromDocument(doc);
            setState(() {
              UserResult searchResult = UserResult(user);
              searchResults.add(searchResult);
            });
          }
        });
        return ListView(
          children: searchResults,
        );
      },
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        appBar: buildSearchField(context),
        body:
            searchResultsFuture == null ? buildAllUsers() : buildSearchResult(),
      ),
    );
  }

  buildAllUsers() {
    return Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
            stream: userRef.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const LoadingIndicator();
              }
              List<UserResult> userResults = [];
              List<UserResult> allAdmins = [];

              snapshot.data!.docs.forEach((doc) {
                AppUserModel user = AppUserModel.fromDocument(doc);

                //remove auth user from recommended list
                if (user.isAdmin!) {
                  UserResult adminResult = UserResult(user);
                  allAdmins.add(adminResult);
                } else {
                  UserResult userResult = UserResult(user);
                  userResults.add(userResult);
                }
              });
              return ListView(
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  // currentUser!.isAdmin!
                  // ?
                  SizedBox(
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      typeSelected = "users";
                                    });
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "All Users ${userResults.length}",
                                        style: const TextStyle(fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      typeSelected = "admin";
                                    });
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "All Admins ${allAdmins.length}",
                                        style: const TextStyle(fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // : Container(),
                  typeSelected == 'admin'
                      ? Column(
                          children: allAdmins,
                        )
                      : const Text(""),
                  typeSelected == 'users'
                      ? Column(
                          children: userResults,
                        )
                      : const Text(''),
                ],
              );
            }),
        Positioned(
            left: 20,
            bottom: 20,
            child: GestureDetector(
              onTap: () {
                AuthenticationService().signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ));
              },
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.red,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("LogOut"),
                  )),
            ))
      ],
    );
  }
}

class UserResult extends StatelessWidget {
  final AppUserModel user;
  UserResult(this.user);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onLongPress: () => makeAdmin(context),
          onTap: () {
            if (user.id != currentUser!.id) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CommentsNChat(
                    chatId: user.id,
                    chatNotificationToken: user.androidNotificationToken),
              ));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person),
                ),
                title: Text(
                  user.name.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  user.name.toString(),
                ),
                trailing: Text(user.isAdmin != null && user.isAdmin == true
                    ? "Admin"
                    : "User"),
              ),
            ),
          ),
        ),
      ],
    );
  }

  makeAdmin(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              user.isAdmin! && user.id != currentUser!.id
                  ? SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        makeAdminFunc("Rank changed to User");
                      },
                      child: const Text(
                        'Make User',
                      ),
                    )
                  : SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                        makeAdminFunc("Upgraded to Admin");
                      },
                      child: const Text(
                        'Make Admin',
                      ),
                    ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  deleteUser(user.email!, user.password!);
                },
                child: const Text(
                  'Delete User',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              )
            ],
          );
        });
  }

  void makeAdminFunc(String msg) {
    userRef.doc(user.id).update({"isAdmin": !user.isAdmin!});
    addToFeed(msg);

    // BotToast.showText(text: msg);
  }

  addToFeed(String msg) {
    // activityFeedRef.doc(user.id).collection('feedItems').add({
    //   "type": "mercReq",
    //   "commentData": msg,
    //   "userName": user.displayName,
    //   "userId": user.id,
    //   "userProfileImg": user.photoUrl,
    //   "ownerId": currentUser.id,
    //   "mediaUrl": currentUser.photoUrl,
    //   "timestamp": timestamp,
    //   "productId": "",
    // });
  }
  void deleteUser(String email, String password) async {
    AuthenticationService().deleteUser(email: email, password: password);
    successToast(message: 'User Deleted Refresh');
  }
}
