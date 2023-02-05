//
//  VideoPlayerView.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 10/31/21.
//

import SwiftUI
import AVKit

// TODO: work in progress, for testing by video
struct VideoPlayerView: View {
    @StateObject private var vm = HeartRateViewModel()

    private let url = Bundle.main.url(forResource: "demo", withExtension: "mp4")!
    private let player: AVPlayer

    init() {
        player = AVPlayer(url: url)
        player.isMuted = true
        player.play()
    }

    var body: some View {
        VideoPlayer(player: player)
            .frame(width: 67.5, height: 120)
            .onAppear {
            onAppear()
        }.onDisappear() {
            player.pause()
        }
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView()
    }
}

extension VideoPlayerView {
    func onAppear() {
        let asset = AVAsset(url: url)
        let reader = try! AVAssetReader(asset: asset)
        let videoTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
        // read video frames as BGRA
        let trackReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: [String(kCVPixelBufferPixelFormatTypeKey): NSNumber(value: kCVPixelFormatType_32BGRA)])

        reader.add(trackReaderOutput)
        reader.startReading()

        // uniform intervals
        while let sampleBuffer = trackReaderOutput.copyNextSampleBuffer() {
            let time = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
            Logger.d("time: \(time.value), timescale: \(time.timescale)")
            _ = vm.handle(buffer: sampleBuffer)
            let average = vm.pulseDetector.getAverage()
            let pulse = 60.0 / average
            let pulseMessage = "\(lroundf(pulse)) BPM"
            Logger.d(pulseMessage)
        }
    }
}
