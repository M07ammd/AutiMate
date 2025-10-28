# Team Photos Directory

## كيفية إضافة صور أعضاء الفريق

ضع صور أعضاء الفريق في هذا المجلد بالأسماء التالية:

### الصور المطلوبة:

1. **member1.jpg** - صورة العضو الأول (Ahmed Mohamed - Project Manager)
2. **member2.jpg** - صورة العضو الثاني (Sara Ali - UI/UX Designer)
3. **member3.jpg** - صورة العضو الثالث (Mohamed Hassan - Full Stack Developer)
4. **member4.jpg** - صورة العضو الرابع (Fatima Khaled - AI Specialist)
5. **member5.jpg** - صورة العضو الخامس (Omar Ibrahim - Backend Developer)

### مواصفات الصور:

- **الحجم المثالي**: 400x400 بكسل (مربعة)
- **الصيغة**: JPG, PNG, أو WEBP
- **الحجم**: أقل من 500KB لكل صورة
- **الجودة**: عالية وواضحة
- **الخلفية**: يفضل خلفية موحدة أو احترافية

### ملاحظات:

- الصور ستظهر بشكل دائري في الموقع
- تأكد من أن الوجه في منتصف الصورة
- استخدم صور احترافية للحصول على أفضل نتيجة

### إذا كنت تريد تغيير الأسماء:

افتح ملف `src/components/Team.jsx` وغير قيمة `image` لكل عضو:

```javascript
{
  id: 1,
  name: 'Ahmed Mohamed',
  role: 'Project Manager',
  image: '/team/your-custom-name.jpg', // غير الاسم هنا
  ...
}
```

---

## How to Add Team Member Photos

Place team member photos in this directory with the following names:

### Required Photos:

1. **member1.jpg** - First member photo (Ahmed Mohamed - Project Manager)
2. **member2.jpg** - Second member photo (Sara Ali - UI/UX Designer)
3. **member3.jpg** - Third member photo (Mohamed Hassan - Full Stack Developer)
4. **member4.jpg** - Fourth member photo (Fatima Khaled - AI Specialist)
5. **member5.jpg** - Fifth member photo (Omar Ibrahim - Backend Developer)

### Image Specifications:

- **Ideal Size**: 400x400 pixels (square)
- **Format**: JPG, PNG, or WEBP
- **File Size**: Less than 500KB per image
- **Quality**: High and clear
- **Background**: Preferably solid or professional background

### Notes:

- Images will appear circular on the website
- Make sure the face is centered in the image
- Use professional photos for best results

### To Change File Names:

Open `src/components/Team.jsx` and change the `image` value for each member:

```javascript
{
  id: 1,
  name: 'Ahmed Mohamed',
  role: 'Project Manager',
  image: '/team/your-custom-name.jpg', // Change name here
  ...
}
```

