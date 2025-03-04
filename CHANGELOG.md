## 0.7.2

Released 2025-03-04

  - Merge pull request #33 from jacobtober/add-reauthenticate-method
  - Add reauthenticate method to User class for Firebase Authentication
  - Update CI
  - Update copyright and license headers
  - Merge pull request #32 from skiptools/skip-bridge
  - Add support for SkipBridge

## 0.6.10

Released 2025-01-27

  - Update SkipFirebaseAuth.swift (#29)

## 0.6.9

Released 2025-01-25

  - Add auth user metadata (#28)

## 0.6.8

Released 2025-01-09

  - Add Firestore error codes (#26)
  - Change frequency of CI run

## 0.6.6

Released 2025-01-02

  - Merge pull request #25 from ky-is/firestore-filters
  - Update Filter to match Swift API
  - Add Query notIn and arrayContainsAny
  - Add Filter factory methods

## 0.6.5

Released 2024-12-22

  - Merge pull request #23 from boctor/add-http-callable-functions-support
  - Add support for calling HTTP callable functions

## 0.6.4

Released 2024-12-22

  - Merge pull request #24 from ky-is/add-auth-state-listener
  - Add auth addStateDidChangeListener/removeStateDidChangeListener

## 0.6.2

Released 2024-12-13

  - Merge pull request #20 from skiptools/doc-snapshot-listener
  - Add DocumentReference.addSnapshotListener API

## 0.6.1

Released 2024-12-12

  - Merge pull request #19 from ky-is/fix-storage-metadata
  - Fix optional metadata uploading with putFile
  - Add storage instance with custom URL string

## 0.5.3

Released 2024-10-29

  - Merge pull request #15 from Kevin-French/firestore-documentsnapshot-exists
  - Add exists property to DocumentSnapshot in Firestore

## 0.5.1

Released 2024-10-15

  - Merge pull request #12 from skiptools/firestore-getdata
  - Add async StorageReference.getData() function
  - Merge pull request #11 from boctor/main
  - Add API to delete storage files

## 0.3.1

Released 2024-08-26

  - Merge pull request #7 from rlindsey2/add-anonymous-signin
  - Add support for Firebase Auth anonymous sign-in
  - Update README.md

## 0.3.0

Released 2024-08-15

  - Merge pull request #5 from boctor/main
  - Add support for Firestore's FieldValue This is used for special values like server timestamp, incrementing a value and adding/removing from arrays

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

