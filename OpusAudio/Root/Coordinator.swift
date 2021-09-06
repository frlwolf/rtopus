//
// Created by Felipe Lobo on 25/08/21.
//

import Foundation

final class Coordinator {

    func start(window: Window) {
        let opusEncoder = Opus.Encoder()
        let audioRelay = AudioRelay(encoder: opusEncoder)
        let state = State()
        let useCase = Interactor(adapter: state, audioRelay: audioRelay)

        let viewController = ViewController(useCase: useCase, state: state)

        try? window.makeRoot(view: viewController)
        window.makeKeyAndVisible()
    }

}
