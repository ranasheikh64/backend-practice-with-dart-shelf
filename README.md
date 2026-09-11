# Dart Backend Demo (with MongoDB)

এই প্রোজেক্টটিতে Dart এবং `shelf` ব্যবহার করে একটি সম্পূর্ণ **REST API** তৈরি করা হয়েছে, যা MongoDB ডেটাবেসের সাথে যুক্ত। এখানে একটি স্কেলেবল ফোল্ডার স্ট্রাকচার (যেমন MVC বা Clean Architecture) অনুসরণ করা হয়েছে।

## ফিচারসমূহ
- **CRUD Operations**: ইউজারের ডাটা তৈরি (Create), পড়া (Read), আপডেট (Update) এবং ডিলিট (Delete) করার সুবিধা।
- **MongoDB Integration**: ডাটা সেভ করার জন্য `mongo_dart` প্যাকেজ ব্যবহার করে MongoDB এর সাথে কানেকশন।
- **Scalable Folder Structure**: Controllers, Models, Repositories, এবং Routes আলাদা ফোল্ডারে ভাগ করে কোড গুছিয়ে রাখা হয়েছে।

## প্রোজেক্ট সেটআপ

### ১. ডেটাবেস প্রস্তুত করা
আপনার মেশিনে MongoDB রান করা থাকতে হবে। বাই-ডিফল্ট এটি লোকালহোস্টে (`mongodb://localhost:27017/dart_backend_db`) কানেক্ট করার চেষ্টা করবে।
> *নোট: আপনি চাইলে `lib/config/database.dart` ফাইলে গিয়ে `mongoUri` পরিবর্তন করে আপনার MongoDB Atlas (Cloud) এর লিংক বসাতে পারেন।*

### ২. প্যাকেজ ইনস্টল করা
টার্মিনালে প্রোজেক্টের রুটে গিয়ে নিচের কমান্ডটি রান করুন:
```bash
dart pub get
```

### ৩. সার্ভার চালু করা
সার্ভার চালু করতে নিচের কমান্ডটি রান করুন:
```bash
dart run bin/dart_backend_demo.dart
```
সার্ভার চালু হলে টার্মিনালে দেখতে পাবেন:
`MongoDB Connected successfully!`
`সার্ভার চালু হয়েছে: http://localhost:8080`

## API এন্ডপয়েন্ট (কিভাবে টেস্ট করবেন)

আপনি **Postman**, **Insomnia** অথবা **cURL** ব্যবহার করে API গুলো টেস্ট করতে পারেন।

### ১. নতুন ইউজার তৈরি (Create User)
- **Method:** POST
- **URL:** `http://localhost:8080/users`
- **Body (JSON):**
```json
{
  "name": "Rahim",
  "email": "rahim@example.com",
  "age": 25
}
```

### ২. সব ইউজার দেখা (Get All Users)
- **Method:** GET
- **URL:** `http://localhost:8080/users`

### ৩. নির্দিষ্ট একজন ইউজার দেখা (Get Single User)
- **Method:** GET
- **URL:** `http://localhost:8080/users/<USER_ID>` (উদাহরণ: `/users/60d5ec49e29a...`)

### ৪. ইউজার আপডেট করা (Update User)
- **Method:** PUT
- **URL:** `http://localhost:8080/users/<USER_ID>`
- **Body (JSON):**
```json
{
  "name": "Rahim Uddin",
  "age": 26
}
```

### ৫. ইউজার ডিলিট করা (Delete User)
- **Method:** DELETE
- **URL:** `http://localhost:8080/users/<USER_ID>`

---
*এই প্রোজেক্টটি Dart দিয়ে ব্যাকএন্ড শেখার জন্য একটি চমৎকার শুরু!*
# backend-practice-with-dart-shelf
