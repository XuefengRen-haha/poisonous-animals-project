

import UIKit

/**
 Controller of the Spider Gallery page
 */
class Library: UIViewController {
    
    /** The label showing the prediction result */
    @IBOutlet weak var introduction: UILabel!
    
    
    /**
     back to the previous controller
     - parameter sender: button going back to the prevous page
     */
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /** The image that users focus */
    var vImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
     Magnify the spider photo selected by users,
     and show information of that spider
     - parameter sender: the button showing a spider, selected by users
     */
    @IBAction func spiderSelected(_ sender: UIButton) {
        // retrieve the image title selected by user
        // initial the UIImageView
        // set up the position and size of that image
        // show that image on view
        let image = UIImage(named: sender.currentTitle!)
        vImg = UIImageView(image: image);
        vImg.frame = CGRect(x: 0, y: 63, width: 414, height: 414);
        self.view.addSubview(vImg);
        
        // enable user to interact with that image
        // set up a gesture that allows user to close that magnified image
        // and link it to the image
        vImg.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(SpiderGallery.closeIntro))
        vImg.addGestureRecognizer(gesture)
        
        // retrieve the poisonousness level of that spider
        // map it to certain color
        // show the poisonousness level and introduction of the spider
        let toxicity = ConstantsEnum.spiderMapping[sender.currentTitle!]!
        //introduction.text = ConstantsEnum.spiderMapping[sender.currentTitle!]! + "\n" +
                         //ConstantsEnum.spiderIntro[sender.currentTitle!]!
        
        introduction.text = ConstantsEnum.spiderMapping[sender.currentTitle!]! + "\n" +
                            ConstantsEnum.spiderIntro[sender.currentTitle!]!
        
        //let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: introduction.text!)
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: introduction.text!)
        
        //attributedString.setColorForText(textForAttribute: toxicity, withColor: ConstantsEnum.colorMapping[toxicity]!)
        
        attributedString.setColorForText(textForAttribute: toxicity, withColor: ConstantsEnum.colorMapping[toxicity]!)
        
        //introduction.attributedText = attributedString
        
        introduction.attributedText = attributedString
        
        //self.view.addSubview(introduction)
        self.view.addSubview(introduction)
    }
    
    /** Allows user to close that magnified image */
    @objc func closeIntro(){
        // remove the image from view
        vImg.removeFromSuperview()
        // reset the label of introduction
        introduction.text = "Select one animal"
        
        
    }
    
    
}

extension NSMutableAttributedString {
    
    /**
     Set color for text
     - parameter textForAttribute: text shown
     - parameter withColor: relative color of the text
     */
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        
        // Swift 4.2 and above
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        
        // Swift 4.1 and below
        // self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
    }
}
