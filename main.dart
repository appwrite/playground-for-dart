import 'package:dart_appwrite/dart_appwrite.dart';

var client = Client();
var collectionId;
var userId;

Future<void> main() async {
  client
      .setEndpoint(
          'http://localhost/v1') // Make sure your endpoint is accessible
      .setProject('60793ca4ce59e') // Your project ID
      .setKey(
          '98c3cbd9c8746548e017f58937f0e8c8de0d49e932ac9db38af260cc2d94cd26abf155c26524365046b941404860c8fa23b15547331e4155d5b3ae74619bd97dbed227f717c58bc80bc34f9822c24013ce6585ce2119243a9c95c22e63a95c495d6c8c6f5a7243595a369f60a573c2022689296e3fe99773da1567f538630240') // Your appwrite key
      .setSelfSigned(status: true); //Do not use this in production

  //running all apis
  await createCollection();
  await listCollection();
  await deleteCollection();
  await addDoc();
  await listDoc();
  await uploadFile();
  await createUser('${DateTime.now().millisecondsSinceEpoch}@example.com',
      'user@123', 'Some user');
  await listUser();
  await deleteUser();
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
  } on AppwriteException catch (e) {
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
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> deleteCollection() async {
  final database = Database(client);
  print("Running delete collection API");
  try {
    await database.deleteCollection(collectionId: collectionId);
    print("collection deleted");
  } on AppwriteException catch (e) {
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
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> listDoc() async {
  final database = Database(client);
  print('Running List Document API');
  try {
    final response = await database.listDocuments(collectionId: collectionId);
    print(response.data);
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> uploadFile() async {
  final storage = Storage(client);
  print('Running Upload File API');
  final file =
      await MultipartFile.fromFile('./nature.jpg', filename: 'nature.jpg');
  try {
    final response = await storage.createFile(
      file: file, //multipart file
      read: ['*'],
      write: ['*'],
    );
    print(response);
  } on AppwriteException catch (e) {
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
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> listUser() async {
  final users = Users(client);
  print('Running List User API');
  try {
    final response = await users.list();
    print(response.data);
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> deleteUser() async {
  final users = Users(client);
  print("Running delete user");
  try {
    await users.deleteUser(userId: userId);
    print("user deleted");
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> createFunction() async {
  final functions = Functions(client);
  print('Running Create Function API');
  try {
    final res = await functions.create(
        name: 'test function', execute: [], env: 'dart-2.10');
    print(res.data);
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> listFunctions() async {
  final functions = Functions(client);
  print('Running List Functions API');
  try {
    final res = await functions.list();
    print(res.data);
  } on AppwriteException catch (e) {
    print(e.message);
  }
}
