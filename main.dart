// The legacy Databases service (databases/collections/attributes/documents) is
// deprecated in favour of TablesDB since Appwrite 1.8. It is still demonstrated
// below because existing projects keep using it, so the deprecation notices
// those calls raise are silenced for this file.
// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/enums.dart' as enums;

// Config
// Either export the environment variables below or replace the fallback values
// with the endpoint, project ID and API key from your Appwrite Console.
final Client client = Client()
    .setEndpoint(Platform.environment['APPWRITE_ENDPOINT'] ?? 'YOUR_ENDPOINT')
    .setProject(
        Platform.environment['APPWRITE_PROJECT_ID'] ?? 'YOUR_PROJECT_ID')
    .setKey(Platform.environment['APPWRITE_API_KEY'] ?? 'YOUR_API_KEY')
    // .setJWT('jwt') // Authenticate as a user instead of using an API key.
    //                // Create a JWT with `users.createJWT()`, the replacement
    //                // for the removed `account.createJWT()`.
    .setSelfSigned(status: true); // Do not use this in production

final Databases databases = Databases(client);
final TablesDB tablesDB = TablesDB(client);
final Storage storage = Storage(client);
final Users users = Users(client);
final Teams teams = Teams(client);
final Functions functions = Functions(client);
final Account account = Account(client);

late String databaseId;
late String collectionId;
late String documentId;
late String bucketId;
late String fileId;
late String userId;
late String teamId;
late String membershipId;
late String functionId;
late String variableId;
late String tablesDatabaseId;
late String tableId;
late String rowId;
late String transactionId;

// Databases API Definitions (deprecated, use TablesDB for new projects)

Future<void> createDatabase() async {
  print('Running Create Database API');

  final response = await databases.create(
    databaseId: ID.unique(),
    name: 'Default',
  );
  databaseId = response.$id;

  print(response.toMap());
}

Future<void> listDatabases() async {
  print('Running List Databases API');

  final response = await databases.list();

  print(response.toMap());
}

Future<void> getDatabase() async {
  print('Running Get Database API');

  final response = await databases.get(databaseId: databaseId);

  print(response.toMap());
}

Future<void> updateDatabase() async {
  print('Running Update Database API');

  final response = await databases.update(
    databaseId: databaseId,
    name: 'Updated Database',
  );

  print(response.toMap());
}

Future<void> deleteDatabase() async {
  print('Running Delete Database API');

  await databases.delete(databaseId: databaseId);

  print('Database deleted: $databaseId');
}

Future<void> createCollection() async {
  print('Running Create Collection API');

  final response = await databases.createCollection(
    databaseId: databaseId,
    collectionId: ID.unique(),
    name: 'Collection',
    permissions: [
      Permission.read(Role.any()),
      Permission.create(Role.users()),
      Permission.update(Role.users()),
      Permission.delete(Role.users()),
    ],
  );
  collectionId = response.$id;

  print(response.toMap());

  final nameAttribute = await databases.createStringAttribute(
    databaseId: databaseId,
    collectionId: collectionId,
    key: 'name',
    size: 255,
    xrequired: false,
    xdefault: 'Empty Name',
    array: false,
  );
  print(nameAttribute.toMap());

  final yearAttribute = await databases.createIntegerAttribute(
    databaseId: databaseId,
    collectionId: collectionId,
    key: 'release_year',
    xrequired: false,
    min: 0,
    max: 5000,
    xdefault: 1970,
    array: false,
  );
  print(yearAttribute.toMap());

  print('Waiting a little to ensure attributes are created ...');
  await Future.delayed(const Duration(seconds: 2));

  final yearIndex = await databases.createIndex(
    databaseId: databaseId,
    collectionId: collectionId,
    key: 'key_release_year_asc',
    type: enums.DatabasesIndexType.key,
    attributes: ['release_year'],
    orders: [enums.OrderBy.asc],
  );
  print(yearIndex.toMap());

  print('Waiting a little to ensure index is created ...');
  await Future.delayed(const Duration(seconds: 2));
}

