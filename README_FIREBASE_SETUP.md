Firebase-ready package. Replace lib/firebase_options.dart using flutterfire configure, enable Firebase Auth, Firestore, and Storage, then add admin user document in users/{UID} with role admin.


## Added in v3
- Firebase options filled from uploaded google-services.json.
- GPS capture for submitted reports.
- Admin toggle: require GPS before submit.
- Firebase Cloud Messaging setup helper.
- Cloud Functions in `cloud_functions/` to notify admins when a report is submitted and notify users when approval status changes.
- Admin toggle: enable/disable notifications.

To deploy notifications:
1. Enable Cloud Messaging in Firebase.
2. From `cloud_functions/`, run `npm install`.
3. Run `firebase deploy --only functions`.
