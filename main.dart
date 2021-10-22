import 'package:dart_appwrite/dart_appwrite.dart';

var client = Client();
var collectionId;
var userId;
var fileId;
var functionId;

var projectid = '608fa1dd20ef0'; // Your Project Id
var endpoint = 'https://demo.appwrite.io/v1'; // Your Endpoint
var secret = 'd1a94d585f2b3501a0c7121162cbb722a47bba32583c35acc20ca887d3187d10ea2b061bc9d9f164901f79b8c7f54075edb4d6dadd99318469b9dfa6b9bab883f4f6d7feff7e0857e2919ba315faf617a612c01a5ba51493f7f561c0ac2dcd9962df8da164e44a08b641bd31b2259ce35fd0ff1a816923fde456df7a549647d7'; // Your API Key

Future<void> main() async {
  client
      .setEndpoint(endpoint) // Make sure your endpoint is accessible
      .setProject(projectid) // Your project ID
      .setKey(secret) // Your appwrite key
      // .setJWT('jwt') // Enable this to authenticate with JWT created using client SDK
      .setSelfSigned(status: true); //Do not use this in production

  // getAccount(); // works only with JWT

  await createCollection();
  await listCollection();
  await addDoc();
  await listDoc();
  await deleteCollection();

  await uploadFile();
  await deleteFile();

  await createUser('${DateTime.now().millisecondsSinceEpoch}@example.com',
      'user@123', 'Some user');
  await listUser();
  await deleteUser();

  await createFunction();
  await listFunctions();
  await deleteFunction();
}

Future getAccount() async {
  final account = Account(client);
  print("Running get Account API");
  try {
    final res1 = await account.get();
    print(res1.toMap());
  } on AppwriteException catch (e) {
    print(e.message);
  }
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
    collectionId = res.$id;
    print(res.toMap());
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> listCollection() async {
  final database = Database(client);
  print("Running list collection API");
  try {
    final res = await database.listCollections();
    final collection = res.collections[0];
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
    print(response.toMap());
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> uploadFile() async {
  final storage = Storage(client);
  print('Running Upload File API');
  final file =
      await MultipartFile.fromPath('file', './nature.jpg', filename: 'nature.jpg');
  try {
    final response = await storage.createFile(
      file: file, //multipart file
      read: ['*'],
      write: ['*'],
    );
    fileId = response.$id;
    print(response.toMap());
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> deleteFile() async {
  final storage = Storage(client);
  print('Running Delete File API');
  try {
    await storage.deleteFile(fileId: fileId);
    print("File deleted");
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
    userId = response.$id;
    print(response.toMap());
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> listUser() async {
  final users = Users(client);
  print('Running List User API');
  try {
    final response = await users.list();
    print(response.toMap());
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> deleteUser() async {
  final users = Users(client);
  print("Running delete user");
  try {
    await users.delete(userId: userId);
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
        name: 'test function', execute: [], runtime: 'dart-2.12');
    print(res.toMap());
    functionId = res.$id;
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> listFunctions() async {
  final functions = Functions(client);
  print('Running List Functions API');
  try {
    final res = await functions.list();
    print(res.toMap());
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> deleteFunction() async {
  final functions = Functions(client);
  print('Running Delete Function API');
  try {
    await functions.delete(functionId: functionId);
    print('Function deleted');
  } on AppwriteException catch (e) {
    print(e.message);
  }
}
