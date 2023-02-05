//
//  CameraType.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 29/10/2021.
//

import AVFoundation

enum CameraType: Int {
    case back
    case front

    func captureDevice() -> AVCaptureDevice? {
        switch self {
        case .front:
            let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [], mediaType: AVMediaType.video, position: .front).devices
            print("devices:\(devices)")
            for device in devices where device.position == .front {
                return device
            }
        default:
            break
        }
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) ?? nil
    }
}