Future<void> listCollections() async {
  print('Running List Collections API');

  final response = await databases.listCollections(databaseId: databaseId);

  print(response.toMap());
}

Future<void> getCollection() async {
  print('Running Get Collection API');

  final response = await databases.getCollection(
    databaseId: databaseId,
    collectionId: collectionId,
  );

  print(response.toMap());
}

Future<void> updateCollection() async {
  print('Running Update Collection API');

  final response = await databases.updateCollection(
    databaseId: databaseId,
    collectionId: collectionId,
    name: 'Updated Collection',
  );

  print(response.toMap());
}

Future<void> deleteCollection() async {
  print('Running Delete Collection API');

  await databases.deleteCollection(
    databaseId: databaseId,
    collectionId: collectionId,
  );

  print('Collection deleted: $collectionId');
}

Future<void> listAttributes() async {
  print('Running List Attributes API');

  final response = await databases.listAttributes(
    databaseId: databaseId,
    collectionId: collectionId,
  );

  print(response.toMap());
}

Future<void> listIndexes() async {
  print('Running List Indexes API');

  final response = await databases.listIndexes(
    databaseId: databaseId,
    collectionId: collectionId,
  );

  print(response.toMap());
}

Future<void> createDocument() async {
  print('Running Add Document API');

  final response = await databases.createDocument(
    databaseId: databaseId,
    collectionId: collectionId,
    documentId: ID.unique(),
    data: {
      'name': 'Spider Man',
      'release_year': 1920,
    },
    permissions: [
      Permission.read(Role.any()),
      Permission.update(Role.users()),
      Permission.delete(Role.users()),
    ],
  );
  documentId = response.$id;

  print(response.toMap());
}

Future<void> listDocuments() async {
  print('Running List Documents API');

  final response = await databases.listDocuments(
    databaseId: databaseId,
    collectionId: collectionId,
    queries: [
      Query.equal('release_year', 1920),
    ],
  );

  print(response.toMap());
}

Future<void> getDocument() async {
  print('Running Get Document API');

  final response = await databases.getDocument(
    databaseId: databaseId,
    collectionId: collectionId,
    documentId: documentId,
  );

  print(response.toMap());
}

Future<void> updateDocument() async {
  print('Running Update Document API');

  final response = await databases.updateDocument(
    databaseId: databaseId,
    collectionId: collectionId,
    documentId: documentId,
    data: {
      'release_year': 2005,
    },
  );

  print(response.toMap());
}

Future<void> deleteDocument() async {
  print('Running Delete Document API');

  await databases.deleteDocument(
    databaseId: databaseId,
    collectionId: collectionId,
    documentId: documentId,
  );

  print('Document deleted: $documentId');
}

// TablesDB API Definitions

Future<void> createTablesDatabase() async {
  print('Running TablesDB Create Database API');

  final response = await tablesDB.create(
    databaseId: ID.unique(),
    name: 'Tables Database',
  );
  tablesDatabaseId = response.$id;

  print(response.toMap());
}

Future<void> listTablesDatabases() async {
  print('Running TablesDB List Databases API');

  final response = await tablesDB.list();

  print(response.toMap());
}

Future<void> getTablesDatabase() async {
  print('Running TablesDB Get Database API');

  final response = await tablesDB.get(databaseId: tablesDatabaseId);

  print(response.toMap());
}

Future<void> updateTablesDatabase() async {
  print('Running TablesDB Update Database API');

  final response = await tablesDB.update(
    databaseId: tablesDatabaseId,
    name: 'Updated Tables Database',
  );

  print(response.toMap());
}

Future<void> deleteTablesDatabase() async {
  print('Running TablesDB Delete Database API');

  await tablesDB.delete(databaseId: tablesDatabaseId);

  print('Database deleted: $tablesDatabaseId');
}

