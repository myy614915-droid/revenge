# Call Supabase process-battles Workflow

ملف GitHub Actions هذا يقوم باستنساخ المستودع إلى مجلد مؤقت ثم يدعو Supabase Edge Function المسماة `process-battles`.

قبل الاستخدام:
1. أضف Secrets في المستودع (Settings → Secrets and variables → Actions):
   - SUPABASE_URL: مثال `https://<project-ref>.supabase.co`
   - SUPABASE_SERVICE_ROLE_KEY: مفتاح service_role (أو أي اسم تريد؛ إذا غيرت الاسم عدّل الـ workflow env)

2. تأكد من وجود السكربت `scripts/call_process_battles.sh` في المستودع (مرفق).

تشغيل:
- اذهب إلى صفحة Actions في GitHub → اختر "Call Supabase process-battles" → Run workflow.

ملاحظات:
- لا تطبع أو تشارك الـ SUPABASE_SERVICE_ROLE_KEY أو SUPABASE_URL كاملة في السجلات.
- إذا كان المستودع خاصًا ولا يمكن استنساخه عبر HTTPS بدون مصادقة، قم باستخدام طريقة مصادقًة (مثل إضافة token للـ URL) أو اجعل الـ repo متاحًا للـ runner.
