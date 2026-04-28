# Build APK from mobile using Codemagic

1. افتح https://codemagic.io وسجل دخول بحساب Google.
2. ارفع هذا المشروع إلى GitHub أو GitLab.
3. من Codemagic اختر Add application ثم اختر المشروع.
4. اختار workflow باسم: `ALMCO Work Tracker - Android APK`.
5. اضغط Start new build.
6. بعد انتهاء البناء، حمل ملف `app-release.apk` من Artifacts.
7. انقل APK للموبايل وثبته.

ملاحظة: ملف Firebase `google-services.json` موجود داخل المشروع ومطابق للباكدج:
`com.almco.worktracker`.
