import 'package:dart_appwrite/dart_appwrite.dart';
import 'config.dart';

var client = Client();
var databaseId;
var collectionId;
var userId;
var fileId;
var functionId;
var bucketId;

Future<void> main() async {
  client
      .setEndpoint(endpoint) // Make sure your endpoint is accessible
      .setProject(projectId) // Your project ID
      .setKey(key) // Your appwrite key
      // .setJWT('jwt') // Enable this to authenticate with JWT created using client SDK
      .setSelfSigned(status: true); //Do not use this in production

  // getAccount(); // works only with JWT
  await createDatabase();
  await listDatabases();
  await createCollection();
  await listCollection();
  await addDoc();
  await listDoc();
  await deleteCollection();
  await deleteDatabase();

  await createBucket();
  await listBucket();
  await uploadFile();
  await deleteFile();
  await deleteBucket();

  await createUser(
    '${DateTime.now().millisecondsSinceEpoch}@example.com',
    'user@123',
    'Some user',
  );
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

Future<void> createDatabase() async {
  print('Running Create Database API');
  final databases = Databases(client);
  try {
    final db = await databases.create(
      databaseId: ID.unique(),
      name: 'Movies DB',
    );
    databaseId = db.$id;
    print(db.toMap());
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> listDatabases() async {
  print('Running List Databases API');
  final databases = Databases(client);
  try {
    final db = await databases.list();
    print(db.toMap());
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> createCollection() async {
  final database = Databases(client);
  print('Running create collection API');
  try {
    final res = await database.createCollection(
      databaseId: databaseId,
      collectionId: ID.unique(),
      documentSecurity: true,
      name: 'Movies',
      permissions: [
        Permission.read(Role.any()),
        Permission.write(Role.any()),
      ],
    );
    collectionId = res.$id;
    await database.createStringAttribute(
      databaseId: databaseId,
      collectionId: collectionId,
      key: 'name',
      size: 60,
      xrequired: true,
    );
    await database.createIntegerAttribute(
      databaseId: databaseId,
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
  final database = Databases(client);
  print("Running list collection API");
  try {
    final res = await database.listCollections(databaseId: databaseId);
    final collection = res.collections[0];
    print(collection.toMap());
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> deleteCollection() async {
  final database = Databases(client);
  print("Running delete collection API");
  try {
    await database.deleteCollection(
      databaseId: databaseId,
      collectionId: collectionId,
    );
    print("collection deleted: $collectionId");
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> addDoc() async {
  final database = Databases(client);
  print('Running Add Document API');
  try {
    final res = await database.createDocument(
      databaseId: databaseId,
      documentId: ID.unique(),
      collectionId: collectionId,
      data: {
        'name': 'Spider Man',
        'release_year': 1920,
      },
      permissions: [
        Permission.read(Role.any()),
        Permission.update(Role.any()),
      ],
    );
    print(res.data);
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> listDoc() async {
  final database = Databases(client);
  print('Running List Document API');
  try {
    final response = await database.listDocuments(
      databaseId: databaseId,
      collectionId: collectionId,
    );
    print(response.toMap());
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> deleteDatabase() async {
  final databases = Databases(client);
  print('Running Delete Database API');
  try {
    await databases.delete(databaseId: databaseId);
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> createBucket() async {
  final storage = Storage(client);
  print("Running create bucket API");
  try {
    final bucket = await storage.createBucket(
      bucketId: ID.unique(),
      name: 'my awesome bucket',
      fileSecurity: true,
    );
    bucketId = bucket.$id;
    print("Bucket created: $bucketId");
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> listBucket() async {
  final storage = Storage(client);
  print("Running list buckets API");
  try {
    final bucketList = await storage.listBuckets();
    print("Buckets: " + bucketList.buckets[0].toMap().toString());
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> uploadFile() async {
  final storage = Storage(client);
  print('Running Upload File API');
  final file = InputFile(path: './nature.jpg', filename: 'nature.jpg');
  try {
    final response = await storage.createFile(
      bucketId: bucketId,
      fileId: ID.unique(),
      file: file,
      permissions: [
        Permission.read(Role.any()),
        Permission.update(Role.any()),
      ],
    );
    fileId = response.$id;
    print("File uploaded: " + response.toMap().toString());
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> deleteFile() async {
  final storage = Storage(client);
  print('Running Delete File API');
  try {
    await storage.deleteFile(
      bucketId: bucketId,
      fileId: fileId,
    );
    print("File deleted: $fileId");
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> deleteBucket() async {
  final storage = Storage(client);
  print("Running Delete bucket API");
  try {
    await storage.deleteBucket(bucketId: bucketId);
    print("Bucket deleted: $bucketId ");
  } on AppwriteException catch (e) {
    print(e.message);
  }
}

Future<void> createUser(email, password, name) async {
  final users = Users(client);
  print('Running Create User API');
  try {
    final response = await users.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );
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
        functionId: ID.unique(),
        name: 'test function',
        execute: [],
        runtime: 'php-8.0');
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
