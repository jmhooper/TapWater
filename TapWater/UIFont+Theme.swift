import UIKit

extension UIFont {
    class func boldTapWaterFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Ubuntu-Bold", size: size) ?? UIFont.systemFontOfSize(size)
    }
    
    class func boldItalicTapWaterFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Ubuntu-BoldItalic", size: size) ?? UIFont.systemFontOfSize(size)
    }
    
    class func italicTapWaterFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Ubuntu-Italic", size: size) ?? UIFont.systemFontOfSize(size)
    }
    
    class func lightTapWaterFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Ubuntu-Light", size: size) ?? UIFont.systemFontOfSize(size)
    }
    
    class func lightItalicTapWaterFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Ubuntu-LightItalic", size: size) ?? UIFont.systemFontOfSize(size)
    }
    
    class func regularTapWaterFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Ubuntu-Regular", size: size) ?? UIFont.systemFontOfSize(size)
    }
}