Future<void> createTable() async {
  print('Running TablesDB Create Table API');

  final response = await tablesDB.createTable(
    databaseId: tablesDatabaseId,
    tableId: ID.unique(),
    name: 'Movies',
    permissions: [
      Permission.read(Role.any()),
      Permission.create(Role.users()),
      Permission.update(Role.users()),
      Permission.delete(Role.users()),
    ],
  );
  tableId = response.$id;

  print(response.toMap());
}

Future<void> listTables() async {
  print('Running TablesDB List Tables API');

  final response = await tablesDB.listTables(databaseId: tablesDatabaseId);

  print(response.toMap());
}

Future<void> getTable() async {
  print('Running TablesDB Get Table API');

  final response = await tablesDB.getTable(
    databaseId: tablesDatabaseId,
    tableId: tableId,
  );

  print(response.toMap());
}

Future<void> updateTable() async {
  print('Running TablesDB Update Table API');

  final response = await tablesDB.updateTable(
    databaseId: tablesDatabaseId,
    tableId: tableId,
    name: 'Updated Movies',
  );

  print(response.toMap());
}

Future<void> deleteTable() async {
  print('Running TablesDB Delete Table API');

  await tablesDB.deleteTable(
    databaseId: tablesDatabaseId,
    tableId: tableId,
  );

  print('Table deleted: $tableId');
}

Future<void> createColumns() async {
  print('Running TablesDB Create Columns API');

  final textColumn = await tablesDB.createTextColumn(
    databaseId: tablesDatabaseId,
    tableId: tableId,
    key: 'title',
    xrequired: true,
  );
  print(textColumn.toMap());

  final integerColumn = await tablesDB.createIntegerColumn(
    databaseId: tablesDatabaseId,
    tableId: tableId,
    key: 'year',
    xrequired: false,
    min: 1888,
    max: 2100,
  );
  print(integerColumn.toMap());

  final floatColumn = await tablesDB.createFloatColumn(
    databaseId: tablesDatabaseId,
    tableId: tableId,
    key: 'rating',
    xrequired: false,
    min: 0,
    max: 10,
  );
  print(floatColumn.toMap());

  final booleanColumn = await tablesDB.createBooleanColumn(
    databaseId: tablesDatabaseId,
    tableId: tableId,
    key: 'is_released',
    xrequired: false,
    xdefault: true,
  );
  print(booleanColumn.toMap());

  print('Waiting a little to ensure columns are created ...');
  await Future.delayed(const Duration(seconds: 2));
}

Future<void> listColumns() async {
  print('Running TablesDB List Columns API');

  final response = await tablesDB.listColumns(
    databaseId: tablesDatabaseId,
    tableId: tableId,
  );

  print(response.toMap());
}

Future<void> getColumn() async {
  print('Running TablesDB Get Column API');

  final response = await tablesDB.getColumn(
    databaseId: tablesDatabaseId,
    tableId: tableId,
    key: 'title',
  );

  print(response.toMap());
}

Future<void> deleteColumn() async {
  print('Running TablesDB Delete Column API');

  await tablesDB.deleteColumn(
    databaseId: tablesDatabaseId,
    tableId: tableId,
    key: 'rating',
  );

  print('Column deleted: rating');
}

Future<void> createTableIndex() async {
  print('Running TablesDB Create Index API');

  final response = await tablesDB.createIndex(
    databaseId: tablesDatabaseId,
    tableId: tableId,
    key: 'idx_year',
    type: enums.TablesDBIndexType.key,
    columns: ['year'],
  );
  print(response.toMap());

  print('Waiting a little to ensure index is created ...');
  await Future.delayed(const Duration(seconds: 2));
}

Future<void> listTableIndexes() async {
  print('Running TablesDB List Indexes API');

  final response = await tablesDB.listIndexes(
    databaseId: tablesDatabaseId,
    tableId: tableId,
  );

  print(response.toMap());
}

Future<void> deleteTableIndex() async {
  print('Running TablesDB Delete Index API');

  await tablesDB.deleteIndex(
    databaseId: tablesDatabaseId,
    tableId: tableId,
    key: 'idx_year',
  );

  print('Index deleted: idx_year');
}

