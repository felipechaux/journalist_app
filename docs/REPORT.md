# Project Report: Journalist App

### 1. Introduction
When I started this project, I was really excited. I already knew Flutter and felt comfortable with it, but building a dedicated app for journalists with clean architecture and real-world tools seemed like a fun challenge. My goal was to build something robust, clean, and easy to scale.

### 2. Learning Journey
Even though I was already familiar with Flutter, this project taught me a lot about project setup and backend integration. The coolest part for me was being able to create a database schema so easily using the Firebase CLI. It felt like magic setting up the backend structure in just a few commands instead of spending hours configuring a custom server. I relied mostly on the official Firebase documentation and Flutter guides to get everything working smoothly. Additionally, I really wanted to ensure I was following the best practices of Flutter, so I worked with LLMs and utilized the [dash_skills](https://github.com/kevmoo/dash_skills) repository to guide my architectural choices and code quality throughout the development process.

### 3. Challenges Faced
One of the main challenges was making sure the app worked smoothly offline and online. Handling the local database alongside the remote Firebase data required careful state management. Also, correctly formatting the article texts so they look great was tricky at first. I tackled this by integrating Markdown support, which made rendering the text much simpler and cleaner.

### 4. Reflection and Future Directions
Overall, working on this app was a fantastic experience. It really helped me solidify my understanding of Clean Architecture and Bloc/Cubit state management in Flutter. For future directions, I’d love to add features like a personalized dark mode, push notifications for breaking news, and maybe a collaborative editing feature so multiple journalists can work on a draft together.

### 5. Proof of the project
*(Insert screenshots or GIFs of the app here)*
- Splash screen with shine animation
- Daily News Feed (Online/Offline)
- Article Detail View with Markdown formatting
- Publish Article Screen
- Drawer / Settings for Language Switch

### 6. Overdelivery

**1. New Features Implemented:**
- **Shared Article:** I added native sharing functionality so users can easily share article titles and links via their phone's native share sheet.
- **Language Support (i18n):** Implemented full English and Spanish localization using `flutter_localizations` and ARB files. Users can toggle the language seamlessly from the app bar.
- **Feedback for Offline Sync:** Built visual feedback for users so they know when they are reading offline saved articles or when the app is actively syncing data from the cloud.
- **Markdown Formatting:** Added a rich text renderer using Markdown so that the articles are beautifully formatted with bold text, lists, and proper headers.
- **Premium Aesthetics:** Added a visually appealing splash screen with a dynamic shine animation and integrated haptic feedback native to the OS. Also created custom transparent app launcher icons for both Android and iOS.
- **Unit Testing:** Implemented core tests for domain usecases (`GetArticleUseCase`, `SaveArticleUseCase`) utilizing the `mocktail` package for mocking dependencies, solidifying app stability.

**2. Prototypes Created:**
- Early UI iterations for the Splash Screen animation to fine-tune the haptic feedback timing.
- Used `l10n.yaml` to dynamically generate state-managed translation delegates instead of relying on outdated synthetic generation.

**3. How Can You Improve This:**
- **Dark Mode:** Adding a system-aware dark mode would make the reading experience much better at night.
- **Cloud Syncing Settings:** We could sync user preferences (like their chosen language and saved articles) to their Firebase account so they can log in on multiple devices.
- **Push Notifications:** Alerting users to breaking news or successful article publications using Firebase Cloud Messaging.

### 7. Extra Sections
Thank you for reading my report! Building this app was a great journey.
