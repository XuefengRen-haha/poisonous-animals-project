

import UIKit
import SafariServices

/**
 The controller for the landing page
 - contains four buttons
 - redirect users to three different parts
 */
class LandingPage: UIViewController {
    
    // four buttons that redirect users to four different parts
    @IBOutlet weak var basicMode: UIButton!
    @IBOutlet weak var advancedMode: UIButton!
    @IBOutlet weak var spiderGallery: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // set customized feature for three buttons
        basicMode.setTitleColor(UIColor.black, for: .normal)
        advancedMode.setTitleColor(UIColor.black, for: .normal)
        spiderGallery.setTitleColor(UIColor.black, for: .normal)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