Future<void> createRow() async {
  print('Running TablesDB Create Row API');

  final response = await tablesDB.createRow(
    databaseId: tablesDatabaseId,
    tableId: tableId,
    rowId: ID.unique(),
    data: {
      'title': 'Inception',
      'year': 2010,
      'rating': 8.8,
      'is_released': true,
    },
    permissions: [
      Permission.read(Role.any()),
      Permission.update(Role.users()),
      Permission.delete(Role.users()),
    ],
  );
  rowId = response.$id;

  print(response.toMap());
}

Future<void> listRows() async {
  print('Running TablesDB List Rows API');

  final response = await tablesDB.listRows(
    databaseId: tablesDatabaseId,
    tableId: tableId,
    queries: [
      Query.equal('year', 2010),
    ],
  );

  print(response.toMap());
}

Future<void> getRow() async {
  print('Running TablesDB Get Row API');

  final response = await tablesDB.getRow(
    databaseId: tablesDatabaseId,
    tableId: tableId,
    rowId: rowId,
  );

  print(response.toMap());
}

Future<void> updateRow() async {
  print('Running TablesDB Update Row API');

  final response = await tablesDB.updateRow(
    databaseId: tablesDatabaseId,
    tableId: tableId,
    rowId: rowId,
    data: {
      'rating': 9.0,
    },
  );

  print(response.toMap());
}

Future<void> deleteRow() async {
  print('Running TablesDB Delete Row API');

  await tablesDB.deleteRow(
    databaseId: tablesDatabaseId,
    tableId: tableId,
    rowId: rowId,
  );

  print('Row deleted: $rowId');
}

// Transactions API Definitions

Future<void> createTransaction() async {
  print('Running Create Transaction API');

  final response = await tablesDB.createTransaction(ttl: 60);
  transactionId = response.$id;

  print(response.toMap());
}

Future<void> getTransaction() async {
  print('Running Get Transaction API');

  final response = await tablesDB.getTransaction(transactionId: transactionId);

  print(response.toMap());
}

Future<void> listTransactions() async {
  print('Running List Transactions API');

  final response = await tablesDB.listTransactions();

  print(response.toMap());
}

Future<void> stageCreateRow() async {
  print('Running Stage Create Row in Transaction');

  final response = await tablesDB.createRow(
    databaseId: tablesDatabaseId,
    tableId: tableId,
    rowId: ID.unique(),
    data: {
      'title': 'The Matrix',
      'year': 1999,
      'rating': 8.7,
      'is_released': true,
    },
    permissions: [
      Permission.read(Role.any()),
      Permission.update(Role.users()),
      Permission.delete(Role.users()),
    ],
    transactionId: transactionId,
  );
  rowId = response.$id;

  print(response.toMap());
}

Future<void> stageUpdateRow() async {
  print('Running Stage Update Row in Transaction');

  final response = await tablesDB.updateRow(
    databaseId: tablesDatabaseId,
    tableId: tableId,
    rowId: rowId,
    data: {
      'rating': 9.5,
    },
    transactionId: transactionId,
  );

  print(response.toMap());
}

Future<void> stageOperations() async {
  print('Running Create Operations (batch staging) API');

  final response = await tablesDB.createOperations(
    transactionId: transactionId,
    operations: [
      {
        'action': 'create',
        'databaseId': tablesDatabaseId,
        'tableId': tableId,
        'rowId': ID.unique(),
        'data': {
          'title': 'Interstellar',
          'year': 2014,
          'rating': 8.6,
          'is_released': true,
        },
      },
      {
        'action': 'create',
        'databaseId': tablesDatabaseId,
        'tableId': tableId,
        'rowId': ID.unique(),
        'data': {
          'title': 'The Dark Knight',
          'year': 2008,
          'rating': 9.0,
          'is_released': true,
        },
      },
    ],
  );

  print(response.toMap());
}

Future<void> commitTransaction() async {
  print('Running Commit Transaction API');

  final response = await tablesDB.updateTransaction(
    transactionId: transactionId,
    commit: true,
  );

  print(response.toMap());
}

