//  
//  AudioRelay.swift
//  OpusAudio
//
//  Created by Felipe Lobo on 27/08/21.
//

import Foundation
import AVFAudio

protocol AudioDataRelaying {

	func start(frameHandler: @escaping (Data) -> (), bufferHandler: ((AVAudioPCMBuffer, AVAudioTime) -> Void)?) throws

	func stop()

}

enum AudioRelayError: Error {
	case alreadyActive
}

final class AudioRelay<Encoder>: AudioDataRelaying where Encoder: OPAEncoder {

	let encoder: Encoder

	private let audioSession = EphemeralAudioSession()
	private var isActive = false

	init(encoder: Encoder) {
		self.encoder = encoder
	}

	func start(frameHandler: @escaping (Data) -> (), bufferHandler: ((AVAudioPCMBuffer, AVAudioTime) -> Void)? = nil) throws {
		guard !isActive else { throw AudioRelayError.alreadyActive }

		audioSession.installFrameEncoder(encoder, encodedFrameHandler: frameHandler, convertedBufferHandler: bufferHandler)

		try audioSession.start()

		isActive = true
	}

	func stop() {
		audioSession.stop()

		isActive = false
	}

}
