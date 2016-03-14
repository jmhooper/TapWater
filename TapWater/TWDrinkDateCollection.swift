import Foundation

struct TWDrinkDateCollection {
    var drinkDates: [TWDrinkDate]
}

// MARK: Drink date queries

extension TWDrinkDateCollection {
    func drinkDateIndexForDate(date: NSDate) -> Int? {
        return drinkDates.indexOf({ $0.coversDate(date) })
    }
    
    func indexPathForDrink(drink: TWDrink) -> NSIndexPath? {
        if let drinkDate = drink.drinkDate,
            section = drinkDateIndexForDate(drinkDate),
            row = drinkDates[section].indexOfDrink(drink)
        {
            return NSIndexPath(forRow: row, inSection: section)
        } else {
            return nil
        }
    }
}

// MARK: Drink insertion

extension TWDrinkDateCollection {
    mutating func insertDrink(drink: TWDrink) -> NSIndexPath? {
        if let date = drink.drinkDate {
            if let section = drinkDateIndexForDate(date),
                let row = drinkDates[section].insert(drink)
            {
                return NSIndexPath(forRow: row, inSection: section)
            } else {
                if let section = insertDrinkDate(
                    TWDrinkDate(
                        year: date.year(),
                        month: date.month(),
                        day: date.day(),
                        drinks: [drink]
                    )
                ) {
                    return NSIndexPath(forRow: 0, inSection: section)
                }
            }
        }
        return nil
    }
    
    mutating func insertDrinkDate(drinkDate: TWDrinkDate) -> Int? {
        drinkDates = sortDrinkDates(drinkDates + [drinkDate])
        return drinkDates.indexOf({
            return drinkDate.year == $0.year
                && drinkDate.month == $0.month
                && drinkDate.day == $0.day
            }
        )
    }
    
    private func sortDrinkDates(drinkDates: [TWDrinkDate]) -> [TWDrinkDate] {
        return drinkDates.sort({
            $0.date().timeIntervalSince1970 > $1.date().timeIntervalSince1970
        })
    }
}

// MARK: Drink Deletion

extension TWDrinkDateCollection {
    mutating func removeDrink(drink: TWDrink) -> NSIndexPath? {
        if let date = drink.drinkDate,
            section = drinkDateIndexForDate(date)
        {
            var drinkDate = drinkDates[section]
            if let row = drinkDate.remove(drink) {
                if drinkDate.drinks.count == 0 {
                    drinkDates.removeAtIndex(section)
                } else {
                    drinkDates[section] = drinkDate
                }
                return NSIndexPath(forRow: row, inSection: section)
            }
        }
        return nil
    }
}

// MARK: Drink Loading

extension TWDrinkDateCollection {
    static func loadDrinkCollection(
        completion: (TWDrinkDateCollection) -> Void
    ) {
        var collection = TWDrinkDateCollection(drinkDates: [])
        TWDrink.fetchAll { (drinks) in
            for drink in drinks {
                collection.insertDrink(drink)
            }
            completion(collection)
        }
    }
}