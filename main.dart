import 'package:dart_appwrite/dart_appwrite.dart';

var client = Client();
var collectionId;
var userId;
var fileId;
var functionId;

var projectid = 'playground'; // Your Project Id
var endpoint = 'https://dlo12test.appwrite.org/v1'; // Your Endpoint
var secret =
    'd9dfb89721d44d799cada445d2b7ded0bfbd4ac8ce789ef0a78802fa6872300c0774e94e07bc8042b5af279951ec5e8fe303e985183a0cea603a129c601b3a63c816eb10dfbcc2053716fde9e5fb572d4b41eb6058a7313646386c8f8cabbec3ae06393e56ab97c4c11dd51ea98f8696ab2e61bda3a19dc6cef399a5e36295f1'; // Your API Key

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
    final res = await database.createCollection(
      collectionId: "movies",
      permission: 'document',
      name: 'Movies',
      read: ['role:all'],
      write: ['role:all'],
    );
    collectionId = res.$id;
    await database.createStringAttribute(
        collectionId: collectionId,
        key: 'name',
        size: 60,
        xrequired: true);
    await database.createIntegerAttribute(
      collectionId: collectionId,
      key: 'release_year',
      xrequired: true,
      array: false,
    );
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
    print(collection.toMap());
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
        documentId: 'unique()',
        collectionId: collectionId,
        data: {'name': 'Spider Man', 'release_year': 1920},
        read: ['role:all'],
        write: ['role:all']);
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
  final file = await MultipartFile.fromPath('file', './nature.jpg',
      filename: 'nature.jpg');
  try {
    final response = await storage.createFile(
      fileId: 'unique()',
      file: file, //multipart file
      read: ['role:all'],
      write: ['role:all'],
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
        await users.create(userId: 'unique()', email: email, password: password, name: name);
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
      functionId: 'testfunction',
        name: 'test function', execute: [], runtime: 'php-8.0');
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
