from flask import Flask, request, jsonify
from flask_cors import CORS
import google.generativeai as genai
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
CORS(app)

# to Configure Gemini API
genai.configure(api_key=os.getenv('GEMINI_API_KEY', 'your-gemini-api-key'))

@app.route('/chat', methods=['POST'])
def chat():
    try:
        data = request.json
        message = data.get('message', '')
        
        if not message:
            return jsonify({'error': 'Message is required'}), 400
        
        # Try to use Gemini API
        try:
            # Initializes Gemini model
            model = genai.GenerativeModel('gemini-2.5-flash')
            
            # Generates response
            response = model.generate_content(message)
            
            # Extracts text from response
            response_text = ""
            if hasattr(response, 'text'):
                response_text = response.text
            elif hasattr(response, 'candidates') and response.candidates:
                response_text = response.candidates[0].content.parts[0].text
            else:
                response_text = str(response)
            
            return jsonify({
                'response': response_text,
                'status': 'success'
            })
        except Exception as gemini_error:
            print(f"Gemini API Error: {gemini_error}")
            # Check if it's a quota error
            if "quota" in str(gemini_error).lower() or "404" in str(gemini_error):
                # Provide a helpful response about API limits(backup)
                return jsonify({
                    'response': f"I understand you said: '{message}'. I'm currently experiencing API limitations with the Gemini service. To get full AI responses, please check your Gemini API key at https://aistudio.google.com/app/apikey and ensure it has sufficient quota. In the meantime, I can help with basic responses. What would you like to know about chatbot building or the MyVA platform?",
                    'status': 'success'
                })
            else:
                # For other errors, providing a fallback response
                return jsonify({
                    'response': f"I received your message: '{message}'. I'm having trouble connecting to my AI services right now. Please try again in a moment or check if the backend server is running properly.",
                    'status': 'success'
                })
    
    except Exception as e:
        return jsonify({
            'error': str(e),
            'status': 'error'
        }), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'healthy'})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8000)
