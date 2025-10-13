from flask import Flask, request, jsonify

app = Flask(__name__)

# In-memory storage for items
items = []

@app.route('/items', methods=['GET'])
def get_items():
    return jsonify(items)

@app.route('/additems', methods=['POST'])
def create_item():
    data = request.get_json()
    if not data or 'name' not in data:
        return jsonify({'error': 'Name is required'}), 400
    
    item = {
        'id': len(items) + 1,
        'name': data['name'],
        'description': data.get('description', '')
    }
    items.append(item)
    return jsonify(item), 201

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
