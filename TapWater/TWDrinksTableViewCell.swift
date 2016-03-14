import UIKit

class TWDrinksTableViewCell: UITableViewCell {
    // Drink Data
    var drink: TWDrink? {
        get {
            return _drink
        } set (newValue) {
            _drink = newValue
            respondToDrinkUpdate()
        }
    }
    var _drink: TWDrink?
    
    // Outlets
    @IBOutlet var containerNameLabel: UILabel!
    @IBOutlet var drinkDateLabel: UILabel!
    @IBOutlet var containerVolumeLabel: UILabel!
}

// MARK: Drink update responses

extension TWDrinksTableViewCell {
    func respondToDrinkUpdate() {
        if let drink = drink,
            drinkContainerName = drink.container?.name,
            drinkContainerVolume = drink.container?.volume,
            drinkDate = drink.drinkDate
        {
            containerNameLabel.text = drinkContainerName
            containerVolumeLabel.text = "\(drinkContainerVolume)oz"
            drinkDateLabel.text = drinkDate.formatWithTimeStyle(
                .ShortStyle,
                dateStyle: .NoStyle
            )
        } else {
            for label in [containerNameLabel, containerVolumeLabel, drinkDateLabel] {
                label.text = nil
            }
        }
    }
}

