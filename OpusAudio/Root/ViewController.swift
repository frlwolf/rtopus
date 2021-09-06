//
//  ViewController.swift
//  OpusAudio
//
//  Created by Felipe Lobo on 25/08/21.
//

import UIKit
import AVFAudio

class ViewController: UIViewController {

    let useCase: UseCase
    let state: State

    private let recordButton: UIButton = {
        let recordButton = UIButton()
        recordButton.backgroundColor = .red
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.setTitle("Start recording", for: .normal)

        return recordButton
    }()

    private let playbackButton: UIButton = {
        let playbackButton = UIButton()
        playbackButton.backgroundColor = .black
        playbackButton.translatesAutoresizingMaskIntoConstraints = false
        playbackButton.setTitle("Playback", for: .normal)

        return playbackButton
    }()

    init(useCase: UseCase, state: State) {
        self.useCase = useCase
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        preconditionFailure()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupSubviews()
        setupConstraints()
    }

    @objc
    private func didTapRecord(sender: UIButton) {
        sender.isEnabled = false

        useCase.startRecording()

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [useCase, state] in
            useCase.stop()

            print(state.recorded.count)
            print(state.recorded)
        }
    }

    @objc
    private func didTapPlayback(sender: UIButton) {
        useCase.playback(opusChunks: state.recorded)
    }

    private func setupSubviews() {
        playbackButton.addTarget(self, action: #selector(didTapPlayback(sender:)), for: .touchUpInside)

        view.addSubview(playbackButton)

        recordButton.addTarget(self, action: #selector(didTapRecord(sender:)), for: .touchUpInside)

        view.addSubview(recordButton)
    }

    private func setupConstraints() {
        view.addConstraints([
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),

            playbackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playbackButton.topAnchor.constraint(equalTo: recordButton.bottomAnchor, constant: 20)
        ])
    }

}
