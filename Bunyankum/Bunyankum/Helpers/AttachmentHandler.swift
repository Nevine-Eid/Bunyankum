//
//  AttachmentHandler.swift
//  AttachmentHandler
//
//  Created by Mina Thabet on 10/11/19.
//  Copyright © 2019 Hard Task. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation
import Photos

/*
 AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
 AttachmentHandler.shared.imagePickedBlock = { (image) in
 /* get your image here */
 }
 */



class AttachmentHandler: NSObject{
    static let shared = AttachmentHandler()
    fileprivate var currentVC: UIViewController?
    
    //MARK: - Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    var videoPickedBlock: ((NSURL) -> Void)?
    var filePickedBlock: ((URL) -> Void)?
    
    
    enum AttachmentType: String{
        case camera, cameraVideo ,video, photoLibrary
    }

    
    //MARK: - Constants
    struct Constants {
        static let actionFileTypeHeading = "Add a File"
        static let actionFileTypeDescription = "Choose a filetype to add..."
        static let camera = "Camera"
        static let cameraVideo = "CameraVideo"
        static let phoneLibrary = "Phone Library"
        static let video = "Video"
        static let file = "File"
        
        
        static let alertForPhotoLibraryMessage = "App does not have access to your photos. To enable access, tap settings and turn on Photo Library Access."
        
        static let alertForCameraAccessMessage = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
        
        static let alertForVideoLibraryMessage = "App does not have access to your video. To enable access, tap settings and turn on Video Library Access."
        
        
        static let settingsBtnTitle = "Settings"
        static let cancelBtnTitle = "Cancel"
        
    }
    
    
    
