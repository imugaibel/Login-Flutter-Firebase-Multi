//   userRef.doc(userId).update({
//       "status-account": status.index,
//     }).then((value) async {
//       showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
//       addNotifications(
//           uidUser: userId,
//           titleEN: "Welcome",
//           titleAR: "مرحبا بك",
//           detailsEN: "Welcome to our app\nWe wish you a happy experience",
//           detailsAR: "مرحبا بك في تطبيقنا\nنتمنى لك تجربة رائعة");
//
//       await getAllUsers().first.then((users) {
//         for (var user in users) {
//           if (user.userType == UserType.ADMIN) {
//             addNotifications(
//                 uidUser: user.uid,
//                 titleEN: "$status User",
//                 titleAR: "مستخدم $status",
//                 detailsEN: "$userId new created a new account",
//                 detailsAR: "$userId أنشأ حساب جديد ");
//           }
//         }
//       });
//
//       scaffoldKey.showTosta(
//            message: AppLocalization.of(scaffoldKey.currentContext!)!
//                .trans("Done Successfully"));
//     }).catchError((err) {
//        showLoaderDialog(scaffoldKey.currentContext, isShowLoader: false);
//        scaffoldKey.showTosta(
//            message: AppLocalization.of(scaffoldKey.currentContext!)!
//                .trans("Something went wrong"),
//            isError: true);
//      });
//   }