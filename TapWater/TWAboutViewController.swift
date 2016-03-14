import UIKit

class TWAboutViewController: UIViewController {
    // Outlets
    @IBOutlet var webView: UIWebView!
}

// MARK: View Lifecycle

extension TWAboutViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHTML()
    }
}

// MARK: HTML Loading

extension TWAboutViewController {
    func loadHTML() {
        let url = NSBundle.mainBundle().URLForResource(
            "about",
            withExtension: "html"
        )!
        let htmlString = try! String(
            contentsOfURL: url
        ).stringByReplacingOccurrencesOfString(
            "{{ version }}",
            withString: NSBundle.mainBundle().versionString()
        )
        webView.loadHTMLString(
            htmlString,
            baseURL: NSBundle.mainBundle().bundleURL
        )
    }
}