//
//  TimeManager.swift
//  OtusCourseWork1
//
//  Created by Dmitry Potapov on 01.08.2024.
//

import Foundation

class TimeManager {

    static let shared = TimeManager()

    private init() { }

    /// Возвращает текущее время в указанном формате
    /// - Parameter format: Формат времени (по умолчанию "HH:mm:ss")
    /// - Returns: Строка с текущим временем в указанном формате
    func getCurrentTime(format: String = "HH:mm:ss") -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    /// Возвращает текущее время в виде Date объекта
    /// - Returns: Объект Date с текущим временем
    func getCurrentDate() -> Date {
        return Date()
    }

    /// Возвращает текущее время в указанной временной зоне
    /// - Parameters:
    ///   - timeZone: Временная зона
    ///   - format: Формат времени (по умолчанию "HH:mm:ss")
    /// - Returns: Строка с текущим временем в указанной временной зоне
    func getCurrentTime(in timeZone: TimeZone, format: String = "HH:mm:ss") -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: date)
    }

    /// Возвращает строку, определяющую время суток
    /// - Returns: Строка с названием времени суток
    func getTimeOfDay() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)

        switch (hour, minute) {
        case (6..<12, _):
            return "Утро"
        case (12, 1..<60), (13..<18, _):
            return "День"
        case (18, 1..<60), (19..<24, _):
            return "Вечер"
        case (0, 1..<60), (1..<6, _):
            return "Ночь"
        default:
            return "Утро"
        }
    }
}

