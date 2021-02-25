# Poisonous Animals Recognition iOS App
This repository contains swift scripts and Core ML models for our real-time poisonous animals recognition app  

A video demo of our app:   

## Image Classification Mode
Offers two functions:   
- Classifying a type of poisonous animal by taking a photo or supplying a photo from library
- Real-time classification from camera feed 
- Display both animal type and toxicity level with three colours(green, orange, red)
## Object Detection Mode
- Locating and classifying multiple poisonous animals by taking a photo or supplying a photo from library
- Real-time detection from camera feed 
- Display poisonous animals types, toxicity level and bounding boxes indicate animals' locations
## Library
A library contains  introductions of nine poisonous animals

## Thank you for these tutorials
- The image classification part of this ios app is learned from:  [pyimagesearch](https://www.pyimagesearch.com/)
- The object detection part of this ios app including converting tf model to mlmodel is learned from:
[MobileNetV2 + SSDLite with Core ML](https://machinethink.net/blog/mobilenet-ssdlite-coreml/)  
with [Source code](https://github.com/hollance/coreml-survival-guide/tree/master/MobileNetV2%2BSSDLite)
