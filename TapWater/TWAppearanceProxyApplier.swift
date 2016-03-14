import UIKit

struct TWAppearanceProxyApplier {
    static func applyAppearanceProxies() {
        applyNavigationBarAppearanceProxies()
        applyBarButtonItemAppearanceProxies()
        applyPageControlAppearanceProxies()
    }
}

// MARK: Private ppearance proxy methods

extension TWAppearanceProxyApplier {
    private static func applyNavigationBarAppearanceProxies() {
        let appearance = UINavigationBar.appearance()
        appearance.titleTextAttributes = [
            NSFontAttributeName: UIFont.boldTapWaterFontWithSize(17.0),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
        ]
    }
    
    private static func applyBarButtonItemAppearanceProxies() {
        let appearance = UIBarButtonItem.appearance()
        appearance.setTitleTextAttributes(
            [
                NSFontAttributeName: UIFont.regularTapWaterFontWithSize(16.0),
            ],
            forState: .Normal
        )
    }
    
    private static func applyPageControlAppearanceProxies() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.tapWaterGrayColor()
        appearance.currentPageIndicatorTintColor = UIColor.tapWaterBlueColor()
    }
}