# Overview

The best music trivia app for mobile!

# Local Environment Setup

## Prerequisites

- Postgres 17.0
- Ruby 3.3.34
- Node 22.4.1
- Yarn 1.22.22
- Mobile Emulators for React Native - [Local Setup Instructions](https://reactnative.dev/docs/set-up-your-environment)
  - XCode / IOS Emulator
  - Android Studio / Android Emulator

## Server

- In a new terminal
  - `cp .env.sample .env` and add your OPENAI API key
  - `cd backend`
  - `bundle install`
  - `bin/rails s`

## Mobile

- In a new terminal
  - `cd mobile`
  - `yarn start`
- In a new terminal:
  - `yarn ios` (for iOS)
- In a new terminal:
  - `yarn android` (for Android)

## Sample Screenshots

Android:

![Screenshot_1747267275 Medium](https://github.com/user-attachments/assets/50489eff-e29f-40d4-bba3-6e030828e9c3)

![Screenshot_1747267279 Medium](https://github.com/user-attachments/assets/67ada444-8225-446e-a609-ab9a2a297c75)

![Screenshot_1747267287 Medium](https://github.com/user-attachments/assets/3c00ba65-81a3-4e99-aab3-5b291ebb850e)

![Screenshot_1747267292 Medium](https://github.com/user-attachments/assets/d14f0b0e-359f-4364-a26a-5bb78b886d86)

iOS:

![Simulator Screenshot - iPhone 16 Pro - 2025-05-14 at 20 28 45 Medium](https://github.com/user-attachments/assets/14018441-39ba-4175-96bf-d938f29b8c52)

![Simulator Screenshot - iPhone 16 Pro - 2025-05-14 at 20 28 51 Medium](https://github.com/user-attachments/assets/3fb27415-b349-4ef6-89f4-41a1d4268617)

![Simulator Screenshot - iPhone 16 Pro - 2025-05-14 at 20 29 08 Medium](https://github.com/user-attachments/assets/25a51275-d1c9-4ca7-8d87-91d8b0a3dfb3)

![Simulator Screenshot - iPhone 16 Pro - 2025-05-14 at 20 29 12 Medium](https://github.com/user-attachments/assets/931f19bd-e852-45b1-93fe-79d1346987cd)
