//
//  Weather_AppTests.swift
//  Weather AppTests
//
//  Created by Abdullah Nana on 2021/08/27.
//

import XCTest
@testable import Weather_App

class WeatherAppTests: XCTestCase {
    private lazy var weatherResults = WeatherResults(weather: nil)
    private lazy var currentLocationViewModel = CurrentLocationViewModel()
    private lazy var forecastViewModel = ForecastViewModel()

    override func setUpWithError() throws {
        currentLocationViewModel = CurrentLocationViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testCurrentLocationTemperature() throws {
        let temperature = String(Int(weatherResults.currentWeather?.temp ?? 0))
        let viewModelTemperature = currentLocationViewModel.currentLocationTemparature
        XCTAssertEqual(temperature, viewModelTemperature, "Current location temperatures not equal")
    }
    func testCurrentLocationIcon() throws {
        let viewModelIcon = currentLocationViewModel.currentLocationIcon
        let icon = weatherResults.conditionIDToIconString(
            conditionID: weatherResults.currentWeather?.weather.first?.id ?? 0)
        XCTAssertEqual(icon, viewModelIcon, "Current location icon strings not equal")
    }
    func testCityName() throws {
        let cityName = currentLocationViewModel.cityName(weatherResults.weather?.timezone ?? "Johannesburg")
        let viewModelCityName = currentLocationViewModel.currentLocationCityName
        XCTAssertEqual(cityName, viewModelCityName, "Current location city names not equal")
    }
    func testCurrentLocationDate() throws {
        let date = weatherResults.currentWeather?.dt ?? 0
        let viewModelDate = currentLocationViewModel.currentLocationDate
        XCTAssertEqual(date, viewModelDate, "Current location dates not equal")
    }
    func testCurrentLocationWeatherDescription() throws {
        let description = weatherResults.currentWeather?.weather.first?.description.capitalized ?? ""
        let viewModelDescription = currentLocationViewModel.currentLocationWeatherDescription
        XCTAssertEqual(description, viewModelDescription, "Current location weather descriptions not equal")
    }
    func testNumberOfDailyWeatherResults() throws {
        let numberOfDailyResults = weatherResults.dailyWeather?.count ?? 0
        let viewModelDailyResults = forecastViewModel.hourlyWeatherResultsCount
        XCTAssertEqual(numberOfDailyResults, viewModelDailyResults, "Number of daily results not equal")
    }
    func testNumberOfHourlyWeatherResults() throws {
        let numberOfHourlyResults = weatherResults.hourlyWeather?.count ?? 0
        let viewModelHourlyResults = forecastViewModel.hourlyWeatherResultsCount
        XCTAssertEqual(numberOfHourlyResults, viewModelHourlyResults, "Number of hourly results not equal")
    }
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
