//
// Created by Felipe Lobo on 25/08/21.
//

import Foundation

final class Coordinator {

    func start(window: Window) {
        let audioRelay = AudioRelay<OPAOpusEncoder>()
        let state = State()
        let useCase = Interactor(adapter: state, audioRelay: audioRelay)

        let viewController = ViewController(useCase: useCase, state: state)

        try? window.makeRoot(view: viewController)
        window.makeKeyAndVisible()
    }

}
