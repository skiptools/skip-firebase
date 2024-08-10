## 0.2.3

Released 2024-08-09

  - Merge pull request #4 from boctor/main
  - Add batch writes, collection groups, hasPendingWrites and non async getDocument: * Add WriteBatch, used to perform multiple writes as a single atomic unit * Add Collection Group queries * Add hasPendingWrites on SnapshotMetadata * Add non-async version of getDocument on DocumentReference with a completion block

## 0.2.1

Released 2024-07-11


## 0.2.0

Released 2024-07-10

  - Merge pull request #2 from artamata/main
  - Added basing FirebaseAuth and FirebaseStoreage. For Auth, it includes signIn with email and password, create user with email and password, and ability to change your profile display name. Storage has the ability to get a StorageReference based on path and to get a downloadURL().

## 0.1.1

Released 2024-05-25

  - Add Timestamp properties and functions
  - Fix Timestamp Hashable
  - Re-enable tests
  - Add Timestamp
  - Bump firebase-bom version to 33.0.0; add more docs to README
  - ci: update workflow actions location
  - Update docs to mention sample Fireside app

## 0.1.0

Released 2024-02-05

  - Work-around test failures with multiple FirebaseApp instances

## 0.0.3

Released 2024-01-09

  - Add kotlin() unwrap functions to Firestore types
  - Add DocumentReference.delete() and FieldPath.documentId()
  - Move getDocuments to Query
  - Add addSnapshotListener
  - Add API for AggregateField and QuerySnapshot
  - Add Firebase.addSnapshotListener
  - Add Query API

## 0.0.2

Released 2024-01-05

  - Add docs
  - Add more Firestore API and tests
  - Update README.md

