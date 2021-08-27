//
// Created by Felipe Lobo on 27/08/21.
//

import Foundation
import AVFoundation

protocol UseCase {

    func startRecording()

    func stop()

    func playback(track: Data)

}

final class Interactor {

    let adapter: StateAdapter
    let audioRelay: AudioDataRelaying


    init(adapter: StateAdapter, audioRelay: AudioDataRelaying) {
        self.adapter = adapter
        self.audioRelay = audioRelay
    }

}

extension Interactor: UseCase {

    func startRecording() {
        adapter.didStartedRecording()
        try! audioRelay.start(frameHandler: { [adapter] data in
            adapter.didReceiveAudioDataChunk(data: data)
        })
    }

    func stop() {
        adapter.didStopRecording()
    }

    func playback(track: Data) {
        let decoder = OPAOpusDecoder()
        let format: AVAudioFormat?

        let pcmdata = decoder.decodedData(track, format: &format)

        let audioEngine = AVAudioEngine()
        let playerNode = AVAudioPlayerNode()

        guard let format = format else { return }

        audioEngine.connect(playerNode, to: audioEngine.outputNode, format: format)

        playerNode.play()

        let player = try AVAudioPlayer(data: pcmdata);
    }

}
