# MyVA - Chatbot Builder

A no-code platform for building conversational chatbots using Flutter for the frontend, Firebase for the database, and Python with Gemini API for AI responses.

## Features

- **Web-Only Application**: Optimized for browser usage
- **User Authentication**: Login and signup with Firebase Auth
- **Dashboard**: Manage and create chatbots
- **Bot Generation**: Create custom chatbots with specific purposes
- **Chat Interface**: Real-time conversation with created bots
- **History**: Track all chat conversations
- **Explore**: Discover pre-built bot templates

## Tech Stack

### Frontend
- **Flutter**: Web framework
- **Firebase**: Authentication and Firestore database
- **Provider**: State management

### Backend
- **Python**: Backend server
- **Flask**: Web framework
- **Google Gemini API**: AI responses
- **Flask-CORS**: Cross-origin resource sharing

## Setup Instructions

### Prerequisites
- Flutter SDK (web-enabled)
- Python 3.8+
- Firebase project

### Frontend Setup

1. **Clone and navigate to the project**:
   ```bash
   cd myva_app
   ```

2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**:
   - Create a Firebase project at https://console.firebase.google.com
   - Enable Authentication (Email/Password)
   - Create Firestore database
   - Download the Firebase configuration
   - Update `lib/firebase_options.dart` with your Firebase config

4. **Run the app**:
   ```bash
   flutter run -d chrome
   ```

### Backend Setup

1. **Navigate to backend directory**:
   ```bash
   cd backend
   ```

2. **Create virtual environment**:
   ```bash
   python -m venv venv
   ```

3. **Activate virtual environment**:
   - Windows: `venv\Scripts\activate`
   - macOS/Linux: `source venv/bin/activate`

4. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

5. **Set up environment variables**:
   ```bash
   cp .env.example .env
   ```
   - Edit `.env` and add your Gemini API key

6. **Run the backend server**:
   ```bash
   python app.py
   ```

## Configuration

### Firebase Configuration

Update `lib/firebase_options.dart` with your Firebase project details:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'your-api-key',
  appId: 'your-app-id',
  messagingSenderId: 'your-sender-id',
  projectId: 'your-project-id',
  authDomain: 'your-project-id.firebaseapp.com',
  storageBucket: 'your-project-id.appspot.com',
);
```

### Backend URL

Update the backend URL in `lib/screens/chat_screen.dart`:

```dart
final response = await http.post(
  Uri.parse('http://localhost:8000/chat'), // Update this URL
  headers: {'Content-Type': 'application/json'},
  body: '{"message": "$userMessage"}',
);
```

## Usage

1. **Sign up** for a new account or **login** with existing credentials
2. **Create a bot** using the Generate Bot screen
3. **Configure** your bot with name, description, and purpose
4. **Chat** with your created bot in real-time
5. **View history** of all conversations
6. **Explore** pre-built templates for inspiration

## Project Structure

```
myva_app/
├── lib/
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   ├── dashboard_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── explore_screen.dart
│   │   ├── history_screen.dart
│   │   ├── generate_bot_screen.dart
│   │   └── chat_screen.dart
│   ├── main.dart
│   └── firebase_options.dart
├── web/
│   └── index.html
├── backend/
│   ├── app.py
│   ├── requirements.txt
│   └── .env.example
└── pubspec.yaml
```

## API Endpoints

### Backend Endpoints

- `POST /chat` - Send message to Gemini API
- `GET /health` - Health check endpoint

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.
