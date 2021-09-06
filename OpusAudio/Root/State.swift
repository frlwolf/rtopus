//
// Created by Felipe Lobo on 27/08/21.
//

import Foundation
import Combine

protocol StateAdapter {

    func didStartedRecording()

    func didReceiveAudioDataChunk(data: Data)

    func didStopRecording()

}

final class State {

    var isRecording: Bool = false

    var recorded: [Data] = []

}

extension State: StateAdapter {

    func didStartedRecording() {
        isRecording = true
    }

    func didStopRecording() {
        isRecording = false
    }

    func didReceiveAudioDataChunk(data: Data) {
        recorded.append(data)
    }
}
