# MyVA - Chatbot Builder

A no-code platform for building conversational chatbots using Flutter/flutterflow for the frontend, Firebase for the database, and Python with Gemini API for AI responses.

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
- **Flutter/flutterflow**: Web framework
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
   have basic firebase sdk just in case on yout laptop

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
   -in case of new api key needed 

6. **Run the backend server**:
   ```bash
   python app.py
   ```



## Usage

1. **Sign up** for a new account or **login** with existing credentials
2. **Create a bot** using the Generate Bot screen
3. **Configure** your bot with name, description, and purpose
4. **Chat** with your created bot in real-time
5. **View history** of all conversations
6. **Explore** pre-built templates for inspiration



## API Endpoints

### Backend Endpoints

- `POST /chat` - Send message to Gemini API
- `GET /health` - Health check endpoint


