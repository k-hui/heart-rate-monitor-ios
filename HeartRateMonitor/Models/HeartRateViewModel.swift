//
//  HeartRateViewModel.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 29/10/2021.
//

import SwiftUI
import Foundation
import AVFoundation
import UIKit

typealias ImageBufferHandler = ((_ imageBuffer: CMSampleBuffer) -> ())

final class HeartRateViewModel: NSObject, ObservableObject {
    @Published var validFrameCounter = 0
    @Published var hueFilter = Filter()
    @Published var pulseDetector = PulseDetector()
    @Published var inputs: [CGFloat] = []

    private let preferredSpec = VideoSpec(fps: 30, size: CGSize(width: 300, height: 300))
    private let captureSession = AVCaptureSession()
    private var videoDevice: AVCaptureDevice!
    private var videoConnection: AVCaptureConnection!
    private var audioConnection: AVCaptureConnection!
    private var previewLayer: AVCaptureVideoPreviewLayer?

    var imageBufferHandler: ImageBufferHandler?

    init(cameraType: CameraType = .back, previewContainer: CALayer? = nil) {
        super.init()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            Logger.d("has camera")
        } else {
            Logger.d("no camera")
            return
        }

        videoDevice = cameraType.captureDevice()
        
        guard videoDevice != nil else {
            Logger.d("no videoDevice")
            return
        }

        // MARK: - Setup Video Format
        do {
            captureSession.sessionPreset = .low
            videoDevice.updateFormatWithPreferredVideoSpec(preferredSpec: preferredSpec)
        }

        // MARK: - Setup video device input
        let videoDeviceInput: AVCaptureDeviceInput
        do {
            videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
        } catch let error {
            fatalError("Could not create AVCaptureDeviceInput instance with error: \(error).")
        }
        guard captureSession.canAddInput(videoDeviceInput) else { fatalError() }
        captureSession.addInput(videoDeviceInput)

        // MARK: - Setup preview layer
        if let previewContainer = previewContainer {
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = previewContainer.bounds
            previewLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewContainer.insertSublayer(previewLayer, at: 0)
            self.previewLayer = previewLayer
        }

        // MARK: - Setup video output
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey: NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        let queue = DispatchQueue(label: "key.app.queue")
        videoDataOutput.setSampleBufferDelegate(self, queue: queue)
        guard captureSession.canAddOutput(videoDataOutput) else {
            fatalError()
        }
        captureSession.addOutput(videoDataOutput)
        videoConnection = videoDataOutput.connection(with: .video)
    }

    func getSession() -> AVCaptureSession {
        return captureSession
    }

    func startCapture() {
        if captureSession.isRunning {
            print("Capture Session is already running.")
            return
        }
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }

    func stopCapture() {
        if !captureSession.isRunning {
            print("Capture Session has already stopped.")
            return
        }
        DispatchQueue.global(qos: .background).async {
            self.captureSession.stopRunning()
        }
    }

    func handle(buffer: CMSampleBuffer) -> Bool {
        var redMean: CGFloat = 0.0
        var greenMean: CGFloat = 0.0
        var blueMean: CGFloat = 0.0

        let pixelBuffer = CMSampleBufferGetImageBuffer(buffer)
        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer!)

        let extent = cameraImage.extent
        let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
        let averageFilter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: cameraImage, kCIInputExtentKey: inputExtent])!
        let outputImage = averageFilter.outputImage!

        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(outputImage, from: outputImage.extent)!

        let rawData: NSData = cgImage.dataProvider!.data!
        let pixels = rawData.bytes.assumingMemoryBound(to: UInt8.self)
        let bytes = UnsafeBufferPointer<UInt8>(start: pixels, count: rawData.length)
        var bgraIndex = 0
        for pixel in UnsafeBufferPointer(start: bytes.baseAddress, count: bytes.count) {
            switch bgraIndex {
            case 0:
                blueMean = CGFloat(pixel)
            case 1:
                greenMean = CGFloat(pixel)
            case 2:
                redMean = CGFloat(pixel)
            case 3:
                break
            default:
                break
            }
            bgraIndex += 1
        }

        let hsv = rgb2hsv((red: redMean, green: greenMean, blue: blueMean, alpha: 1.0))
        let isPassed = isPassedHsv(hsv)

        // publish values from backgorund thread to main thread
        DispatchQueue.main.async {
            if isPassed {
                self.validFrameCounter += 1
                self.inputs.append(hsv.0)
                // Filter the hue value - the filter is a simple BAND PASS FILTER that removes any DC component and any high frequency noise
                let filtered = self.hueFilter.processValue(value: Double(hsv.0))
                if self.validFrameCounter > 60 {
                    _ = self.pulseDetector.addNewValue(newVal: filtered, atTime: CACurrentMediaTime())
                }
            } else {
                self.validFrameCounter = 0
                self.pulseDetector.reset()
            }
        }

        return isPassed
    }

    func isPassedHsv(_ hsv: HSV) -> Bool {
        return hsv.0 > 0.6 && hsv.1 > 0.5 && hsv.2 > 0.5
    }
}

extension HeartRateViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    // MARK: - Export buffer from video frame
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if connection.videoOrientation != .portrait {
            connection.videoOrientation = .portrait
            return
        }
        if let imageBufferHandler = imageBufferHandler {
            imageBufferHandler(sampleBuffer)
        }
    }
}
