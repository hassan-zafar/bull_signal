import 'package:bull_signal/Models/announcements_model.dart';
import 'package:bull_signal/Utils/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseApi {
  addAnnouncements(
      {required final String postId,
      required final String announcementTitle,
      required final String imageUrl,
      required final String eachUserId,
      required String eachUserToken,
      required final String description}) async {
    FirebaseFirestore.instance
        .collection("announcements")
        .doc(eachUserId)
        .collection("userAnnouncements")
        .doc(postId)
        .set({
      "announcementId": postId,
      "announcementTitle": announcementTitle,
      "description": description,
      "timestamp": DateTime.now(),
      "token": eachUserToken,
      "imageUrl": imageUrl,
      "userId": currentUser!.id
    });
  }

  Future getAnnouncements() async {
    List<AnnouncementsModel> tempAllAnnouncements = [];
    QuerySnapshot tempAnnouncementsSnapshot =
        await FirebaseFirestore.instance.collection('announcements').get();

    tempAnnouncementsSnapshot.docs.forEach((element) {
      tempAllAnnouncements.add(AnnouncementsModel.fromDocument(element));
    });
    return tempAllAnnouncements;
  }
}
