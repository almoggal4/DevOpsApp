<?php 
    function PrintCityWeather($url, $city){
        # make API call
        $data = file_get_contents($url);
        $data = json_decode($data, true);
        # take from json weather's data
        $main = $data['main'];
        $temperature_kelvin = (int)$main['temp'];
        $tempature_celsius_int = $temperature_kelvin - 273.15;
        $temperature_celsius = (string)$tempature_celsius_int;
        $feels_like = $main['feels_like'] - 273.15;
        $minimum_temperature = $main['temp_min'] - 273.15;
        $maximum_temperature = $main['temp_max'] - 273.15;
        $humidity = $main['humidity'];

        $wind = $data['wind'];
        $wind_speed = $wind['speed'];

        # prints city's weather data
        echo $city."'s Tempature Today:</h2><br>"; 
        echo "Temperature: ".$temperature_celsius." Celsius<br>";
        echo "\r\n Feels Like: ".$feels_like." Celsius<br>";
        echo "\r\n Minimum Temperature: ".$minimum_temperature." Celsius<br>";
        echo "\r\n Maximum Temperature: ".$maximum_temperature." Celsius<br>";
        echo "\r\n Humidity: ".$humidity."<br>";
        echo "\r\n Wind Speed: ".$wind_speed."<br>";
        
    }
    $BASE_URL = "https://api.openweathermap.org/data/2.5/weather?";
    $CITY = $_POST['city'];
    $API_KEY = "b91fbbf37cd14f27579fa3b86af2b7c8";
    # upadting the URL
    $URL = $BASE_URL."q=".$CITY."&appid=".$API_KEY;
    PrintCityWeather($URL, $CITY);
?>