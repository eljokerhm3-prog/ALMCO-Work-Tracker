const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.notifyAdminsOnReportSubmit = functions.firestore
  .document('reports/{reportId}')
  .onCreate(async (snap, context) => {
    const report = snap.data();
    if (report.draft || report.notificationRequired === false) return null;

    const admins = await admin.firestore()
      .collection('users')
      .where('role', '==', 'admin')
      .where('notificationsEnabled', '==', true)
      .get();

    const tokens = admins.docs.map(d => d.data().fcmToken).filter(Boolean);
    if (!tokens.length) return null;

    await admin.messaging().sendEachForMulticast({
      tokens,
      notification: {
        title: 'New work report submitted',
        body: `${report.site || 'Site'} - ${report.activity || 'Activity'} by ${report.user || 'User'}`,
      },
      data: {
        reportId: context.params.reportId,
        site: String(report.site || ''),
        activity: String(report.activity || ''),
      },
    });
    return null;
  });

exports.notifyUserOnApprovalChange = functions.firestore
  .document('reports/{reportId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    if (before.approvalStatus === after.approvalStatus) return null;
    if (!after.userId) return null;

    const user = await admin.firestore().collection('users').doc(after.userId).get();
    const token = user.data() && user.data().fcmToken;
    if (!token) return null;

    await admin.messaging().send({
      token,
      notification: {
        title: 'Report approval updated',
        body: `Status: ${after.approvalStatus || 'Updated'}`,
      },
      data: { reportId: context.params.reportId },
    });
    return null;
  });