Future<void> rollbackTransaction() async {
  print('Running Rollback Transaction Demo');

  final transaction = await tablesDB.createTransaction(ttl: 60);
  print('Created transaction for rollback demo: ${transaction.$id}');

  await tablesDB.createRow(
    databaseId: tablesDatabaseId,
    tableId: tableId,
    rowId: ID.unique(),
    data: {
      'title': 'To Be Rolled Back',
      'year': 2025,
      'rating': 1.0,
      'is_released': false,
    },
    transactionId: transaction.$id,
  );
  print('Staged a row creation inside rollback transaction');

  // Roll back — the staged row will NOT be persisted. A "failed" status is
  // expected here, it means the rollback succeeded.
  final response = await tablesDB.updateTransaction(
    transactionId: transaction.$id,
    rollback: true,
  );

  print(response.toMap());
}

Future<void> deleteTransaction() async {
  print('Running Delete Transaction API');

  // Create a throwaway transaction to demonstrate delete
  final transaction = await tablesDB.createTransaction(ttl: 60);
  print('Created transaction to delete: ${transaction.$id}');

  await tablesDB.deleteTransaction(transactionId: transaction.$id);

  print('Transaction deleted: ${transaction.$id}');
}

// Storage API Definitions

Future<void> createBucket() async {
  print('Running Create Bucket API');

  final response = await storage.createBucket(
    bucketId: ID.unique(),
    name: 'All Files',
    permissions: [
      Permission.read(Role.any()),
      Permission.create(Role.users()),
      Permission.update(Role.users()),
      Permission.delete(Role.users()),
    ],
  );
  bucketId = response.$id;

  print(response.toMap());
}

Future<void> listBuckets() async {
  print('Running List Buckets API');

  final response = await storage.listBuckets();

  print(response.toMap());
}

Future<void> getBucket() async {
  print('Running Get Bucket API');

  final response = await storage.getBucket(bucketId: bucketId);

  print(response.toMap());
}

Future<void> updateBucket() async {
  print('Running Update Bucket API');

  final response = await storage.updateBucket(
    bucketId: bucketId,
    name: 'Updated Bucket',
  );

  print(response.toMap());
}

Future<void> deleteBucket() async {
  print('Running Delete Bucket API');

  await storage.deleteBucket(bucketId: bucketId);

  print('Bucket deleted: $bucketId');
}

Future<void> uploadFile() async {
  print('Running Upload File API');

  final response = await storage.createFile(
    bucketId: bucketId,
    fileId: ID.unique(),
    file: InputFile.fromPath(path: './nature.jpg', filename: 'nature.jpg'),
    permissions: [
      Permission.read(Role.any()),
      Permission.update(Role.users()),
      Permission.delete(Role.users()),
    ],
  );
  fileId = response.$id;

  print(response.toMap());
}

Future<void> listFiles() async {
  print('Running List Files API');

  final response = await storage.listFiles(bucketId: bucketId);

  print(response.toMap());
}

Future<void> getFile() async {
  print('Running Get File API');

  final response = await storage.getFile(
    bucketId: bucketId,
    fileId: fileId,
  );

  print(response.toMap());
}

Future<void> getFileDownload() async {
  print('Running Get File Download API');

  final response = await storage.getFileDownload(
    bucketId: bucketId,
    fileId: fileId,
  );

  print('Downloaded file: ${response.length} bytes');
}

Future<void> getFilePreview() async {
  print('Running Get File Preview API');

  final response = await storage.getFilePreview(
    bucketId: bucketId,
    fileId: fileId,
    width: 200,
    height: 200,
  );

  print('Preview file: ${response.length} bytes');
}

Future<void> updateFile() async {
  print('Running Update File API');

  final response = await storage.updateFile(
    bucketId: bucketId,
    fileId: fileId,
    name: 'abc',
    permissions: [
      Permission.read(Role.any()),
      Permission.update(Role.any()),
      Permission.delete(Role.any()),
    ],
  );

  print(response.toMap());
}