    //MARK: - showAttachmentActionSheet
    // This function is used to show the attachment sheet for image, video, photo and file.
    func showAttachmentActionSheet(vc: UIViewController) {
        currentVC = vc
        let actionSheet = UIAlertController(title: Constants.actionFileTypeHeading, message: Constants.actionFileTypeDescription, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: Constants.camera, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .camera, vc: self.currentVC!)
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.phoneLibrary, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self.currentVC!)
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.video, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .video, vc: self.currentVC!)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.file, style: .default, handler: { (action) -> Void in
            self.documentPicker()
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    
    //MARK: - showAttachmentActionSheetForImageOnly
        // This function is used to show the attachment sheet for image, video, photo and file.
        func showAttachmentImageActionSheet(vc: UIViewController) {
            currentVC = vc
            let actionSheet = UIAlertController(title: Constants.actionFileTypeHeading, message: Constants.actionFileTypeDescription, preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: Constants.camera, style: .default, handler: { (action) -> Void in
                self.authorisationStatus(attachmentTypeEnum: .camera, vc: self.currentVC!)
            }))
            
            actionSheet.addAction(UIAlertAction(title: Constants.phoneLibrary, style: .default, handler: { (action) -> Void in
                self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self.currentVC!)
            }))
            
            actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
            
            vc.present(actionSheet, animated: true, completion: nil)
        }
    
    //MARK: - showAttachmentActionSheetForVideoOnly
    // This function is used to show the attachment sheet for image, video, photo and file.
    func showAttachmentVideoActionSheet(vc: UIViewController) {
        currentVC = vc
        let actionSheet = UIAlertController(title: Constants.actionFileTypeHeading, message: Constants.actionFileTypeDescription, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: Constants.camera, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .cameraVideo, vc: self.currentVC!)
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.video, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .video, vc: self.currentVC!)
        }))
        
        actionSheet.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - Authorisation Status
    // This is used to check the authorisation status whether user gives access to import the image, photo library, video.
    // if the user gives access, then we can import the data safely
    // if not show them alert to access from settings.
    func authorisationStatus(attachmentTypeEnum: AttachmentType, vc: UIViewController){
        currentVC = vc
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            if attachmentTypeEnum == AttachmentType.camera{
                openCamera()
            }
            if attachmentTypeEnum == AttachmentType.cameraVideo {
                openCameraVideo()
            }
            if attachmentTypeEnum == AttachmentType.photoLibrary{
                photoLibrary()
            }
            if attachmentTypeEnum == AttachmentType.video{
                videoLibrary()
            }
        case .denied:
            print("permission denied")
            self.addAlertForSettings(attachmentTypeEnum)
        case .notDetermined:
            print("Permission Not Determined")
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized{
                    // photo library access given
                    print("access given")
                    if attachmentTypeEnum == AttachmentType.camera{
                        self.openCamera()
                    }
                    if attachmentTypeEnum == AttachmentType.cameraVideo {
                        self.openCameraVideo()
                     }
                    if attachmentTypeEnum == AttachmentType.photoLibrary{
                        self.photoLibrary()
                    }
                    if attachmentTypeEnum == AttachmentType.video{
                        self.videoLibrary()
                    }
                }else{
                    print("restriced manually")
                    self.addAlertForSettings(attachmentTypeEnum)
                }
            })
        case .restricted:
            print("permission restricted")
            self.addAlertForSettings(attachmentTypeEnum)
        default:
            break
        }
    }
    
    
    //MARK: - CAMERA PICKER
    //This function is used to open camera from the iphone and
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            mainQueue {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .camera
                myPickerController.mediaTypes = [kUTTypeImage as String]
                self.currentVC?.present(myPickerController, animated: true, completion: nil)
            }
        }
    }
    
    
    //This function is used to open camera from the iphone and
    func openCameraVideo(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            mainQueue {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .camera
                myPickerController.mediaTypes = [kUTTypeMovie as String]
                self.currentVC?.present(myPickerController, animated: true, completion: nil)
            }
        }
    }
    

    //MARK: - PHOTO PICKER
    func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            mainQueue {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .photoLibrary
                 self.currentVC?.present(myPickerController, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - VIDEO PICKER
    func videoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            mainQueue {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .photoLibrary
                myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
                 self.currentVC?.present(myPickerController, animated: true, completion: nil)
            }
        }
    }
    

    //MARK: - FILE PICKER
    func documentPicker(){
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        currentVC?.present(importMenu, animated: true, completion: nil)
    }
    
    //MARK: - SETTINGS ALERT
    func addAlertForSettings(_ attachmentTypeEnum: AttachmentType){
        var alertTitle: String = ""
        if attachmentTypeEnum == AttachmentType.camera{
            alertTitle = Constants.alertForCameraAccessMessage
        }
        if attachmentTypeEnum == AttachmentType.photoLibrary{
            alertTitle = Constants.alertForPhotoLibraryMessage
        }
        if attachmentTypeEnum == AttachmentType.video{
            alertTitle = Constants.alertForVideoLibraryMessage
        }
        
        let cameraUnavailableAlertController = UIAlertController (title: alertTitle , message: nil, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: Constants.settingsBtnTitle, style: .destructive) { (_) -> Void in
            let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: Constants.cancelBtnTitle, style: .default, handler: nil)
        cameraUnavailableAlertController .addAction(cancelAction)
        cameraUnavailableAlertController .addAction(settingsAction)
        currentVC?.present(cameraUnavailableAlertController , animated: true, completion: nil)
    }
}

