//
// Created by Felipe Lobo on 27/08/21.
//

import Foundation
import AVFoundation

protocol UseCase {

    func startRecording()

    func stop()

    func playback(opusChunks: [Data])

}

final class Interactor {

    let adapter: StateAdapter
    let audioRelay: AudioDataRelaying

    private let wavBuilder: WAVBuilder

    init(adapter: StateAdapter, audioRelay: AudioDataRelaying) {
        self.adapter = adapter
        self.audioRelay = audioRelay

        wavBuilder = WAVBuilder(format: Opus.defaultFormat())
    }

}

extension Interactor: UseCase {

    func startRecording() {
        adapter.didStartedRecording()
        try? audioRelay.start(frameHandler: { [adapter] data in
            adapter.didReceiveAudioDataChunk(data: data)
        }, bufferHandler: { [wavBuilder] buffer, when in
            wavBuilder.appendChunk(with: buffer)
        })
    }

    func stop() {
        audioRelay.stop()
        adapter.didStopRecording()
        try? wavBuilder.save()
    }

    // Playback is just saving a wav file with the decoded PCM
    func playback(opusChunks: [Data]) {
        wavBuilder.reset(to: Opus.defaultFormat())

        for chunk in opusChunks {
            let decoder = Opus.Decoder()
            let pcmBuffer = decoder.decodedBuffer(from: chunk)

            wavBuilder.appendChunk(with: pcmBuffer)
        }

        try? wavBuilder.save()
    }

}
