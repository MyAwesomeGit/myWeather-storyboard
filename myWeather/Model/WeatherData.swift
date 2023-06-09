import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let sys: sys
    let timezone: Int
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}

struct sys: Codable {
    let sunrise: Int
    let sunset: Int
    
}

