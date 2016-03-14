import Foundation

struct TWDrinkDate {
    // Date components
    let year: Int
    let month: Int
    let day: Int
    
    // Drinks
    var drinks: [TWDrink]
    
    // MARK: Initialization
    
    init(
        year: Int,
        month: Int,
        day: Int,
        drinks: [TWDrink]
    ) {
        self.year = year
        self.month = month
        self.day = day
        self.drinks = TWDrinkDate.sortDrinkArray(drinks)
    }
}

// MARK: Drink Management

extension TWDrinkDate {
    mutating func insert(drink: TWDrink) -> Int? {
        if let drinkDate = drink.drinkDate {
            if coversDate(drinkDate) {
                drinks = TWDrinkDate.sortDrinkArray(drinks + [drink])
                return drinks.indexOf(drink)
            }
        }
        return nil
    }
    
    mutating func remove(drink: TWDrink) -> Int? {
        if let index = indexOfDrink(drink) {
            drinks.removeAtIndex(index)
            return index
        }
        return nil
    }
    
    func indexOfDrink(drink: TWDrink) -> Int? {
        return drinks.indexOf({ $0.uid == drink.uid })
    }
    
    private static func sortDrinkArray(drinks: [TWDrink]) -> [TWDrink] {
        return drinks.sort({ (drinkA, drinkB) -> Bool in
            return drinkA.drinkDate != nil
                && drinkB.drinkDate != nil
                && drinkA.drinkDate!.timeIntervalSince1970 > drinkB.drinkDate!.timeIntervalSince1970
        })
    }
}

// MARK: Volume

extension TWDrinkDate {
    func totalVolume() -> Int {
        return drinks.reduce(0, combine: { (accumulator, drink) in
            if let volume = drink.container?.volume {
                return accumulator + Int(volume)
            } else {
                return accumulator
            }
        })
    }
}

// MARK: Date Math

extension TWDrinkDate {
    func coversDate(date: NSDate) -> Bool {
        return day == date.day() && month == date.month() && year == date.year()
    }
    
    func date() -> NSDate {
        return NSDate.fromComponents(year: year, month: month, day: day)
    }
}