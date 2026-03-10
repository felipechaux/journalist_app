# Firebase Firestore Backend
In this folder are all the [Firebase Firestore](https://firebase.google.com/docs/firestore) related files. 
You will use this folder to add the schema of the *Articles* you want to upload for the app and to add the rules that enforce this schema. 

## DB Schema

### `articles` Collection

Each document in the `articles` collection has the following schema:

| Field | Type | Description |
| :--- | :--- | :--- |
| `id` | Number | Unique identifier for the article |
| `author` | String | Name of the author |
| `title` | String | Title or headline of the article |
| `description` | String | A brief description or summary of the article |
| `url` | String | URL to the original article |
| `urlToImage` | String | URL to a related image (or a default image URL) |
| `publishedAt` | String | Date and time the article was published |
| `content` | String | The full content of the article |

**Example Document:**
```json
{
  "id": 1,
  "author": "John Doe",
  "title": "Breaking News: Flutter is Awesome!",
  "description": "A deep dive into cross-platform development.",
  "url": "https://example.com/flutter-awesome",
  "urlToImage": "https://example.com/images/flutter.png",
  "publishedAt": "2023-10-27T10:00:00Z",
  "content": "Flutter continues to dominate the cross-platform framework market..."
}
```

## Getting Started
Before starting to work on the backend, you must have a Firebase project with the [Firebase Firestore](https://firebase.google.com/docs/firestore), [Firebase Cloud Storage](https://firebase.google.com/docs/storage) and [Firebase Local Emulator Suite](https://firebase.google.com/docs/emulator-suite) technologies enabled.
To do this, create a project but enable only Firebase Cloud Storage, Firebase Firestore, and Firebase Local Emulator Suite technologies.


## Deploying the Project
In order to deploy the Firestore rules from this repository to the [Firebase console](https://firebase.google.com/)  of your project, follow these steps:

### 1. Install firebase CLI
```
npm install -g firebase-tools
```
### 2. Login to your account
```
firebase login
```

### 3. Add your project id to the .firebasesrc file 
This corresponds to the project Id of the firebase project you created in the Firebase web-app.
[Change project id](.firebaserc)

### 4. Initialize the project
```
firebase init
```

You should leave everything as it is, choose:
- emulators
- firestore
- cloud storage

### 5. Deploy to firebase
```
firebase deploy
```
This will deploy all the rules you write in `firestore.rules` to your Firebase Firestore project.
Be careful becasuse it will overwrite the existing firestore.rules file of your project.

## Running the project in a local emulator
To run the application locally, use the following command:

```firebase emulators:start```
