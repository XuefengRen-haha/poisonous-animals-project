

import UIKit

/**
 The controller for the advanced mode page
 - contains two buttons
 - redirect users to scan/upload photo part
 */
class SSDMode: UIViewController {
    @IBOutlet weak var scan: UIButton!
    @IBOutlet weak var uploadPhoto: UIButton!
    
    /**
     back to the previous controller
     - parameter sender: button going back to the prevous page
     */
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