Future<void> deleteFile() async {
  print('Running Delete File API');

  await storage.deleteFile(
    bucketId: bucketId,
    fileId: fileId,
  );

  print('File deleted: $fileId');
}

// Users API Definitions

Future<void> createUser() async {
  print('Running Create User API');

  final response = await users.create(
    userId: ID.unique(),
    email: '${DateTime.now().millisecondsSinceEpoch}@example.com',
    password: 'user@123',
    name: 'Some User',
  );
  userId = response.$id;

  print(response.toMap());
}

Future<void> listUsers() async {
  print('Running List Users API');

  final response = await users.list();

  print(response.toMap());
}

Future<void> getUser() async {
  print('Running Get User API');

  final response = await users.get(userId: userId);

  print(response.toMap());
}

Future<void> updateUserName() async {
  print('Running Update User Name API');

  final response = await users.updateName(
    userId: userId,
    name: 'Updated Name',
  );

  print(response.toMap());
}

Future<void> getUserPrefs() async {
  print('Running Get User Preferences API');

  final response = await users.getPrefs(userId: userId);

  print(response.toMap());
}

Future<void> updateUserPrefs() async {
  print('Running Update User Preferences API');

  final response = await users.updatePrefs(
    userId: userId,
    prefs: {
      'theme': 'dark',
      'language': 'en',
    },
  );

  print(response.toMap());
}

Future<void> deleteUser() async {
  print('Running Delete User API');

  await users.delete(userId: userId);

  print('User deleted: $userId');
}

/// Only works when the client is authenticated with a JWT or a session,
/// an API key is not enough.
Future<void> getAccount() async {
  print('Running Get Account API');

  final response = await account.get();

  print(response.toMap());
}

// Teams API Definitions

Future<void> createTeam() async {
  print('Running Create Team API');

  final response = await teams.create(
    teamId: ID.unique(),
    name: 'Awesome Team',
    roles: ['owner'],
  );
  teamId = response.$id;

  print(response.toMap());
}

Future<void> listTeams() async {
  print('Running List Teams API');

  final response = await teams.list();

  print(response.toMap());
}

Future<void> getTeam() async {
  print('Running Get Team API');

  final response = await teams.get(teamId: teamId);

  print(response.toMap());
}

Future<void> deleteTeam() async {
  print('Running Delete Team API');

  await teams.delete(teamId: teamId);

  print('Team deleted: $teamId');
}

Future<void> createTeamMembership() async {
  print('Running Create Team Membership API');

  final response = await teams.createMembership(
    teamId: teamId,
    roles: ['owner'],
    userId: userId,
    url: 'http://localhost',
  );
  membershipId = response.$id;

  print(response.toMap());
}

Future<void> listTeamMemberships() async {
  print('Running List Team Memberships API');

  final response = await teams.listMemberships(teamId: teamId);

  print(response.toMap());
}

Future<void> deleteTeamMembership() async {
  print('Running Delete Team Membership API');

  await teams.deleteMembership(
    teamId: teamId,
    membershipId: membershipId,
  );

  print('Membership deleted: $membershipId');
}

// Functions API Definitions

Future<void> createFunction() async {
  print('Running Create Function API');

  final response = await functions.create(
    functionId: ID.unique(),
    name: 'Dart Hello World',
    runtime: enums.Runtime.dart38,
    execute: [Role.any()],
    entrypoint: 'lib/main.dart',
    timeout: 15,
    enabled: true,
    logging: true,
  );
  functionId = response.$id;

  print(response.toMap());
}

Future<void> listFunctions() async {
  print('Running List Functions API');

  final response = await functions.list();

  print(response.toMap());
}

Future<void> getFunction() async {
  print('Running Get Function API');

  final response = await functions.get(functionId: functionId);

  print(response.toMap());
}

Future<void> updateFunction() async {
  print('Running Update Function API');

  final response = await functions.update(
    functionId: functionId,
    name: 'Updated Dart Hello World',
    runtime: enums.Runtime.dart38,
    execute: [Role.any()],
    entrypoint: 'lib/main.dart',
    timeout: 30,
    enabled: true,
    logging: true,
  );

  print(response.toMap());
}

