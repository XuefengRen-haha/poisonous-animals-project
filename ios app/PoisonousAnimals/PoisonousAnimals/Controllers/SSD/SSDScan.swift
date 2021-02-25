



import CoreMedia
import CoreML
import UIKit
import Vision

/**
 Controller that allows user to scan multiple spiders,
 then provides a prediction of spiders in real time
 */
class SSDScan: UIViewController {
    
    /** view of scanning */
    @IBOutlet var videoPreview: UIView!
    
    /**
     back to the previous controller
     - parameter sender: button going back to the prevous page
     */
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // set up the video captured and pixel buffer
    var videoCapture: VideoCapture!
    var currentBuffer: CVPixelBuffer?
    
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
    
    // set up the bounding box
    let maxBoundingBoxViews = 10
    var boundingBoxViews = [BoundingBoxView]()
    var colors: [String: UIColor] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBoundingBoxViews()
        setUpCamera()
    }
    
    /** set up bounding box views */
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
    
    /** set up camera */
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        
        videoCapture.setUp(sessionPreset: .hd1280x720) { success in
            if success {
                // Add the video preview into the UI.
                if let previewLayer = self.videoCapture.previewLayer {
                    self.videoPreview.layer.addSublayer(previewLayer)
                    self.resizePreviewLayer()
                }
                
                // Add the bounding box layers to the UI, on top of the video preview.
                for box in self.boundingBoxViews {
                    box.addToLayer(self.videoPreview.layer)
                }
                
                // Once everything is set up, we can start capturing live video.
                self.videoCapture.start()
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        resizePreviewLayer()
    }
    
    /** resize the preview layer */
    func resizePreviewLayer() {
        videoCapture.previewLayer?.frame = videoPreview.bounds
    }
    
    /**
     Process predition using model provided
     - parameter sampleBuffer: CM sample buffer storing video
     */
    func predict(sampleBuffer: CMSampleBuffer) {
        if currentBuffer == nil, let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            currentBuffer = pixelBuffer
            
            // Get additional info from the camera.
            var options: [VNImageOption : Any] = [:]
            if let cameraIntrinsicMatrix = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
                options[.cameraIntrinsics] = cameraIntrinsicMatrix
            }
            
            // execute the request
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: options)
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
    
    /**
     Show the video and bounding boxes, with predcition result
     - parameter predictions: an array of object observation
     */
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
                let height = width * 16 / 9
                let offsetY = (view.bounds.height - height) / 2
                let scale = CGAffineTransform.identity.scaledBy(x: width, y: height)
                let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -height - offsetY)
                let rect = prediction.boundingBox.applying(scale).applying(transform)
                
                // The labels array is a list of VNClassificationObservation objects,
                // with the highest scoring class first in the list.
                let bestClass = prediction.labels[0].identifier
                let bestClass1 = ConstantsEnum.ssd_transfer["\(bestClass)"]!
                let confidence = prediction.labels[0].confidence
                
                // Show the bounding box.
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
}

extension SSDScan: VideoCaptureDelegate {
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame sampleBuffer: CMSampleBuffer) {
        predict(sampleBuffer: sampleBuffer)
    }
}
