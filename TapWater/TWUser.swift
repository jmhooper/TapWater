import Foundation

class TWUser {
    // Constants
    
    static let VolumeGoalUpdatedNotificationName = "com.JonathanHooper.TapWater.Notification.CurrentUser.VolumeGoal.Updated"
    
    // Data
    
    let volumeGoal: Int
    
    // Init
    
    init(volumeGoal: Int) {
        self.volumeGoal = volumeGoal
    }
}

// MARK: Current User

extension TWUser {
    static func currentUser() -> TWUser {
        return TWUser(volumeGoal: loadCurrentVolumeGoal())
    }
}

// MARK: Goal Footwork

extension TWUser {
    private static let VOLUME_GOAL_USER_DEFAULT_KEY = "com.JonathanHooper.TapWater.UserDefault.CurrentUser.VolumeGoal"
    
    static func loadCurrentVolumeGoal() -> Int {
        let goal = NSUserDefaults.standardUserDefaults().integerForKey(
            TWUser.VOLUME_GOAL_USER_DEFAULT_KEY
        )
        if goal <= 0 {
            saveCurrentVolumeGoal(64)
            return loadCurrentVolumeGoal()
        } else {
            return goal
        }
    }
    
    static func saveCurrentVolumeGoal(goal: Int) {
        NSUserDefaults.standardUserDefaults().setInteger(
            goal,
            forKey: VOLUME_GOAL_USER_DEFAULT_KEY
        )
        sendCurrentUserVolumeGoalChangedNotification()
    }
}

// MARK: Notifications

extension TWUser {
    static func sendCurrentUserVolumeGoalChangedNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(
            TWUser.VolumeGoalUpdatedNotificationName,
            object: currentUser()
        )
    }
}