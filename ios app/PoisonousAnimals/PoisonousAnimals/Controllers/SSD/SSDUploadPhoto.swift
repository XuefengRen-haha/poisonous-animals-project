

import UIKit
import CoreML
import AVFoundation
import Vision
import CoreMedia

/**
 Controller that allows user to upload a picture of spiders,
 then provides a prediction of spiders
 */
class SSDUploadPhoto: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var tips: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var currentBuffer: CVPixelBuffer?
    
    /**
     back to the previous controller
     - parameter sender: button going back to the prevous page
     */
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    
    // create VNCoreMLModel instance using the object detector model provided
    lazy var visionModel: VNCoreMLModel = {
        do {
            return try VNCoreMLModel(for: ConstantsEnum.objectDetector)
        } catch {
            fatalError("Failed to create VNCoreMLModel: \(error)")
        }
    }()
    
    /**
     run an inference with Core ML
     - Inside the completion handler for the VNCoreMLRequest we will get the results as an array of VNRecognizedObjectObservation objects.
     - There is one such object for every detected object in the image.
     - The observation object contains a property labels with the classification scores for the class labels, and a property boundingBox with the coordinates of the bounding box rectangle.
     */
    lazy var visionRequest: VNCoreMLRequest = {
        let request = VNCoreMLRequest(model: visionModel, completionHandler: {
            [weak self] request, error in
            self?.processObservations(for: request, error: error)
        })
        
        // NOTE: If you use another crop/scale option, you must also change
        // how the BoundingBoxView objects get scaled when they are drawn.
        // Currently they assume the full input image is used.
        request.imageCropAndScaleOption = .scaleFill
        return request
    }()

    // no more than 10 bounding boxes can be shown due to the computing power
    // set up bouding box views and color
    let maxBoundingBoxViews = 10
    var boundingBoxViews = [BoundingBoxView]()
    var colors: [String: UIColor] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBoundingBoxViews()
        setUpLayers()
    }
    
    // append label on bounding box
    func setUpBoundingBoxViews() {
        for _ in 0..<maxBoundingBoxViews {
            boundingBoxViews.append(BoundingBoxView())
        }
        
        // The label names are stored inside the MLModel's metadata.
        guard let userDefined = ConstantsEnum.objectDetector.modelDescription.metadata[MLModelMetadataKey.creatorDefinedKey] as? [String: String],
            let allLabels = userDefined["classes"] else {
                fatalError("Missing metadata")
        }
        
        let labels = allLabels.components(separatedBy: ",")
        
        // Assign random colors to the classes.
        for label in labels {
            colors[label] = UIColor(red: CGFloat.random(in: 0...1),
                                    green: CGFloat.random(in: 0...1),
                                    blue: CGFloat.random(in: 0...1),
                                    alpha: 1)
        }
    }
    
    // show the bounding box in the layer
    func setUpLayers() {
        // Add the bounding box layers to the UI, on top of the video preview.
        for box in self.boundingBoxViews {
            box.addToLayer(imageView.layer)
        }
    }
    
    // predict and generate result using model provided
    func predict(pixelBuffer: CVPixelBuffer) {
        tips.text = ""
        if currentBuffer == nil {
            currentBuffer = pixelBuffer
            // execute the request
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
            do {
                try handler.perform([self.visionRequest])
            } catch {
                print("Failed to perform Vision request: \(error)")
            }
            currentBuffer = nil
        }
    }
    
    /**
     Create the VNCoreMLRequest object,
     process observations and bind the result of prediction on it
     - parameter request: request for prediction
     - parameter error: error occurs during prediction
     */
    func processObservations(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            if let results = request.results as? [VNRecognizedObjectObservation] {
                self.show(predictions: results)
            } else {
                self.show(predictions: [])
            }
        }
    }
    
    // show the result of prediction
    func show(predictions: [VNRecognizedObjectObservation]) {
        for i in 0..<boundingBoxViews.count {
            if i < predictions.count {
                let prediction = predictions[i]
                
                /*
                 The predicted bounding box is in normalized image coordinates, with
                 the origin in the lower-left corner.
                 
                 Scale the bounding box to the coordinate system of the video preview,
                 which is as wide as the screen and has a 16:9 aspect ratio. The video
                 preview also may be letterboxed at the top and bottom.
                 
                 Based on code from https://github.com/Willjay90/AppleFaceDetection
                 
                 NOTE: If you use a different .imageCropAndScaleOption, or a different
                 video resolution, then you also need to change the math here!
                 */
                
                let width = view.bounds.width
                let height = width * 10 / 9 // it used to be 16 / 9 but the box is too large
                let offsetY = (view.bounds.height - height) / 2
                let scale = CGAffineTransform.identity.scaledBy(x: width, y: height)
                let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -height - offsetY)
                let rect = prediction.boundingBox.applying(scale).applying(transform)
                
                // The labels array is a list of VNClassificationObservation objects,
                // with the highest scoring class first in the list.
                let bestClass = prediction.labels[0].identifier
                let bestClass1 = ConstantsEnum.ssd_transfer["\(bestClass)"]!
                let confidence = prediction.labels[0].confidence
                
                // Show the bounding box with label.
                //let label = String(format: "%@ %.1f", bestClass, confidence * 100)
                let predconfidence = String(format: "%.1f", confidence * 100)
                let label = "\(bestClass1) \(predconfidence)"
                let color = colors[bestClass] ?? UIColor.red
                boundingBoxViews[i].show(frame: rect, label: label, color: color)
            } else {
                boundingBoxViews[i].hide()
            }
        }
    }
    
    /**
     Open camera and accept the photo taken
     - parameter sender: the button of taking picture
     */
    @IBAction func camera(_ sender: Any) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = false
        present(cameraPicker, animated: true)
    }
    
    /**
     Open library and accept the photo selected
     - parameter sender: the button of library
     */
    @IBAction func openLibrary(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SSDUploadPhoto: UIImagePickerControllerDelegate {
    func prediction(_ image: CVPixelBuffer) {
        predict(pixelBuffer: image)
    }
    
    /**
     Close the picker window if the user selected cancel
     - parameter picker: controller of image picker
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Capture the picture selected and predict using model provided
     - parameter picker: controller of image picker
     - parameter didFinishPickingMediaWithInfo: an array of String indicating the information of picked media
     */
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true)
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 299, height: 299), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 299, height: 299))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3
        
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        imageView.image = newImage
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        prediction(pixelBuffer!)
    }
}
