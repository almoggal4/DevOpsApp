from flask import Flask, render_template, request
import requests

app = Flask(__name__)

# Replace 'YOUR_API_KEY' with your actual OpenWeatherMap API key
API_KEY = "b91fbbf37cd14f27579fa3b86af2b7c8"
BASE_URL = "https://api.openweathermap.org/data/2.5/weather?"

@app.route('/', methods=['GET', 'POST'])
def index():
    weather_data = None

    if request.method == 'POST':
        city = request.form['city']
        weather_data = get_weather(city)

    return render_template('index.html', weather_data=weather_data)

def get_weather(city):
    params = {'q': city, 'appid': API_KEY}
    response = requests.get(BASE_URL, params=params)

    if response.status_code == 200:
        data = response.json()
        city = data['name']
        temperature_kelvin = int(data['main']['temp'])
        tempature_celsius_int = round(temperature_kelvin - 273.15)
        temperature_celsius = str(tempature_celsius_int)
        feels_like = str(round(int(data['main']['feels_like'] - 273.15)))
        minimum_temperature = str(round(int(data['main']['temp_min'] - 273.15)))
        maximum_temperature = str(round(int(data['main']['temp_max'] - 273.15)))
        humidity = data['main']['humidity'];
        wind = data['wind']
        wind_speed = wind['speed']
        description = data['weather'][0]['description']
        
        weather_info = {
            'city': city,
            'temperature': temperature_celsius,
            'feels_like': feels_like,
            'minimum_temperature': minimum_temperature,
            'maximum_temperature': maximum_temperature,
            'humidity': humidity,
            'wind_speed': wind_speed,
            'description': description,
        }
        
        return weather_info
    else:
        return None

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
