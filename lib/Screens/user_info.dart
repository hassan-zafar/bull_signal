import 'package:bull_signal/Utils/consts.dart';
import 'package:bull_signal/tools/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  ScrollController? _scrollController;
  var top = 0.0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // String? _uid;
  // String? _name;
  // String? _email;
  // String? _joinedAt;
  // String? _userImageUrl;
  // int? _phoneNumber;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      setState(() {});
    });
    // getData();
  }

  // void getData() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   User user = DatabaseMethods().fetchUserInfoFromFirebase(uid: uid);
  //   _uid = user.uid;

  //   print('user.displayName ${user.displayName}');
  //   print('user.photoURL ${user.photoURL}');
  //   DocumentSnapshot<Map<String, dynamic>>? userDoc = user.isAnonymous
  //       ? null
  //       : await FirebaseFirestore.instance.collection('users').doc(_uid).get();
  //   // .then((value) {
  //   // if (user.isAnonymous) {
  //   //   userDoc = null;
  //   // } else {
  //   //   userDoc = value;
  //   // }
  //   // });
  //   if (userDoc == null) {
  //     return;
  //   } else {
  //     setState(() {
  //       currentUser = AppUserModel.fromDocument(userDoc);
  //       _name = userDoc.get('name');
  //       _email = user.email!;
  //       _joinedAt = userDoc.get('joinedAt');
  //       _phoneNumber = userDoc.get('phoneNumber');
  //       _userImageUrl = userDoc.get('imageUrl');
  //       isLoading = false;
  //     });
  //   }

  //   // print("name $_name");
  // }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    final notificationChange = Provider.of<NotificationSetProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? const LoadingIndicator()
            : Stack(
                children: [
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: <Widget>[
                      SliverAppBar(
                        // leading: Icon(Icons.ac_unit_outlined),
                        // automaticallyImplyLeading: false,
                        elevation: 0,
                        expandedHeight: 250,
                        pinned: true,
                        flexibleSpace: LayoutBuilder(builder:
                            (BuildContext context, BoxConstraints constraints) {
                          top = constraints.biggest.height;

                          return Container(
                            decoration: const BoxDecoration(
                                // gradient: LinearGradient(
                                //     colors: [
                                //       ColorsConsts.starterColor,
                                //       ColorsConsts.endColor,
                                //     ],
                                //     begin: const FractionalOffset(0.0, 0.0),
                                //     end: const FractionalOffset(1.0, 0.0),
                                //     stops: [0.0, 1.0],
                                //     tileMode: TileMode.clamp),
                                ),
                            child: FlexibleSpaceBar(
                              // collapseMode: CollapseMode.parallax,
                              centerTitle: true,
                              title: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: top <= 110.0 ? 1.0 : 0,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Container(
                                      height: kToolbarHeight / 1.8,
                                      width: kToolbarHeight / 1.8,
                                      decoration: const BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white,
                                            blurRadius: 1.0,
                                          ),
                                        ],
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              'https://t3.ftcdn.net/jpg/01/83/55/76/240_F_183557656_DRcvOesmfDl5BIyhPKrcWANFKy2964i9.jpg'),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      // 'top.toString()',
                                      currentUser!.name! == null
                                          ? 'Guest'
                                          : currentUser!.name!,
                                      style: const TextStyle(
                                          fontSize: 20.0, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              background: Column(
                                children: [
                                  Text(
                                    "Settings",
                                    style: titleTextStyle(color: Colors.white),
                                  ),
                                  const CircleAvatar(
                                    maxRadius: 50,
                                    minRadius: 30,
                                    backgroundImage: CachedNetworkImageProvider(
                                        'https://t3.ftcdn.net/jpg/01/83/55/76/240_F_183557656_DRcvOesmfDl5BIyhPKrcWANFKy2964i9.jpg'),
                                  ),
                                  Text(
                                    currentUser!.name! == null
                                        ? 'Guest'
                                        : currentUser!.name!,
                                    style: titleTextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context).dividerColor),
                                  ),

                                  // Container(
                                  //   margin: EdgeInsets.only(top: 8),
                                  //   padding: EdgeInsets.all(8),
                                  //   decoration: BoxDecoration(
                                  //       color: Colors.teal,
                                  //       borderRadius:
                                  //           BorderRadius.circular(20)),
                                  //   child: Text("Edit Profile"),
                                  // ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            userTitle(title: 'Content'),
                            userTitle(title: 'User preferences'),
                            userTitle(title: "Account"),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => Navigator.of(context)
                                    .pushNamed(BillingScreen.routeName),
                                splashColor: Colors.red,
                                child: const ListTile(
                                  title: Text('Billing'),
                                  trailing: Icon(Icons.chevron_right_rounded),
                                  leading: Icon(Icons.credit_card),
                                ),
                              ),
                            ),
                            currentUser!.isAdmin!
                                ? Container()
                                : Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            CommentsNChatAdmin(
                                          chatId: currentUser!.id,
                                          chatNotificationToken: currentUser!
                                              .androidNotificationToken,
                                        ),
                                      )),
                                      splashColor: Colors.red,
                                      child: const ListTile(
                                        title: Text('Report a Problem'),
                                        trailing:
                                            Icon(Icons.chevron_right_rounded),
                                        leading: Icon(Icons.flag),
                                      ),
                                    ),
                                  ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Theme.of(context).splashColor,
                                child: ListTile(
                                  onTap: () async {
                                    // Navigator.canPop(context)? Navigator.pop(context):null;
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext ctx) {
                                          return AlertDialog(
                                            title: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 6.0),
                                                  child: Image.network(
                                                    'https://image.flaticon.com/icons/png/128/1828/1828304.png',
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text('Sign out'),
                                                ),
                                              ],
                                            ),
                                            content: const Text(
                                                'Do you wanna Sign out?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel')),
                                              TextButton(
                                                  onPressed: () async {
                                                    await _auth.signOut().then(
                                                        (value) =>
                                                            Navigator.pop(
                                                                context));
                                                  },
                                                  child: const Text(
                                                    'Ok',
                                                    style: const TextStyle(
                                                        color: Colors.red),
                                                  ))
                                            ],
                                          );
                                        });
                                  },
                                  title: const Text('Logout'),
                                  leading:
                                      const Icon(Icons.exit_to_app_rounded),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  // _buildFab()
                ],
              ),
      ),
    );
  }

  Widget _buildFab() {
    //starting fab position
    final double defaultTopMargin = 200.0 - 4.0;
    //pixels from top where scaling should start
    final double scaleStart = 160.0;
    //pixels from top where scaling should end
    final double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (_scrollController!.hasClients) {
      double offset = _scrollController!.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down

        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        //offset between scaleStart and scaleEnd => scale down

        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        //offset passed scaleEnd => hide fab
        scale = 0.0;
      }
    }

    return Positioned(
      top: top,
      right: 16.0,
      child: Transform(
        transform: Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child: FloatingActionButton(
          backgroundColor: Colors.purple,
          heroTag: "btn1",
          onPressed: () {},
          child: const Icon(Icons.camera_alt_outlined),
        ),
      ),
    );
  }

  List<IconData> _userTileIcons = [
    Icons.email,
    Icons.phone,
    Icons.local_shipping,
    Icons.watch_later,
    Icons.exit_to_app_rounded
  ];

  Widget userListTile(
      String title, String subTitle, int index, BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subTitle),
      leading: Icon(_userTileIcons[index]),
    );
  }

  Widget userTitle({required String title}) {
    return Container(
      width: double.maxFinite,
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 23,
        ),
      ),
    );
  }
}
