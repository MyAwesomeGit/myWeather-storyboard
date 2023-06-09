import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherDescription: UILabel!
    
    @IBOutlet weak var sunriseLabel: UILabel!
    
    @IBOutlet weak var sunsetLabel: UILabel!
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherManager.delegate = self
    }
}


extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather (_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = "\(weather.temperatureString)\(K.temperatureUnit)"
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            
            self.weatherDescription.text = ""
            var weatherDescriptionTextIndex = 0.0
            
            let weatherDescriptionTextAnimation = weather.description
            for letter in weatherDescriptionTextAnimation {
                Timer.scheduledTimer(withTimeInterval: 0.15 * weatherDescriptionTextIndex, repeats: false) { timer in
                    self.weatherDescription.text?.append(letter)
                }
                weatherDescriptionTextIndex += 1
            }
            
            let sunriseTime = localSunTime(time: weather.sunrise)
            let sunsetTime = localSunTime(time: weather.sunset)
            self.sunriseLabel.text = "\(K.sunriseLabel)\(sunriseTime)"
            self.sunsetLabel.text = "\(K.sunsetLabel)\(sunsetTime)"
            
            
            func localSunTime (time: Int) -> String {
                let sunriseTime = Date(timeIntervalSince1970: TimeInterval(time))
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = DateFormatter.Style.short
                dateFormatter.dateStyle = DateFormatter.Style.none
                dateFormatter.timeZone = .current
                let localSunTime = dateFormatter.string(from: sunriseTime)
                
                return localSunTime
            }
            
        }
    }
    
    
    func didFailWithError(error: Error) {
    }
}


extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
}
