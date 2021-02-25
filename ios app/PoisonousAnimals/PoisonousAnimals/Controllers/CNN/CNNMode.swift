

import UIKit

/**
 The controller for the simple mode page
 - contains two buttons
 - redirect users to scan/upload photo part
 */
class CNNMode: UIViewController {
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