//MARK: - IMAGE PICKER DELEGATE
// This is responsible for image picker interface to access image, video and then responsibel for canceling the picker
extension AttachmentHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imagePickedBlock?(image)
        } else{
            print("Something went wrong in  image")
        }
        
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL{
            print("videourl: ", videoUrl)
            //trying compression of video
            let data = NSData(contentsOf: videoUrl as URL)!
            print("File size before compression: \(Double(data.length / 1048576)) mb")
            if (Double(data.length / 1048576)) >= 30 {
                compressWithSessionStatusFunc(videoUrl)
            }else{
                DispatchQueue.main.async {
                    self.videoPickedBlock?(videoUrl)
                }
            }
            
        }
        else{
            print("Something went wrong in  video")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Video Compressing technique
    fileprivate func compressWithSessionStatusFunc(_ videoUrl: NSURL) {
        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".MOV")
        // new compress
//        convertVideoToLowQuailtyWithInputURL(inputURL: videoUrl, outputURL: compressedURL as NSURL) { (status) in
//            if status == true {
//                guard let compressedData = NSData(contentsOf: compressedURL) else {
//                    return
//                }
//                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")
//
//                DispatchQueue.main.async {
//                    self.videoPickedBlock?(compressedURL as NSURL)
//                }
//            }
//        }
        
        compressVideo(inputURL: videoUrl as URL, outputURL: compressedURL) { (exportSession) in
            guard let session = exportSession else {
                return
            }

            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = NSData(contentsOf: compressedURL) else {
                    return
                }
                print("File size after compression: \(Double(compressedData.length / 1048576)) mb")

                DispatchQueue.main.async {
                    self.videoPickedBlock?(compressedURL as NSURL)
                }

            case .failed:
                break
            case .cancelled:
                break
            }
        }
    }
    
    // Now compression is happening with medium quality, we can change when ever it is needed
    func compressVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetLowQuality) else {
            handler(nil)
            
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
    
    func convertVideoToLowQuailtyWithInputURL(inputURL: NSURL, outputURL: NSURL, completion: @escaping (Bool) -> Void) {

        let videoAsset = AVURLAsset(url: inputURL as URL, options: nil)
        let videoTrack = videoAsset.tracks(withMediaType: AVMediaType.video)[0]
        let videoSize = videoTrack.naturalSize
        let videoWriterCompressionSettings = [
            AVVideoAverageBitRateKey : Int(125000)
        ]

        let videoWriterSettings:[String : AnyObject] = [
            AVVideoCodecKey : AVVideoCodecType.h264 as AnyObject,
            AVVideoCompressionPropertiesKey : videoWriterCompressionSettings as AnyObject,
            AVVideoWidthKey : Int(videoSize.width) as AnyObject,
            AVVideoHeightKey : Int(videoSize.height) as AnyObject
        ]

        let videoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: videoWriterSettings)
        videoWriterInput.expectsMediaDataInRealTime = true
        videoWriterInput.transform = videoTrack.preferredTransform
        let videoWriter = try! AVAssetWriter(outputURL: outputURL as URL, fileType: AVFileType.mov)
        videoWriter.add(videoWriterInput)
        //setup video reader
        let videoReaderSettings:[String : AnyObject] = [
            kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange) as AnyObject
        ]

        let videoReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: videoReaderSettings)
        var videoReader: AVAssetReader!

        do{

            videoReader = try AVAssetReader(asset: videoAsset)
        }
        catch {

            print("video reader error: \(error)")
            completion(false)
        }
        videoReader.add(videoReaderOutput)
        //setup audio writer
        let audioWriterInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: nil)
        audioWriterInput.expectsMediaDataInRealTime = false
        videoWriter.add(audioWriterInput)
        //setup audio reader
        let audioTrack = videoAsset.tracks(withMediaType: AVMediaType.audio)[0]
        let audioReaderOutput = AVAssetReaderTrackOutput(track: audioTrack, outputSettings: nil)
        let audioReader = try! AVAssetReader(asset: videoAsset)
        audioReader.add(audioReaderOutput)
        videoWriter.startWriting()

        //start writing from video reader
        videoReader.startReading()
        videoWriter.startSession(atSourceTime: CMTime.zero)
        let processingQueue = DispatchQueue(label: "processingQueue1")
        videoWriterInput.requestMediaDataWhenReady(on: processingQueue, using: {() -> Void in
            while videoWriterInput.isReadyForMoreMediaData {
                let sampleBuffer:CMSampleBuffer? = videoReaderOutput.copyNextSampleBuffer();
                if videoReader.status == .reading && sampleBuffer != nil {
                    videoWriterInput.append(sampleBuffer!)
                }
                else {
                    videoWriterInput.markAsFinished()
                    if videoReader.status == .completed {
                        //start writing from audio reader
                        audioReader.startReading()
                        videoWriter.startSession(atSourceTime: CMTime.zero)
                        let processingQueue = DispatchQueue(label: "processingQueue2")
                        audioWriterInput.requestMediaDataWhenReady(on: processingQueue, using: {() -> Void in
                            while audioWriterInput.isReadyForMoreMediaData {
                                let sampleBuffer:CMSampleBuffer? = audioReaderOutput.copyNextSampleBuffer()
                                if audioReader.status == .reading && sampleBuffer != nil {
                                    audioWriterInput.append(sampleBuffer!)
                                }
                                else {
                                    audioWriterInput.markAsFinished()
                                    if audioReader.status == .completed {
                                        videoWriter.finishWriting(completionHandler: {() -> Void in
                                            completion(true)
                                        })
                                    }
                                }
                            }
                        })
                    }
                }
            }
        })
    }
}

//MARK: - FILE IMPORT DELEGATE
extension AttachmentHandler: UIDocumentMenuDelegate, UIDocumentPickerDelegate{
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        currentVC?.present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print("url", url)
        self.filePickedBlock?(url)
    }
    
    //    Method to handle cancel action.
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
}