Future<void> listDeployments() async {
  print('Running List Deployments API');

  final response = await functions.listDeployments(functionId: functionId);

  print(response.toMap());
}

Future<void> listExecutions() async {
  print('Running List Executions API');

  final response = await functions.listExecutions(functionId: functionId);

  print(response.toMap());
}

Future<void> createVariable() async {
  print('Running Create Variable API');

  final response = await functions.createVariable(
    functionId: functionId,
    variableId: ID.unique(),
    key: 'MY_VAR',
    value: 'hello123',
  );
  variableId = response.$id;

  print(response.toMap());
}

Future<void> listVariables() async {
  print('Running List Variables API');

  final response = await functions.listVariables(functionId: functionId);

  print(response.toMap());
}

Future<void> getVariable() async {
  print('Running Get Variable API');

  final response = await functions.getVariable(
    functionId: functionId,
    variableId: variableId,
  );

  print(response.toMap());
}

Future<void> updateVariable() async {
  print('Running Update Variable API');

  final response = await functions.updateVariable(
    functionId: functionId,
    variableId: variableId,
    key: 'MY_VAR',
    value: 'updated_value',
  );

  print(response.toMap());
}

Future<void> deleteVariable() async {
  print('Running Delete Variable API');

  await functions.deleteVariable(
    functionId: functionId,
    variableId: variableId,
  );

  print('Variable deleted: $variableId');
}

Future<void> deleteFunction() async {
  print('Running Delete Function API');

  await functions.delete(functionId: functionId);

  print('Function deleted: $functionId');
}

Future<void> runAllTasks() async {
  await createDatabase();
  await listDatabases();
  await getDatabase();
  await updateDatabase();

  await createCollection();
  await listCollections();
  await getCollection();
  await updateCollection();
  await listAttributes();
  await listIndexes();

  await createDocument();
  await listDocuments();
  await getDocument();
  await updateDocument();

  await deleteDocument();
  await deleteCollection();
  await deleteDatabase();

  await createTablesDatabase();
  await listTablesDatabases();
  await getTablesDatabase();
  await updateTablesDatabase();

  await createTable();
  await listTables();
  await getTable();
  await updateTable();

  await createColumns();
  await listColumns();
  await getColumn();

  await createTableIndex();
  await listTableIndexes();

  await createRow();
  await listRows();
  await getRow();
  await updateRow();

  // Transactions API
  await createTransaction();
  await getTransaction();
  await listTransactions();
  await stageCreateRow();
  await stageUpdateRow();
  await stageOperations();
  await commitTransaction();
  await rollbackTransaction();
  await deleteTransaction();

  await deleteRow();
  await deleteTableIndex();
  await deleteColumn();
  await deleteTable();
  await deleteTablesDatabase();

  await createBucket();
  await listBuckets();
  await getBucket();
  await updateBucket();

  await uploadFile();
  await listFiles();
  await getFile();
  await getFileDownload();
  await getFilePreview();
  await updateFile();

  await deleteFile();
  await deleteBucket();

  // await getAccount(); // works only with a JWT or a session
  await createUser();
  await listUsers();
  await getUser();
  await updateUserName();
  await getUserPrefs();
  await updateUserPrefs();

  await createTeam();
  await listTeams();
  await getTeam();
  await createTeamMembership();
  await listTeamMemberships();
  await deleteTeamMembership();
  await deleteTeam();

  await deleteUser();

  await createFunction();
  await listFunctions();
  await getFunction();
  await updateFunction();
  await createVariable();
  await listVariables();
  await getVariable();
  await updateVariable();
  await deleteVariable();
  await listDeployments();
  await listExecutions();
  await deleteFunction();
}

Future<void> main() async {
  try {
    await runAllTasks();
    print('Successfully ran playground!');
  } on AppwriteException catch (e) {
    print('Playground failed: ${e.message}');
    exitCode = 1;
  }
}
