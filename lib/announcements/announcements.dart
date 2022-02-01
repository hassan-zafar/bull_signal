import 'package:bull_signal/Models/announcements_model.dart';
import 'package:bull_signal/Screens/comments_n_chat.dart';
import 'package:bull_signal/Screens/user_info.dart';
import 'package:bull_signal/Services/firebase_api.dart';
import 'package:bull_signal/Utils/consts.dart';
import 'package:bull_signal/tools/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'addAnnouncements.dart';

class Announcements extends StatefulWidget {
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  List<AnnouncementsModel> allAnnouncements = [];
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    getAnnouncements();
  }

  getAnnouncements() async {
    setState(() {
      _isLoading = true;
      this.allAnnouncements = [];
    });
    List<AnnouncementsModel> allAnnouncements =
        await FirebaseApi().getAnnouncements();
    setState(() {
      this.allAnnouncements = allAnnouncements;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: currentUser == null
          ? const LoadingIndicator()
          : currentUser!.isAdmin!
              ? FloatingActionButton(
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(
                        builder: (context) => AddAnnouncements(),
                      ))
                      .then((value) => getAnnouncements()),
                  child: const Icon(Icons.add),
                  tooltip: "Add New Announcement",
                )
              : Container(),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Announcements",
          style: titleTextStyle(
              color: Theme.of(context).primaryTextTheme.bodyText1!.color!),
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserInfoScreen(),
                  )),
              icon: Icon(Icons.person))
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                  onLongPress: () {
                    return currentUser!.isAdmin!
                        ? deleteNotification(
                            context, allAnnouncements[index].announcementId!)
                        : null;
                  },
                  child: _isLoading
                      ? const LoadingIndicator()
                      : Container(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment:
                                  allAnnouncements[index].imageUrl != null
                                      ? CrossAxisAlignment.center
                                      : CrossAxisAlignment.start,
                              children: [
                                allAnnouncements[index].imageUrl != null
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            allAnnouncements[index].imageUrl!)
                                    : Container(),
                                Text(
                                  allAnnouncements[index].announcementTitle!,
                                  style: customTextStyle(),
                                ),
                                Text(
                                  allAnnouncements[index].description!,
                                  style: customTextStyle(fontSize: 18),
                                ),
                                GestureDetector(
                                    onTap: () => Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              CommentsNMessages(
                                            postId: allAnnouncements[index]
                                                .announcementId,
                                            androidNotificationToken:
                                                currentUser!
                                                    .androidNotificationToken!,
                                            userId: currentUser!.id,
                                            isComment: true,
                                            isProductComment: false,
                                          ),
                                        )),
                                    child: const Text('View All Comments')),
                              ],
                            ),
                          ),
                        ),
                ),
              );
            },
            itemCount: allAnnouncements.length,
          ),
        ],
      ),
    );
  }

  deleteNotification(BuildContext parentContext, String id) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  getAnnouncements();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Delete Announcement',
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
}
