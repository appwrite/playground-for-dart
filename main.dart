import 'package:dart_appwrite/dart_appwrite.dart';

var client = Client();
var collectionId;
var userId;

Future<void> main() async {
  client
      .setEndpoint(
          'http://localhost/v1') // Make sure your endpoint is accessible
      .setProject('YOUR_PROJECT_ID') // Your project ID
      .setKey(
          'YOUR_APPWRITE_KEY') // Your appwrite key
      .setSelfSigned(status: true); //Do not use this in production

  //running all apis
  await createCollection();
  await listCollection();
  await addDoc();
  await listDoc();
  await uploadFile();
  await createUser('${DateTime.now().millisecondsSinceEpoch}@example.com',
      'user@123', 'Some user');
  await listUser();
  await createFunction();
  await listFunctions();
}

Future<void> createCollection() async {
  final database = Database(client);
  print('Running create collection API');
  try {

    final res = await database.createCollection(name: 'Movies', read: [
      '*'
    ], write: [
      '*'
    ], rules: [
      {
        'label': 'Name',
        'key': 'name',
        'type': 'text',
        'default': 'Empty Name',
        'required': true,
        'array': false
      },
      {
        'label': 'release_year',
        'key': 'release_year',
        'type': 'numeric',
        'default': 1970,
        'required': true,
        'array': false
      }
    ]);
    collectionId = res.data['\$id'];
    print(res.data);
  } on AppwriteException catch(e) {
    print(e.message);
  }
}

Future<void> listCollection() async {
  final database = Database(client);
  print("Running list collection API");
  try {
    final res = await database.listCollections();
    final collection = res.data["collections"][0];
    print(collection);
  } on AppwriteException catch(e) {
    print(e.message);
  }
}

Future<void> addDoc() async {
  final database = Database(client);
  print('Running Add Document API');
  try {
    final res = await database.createDocument(
        collectionId: collectionId,
        data: {'name': 'Spider Man', 'release_year': 1920},
        read: ['*'],
        write: ['*']);
    print(res.data);
  } on AppwriteException catch(e) {
    print(e.message);
  }
}

Future<void> listDoc() async {
  final database = Database(client);
  print('Running List Document API');
  try {
    final response = await database.listDocuments(collectionId: collectionId);
    print(response.data);
  } on AppwriteException catch(e) {
    print(e.message);
  }
}

Future<void> uploadFile () async {
  final storage = Storage(client);
  print('Running Upload File API');
  final file = await MultipartFile.fromFile('./nature.jpg',filename: 'nature.jpg');
  try {
    final response = await storage.createFile(
      file: file,//multipart file
      read: ['*'],
      write: ['*'],
    );
    print(response);
  } on AppwriteException catch(e) {
    print(e.message);
  }
}

Future<void> createUser(email, password, name) async {
  final users = Users(client);
  print('Running Create User API');
  try {
    final response =
        await users.create(email: email, password: password, name: name);
    userId = response.data['\$id'];
    print(response.data);
  } on AppwriteException catch(e) {
    print(e.message);
  }
}

Future<void> listUser() async {
  final users = Users(client);
  print('Running List User API');
  try {
    final response = await users.list();
    print(response.data);
  } on AppwriteException catch(e) {
    print(e.message);
  }
}

Future<void> createFunction() async {
  final functions = Functions(client);
  print('Running Create Function API');
  try {
    final res = await functions.create(name: 'test function', execute: [], env: 'dart-2.10');
    print(res.data);
  } on AppwriteException catch(e) {
    print(e.message);
  }
}

Future<void> listFunctions() async {
  final functions = Functions(client);
  print('Running List Functions API');
  try {
    final res = await functions.list();
    print(res.data);
  } on AppwriteException catch(e) {
    print(e.message);
  }
}
