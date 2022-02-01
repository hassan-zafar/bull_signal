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
                      : Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment:
                                // allAnnouncements[index].imageUrl != null
                                //     ? CrossAxisAlignment.center
                                //     :
                                CrossAxisAlignment.start,
                            children: [
                              allAnnouncements[index].imageUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                          imageUrl: allAnnouncements[index]
                                              .imageUrl!),
                                    )
                                  : Container(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  allAnnouncements[index].announcementTitle!,
                                  // style: customTextStyle(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  allAnnouncements[index].description!,
                                  // style: customTextStyle(fontSize: 18),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                    onTap: () => Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => CommentsNChat(
                                            postId: allAnnouncements[index]
                                                .announcementId,
                                            isPostComment: true,
                                            chatId: allAnnouncements[index]
                                                .announcementId,
                                            isAdmin: currentUser!.isAdmin,
                                            isProductComment: false,
                                          ),
                                        )),
                                    child: const Text(
                                      'View All Comments',
                                      style: TextStyle(
                                          color: Colors.cyan,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                            ],
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
