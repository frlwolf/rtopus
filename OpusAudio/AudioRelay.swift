//  
//  AudioRelay.swift
//  OpusAudio
//
//  Created by Felipe Lobo on 27/08/21.
//

import Foundation

protocol AudioDataRelaying {

	func start(frameHandler: @escaping (Data) -> ()) throws

	func stop()

}

final class AudioRelay<Encoder>: AudioDataRelaying where Encoder: OPAEncoder {

	enum AudioRelayError: Error {
		case alreadyActive
	}

	private var isActive = false
	private let micServer = OPUMicServer()

	func start(frameHandler: @escaping (Data) -> ()) throws {
		guard !isActive else { throw AudioRelayError.alreadyActive }
		micServer.installFrameEncoder(Encoder(), encodedFrameHandler: frameHandler)
		try micServer.start()
		isActive = true
	}

	func stop() {
		micServer.stop()
	}

}
