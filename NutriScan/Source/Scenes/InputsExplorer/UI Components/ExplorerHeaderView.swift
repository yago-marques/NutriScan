//
//  ExplorerHeaderView.swift
//  NutriScan
//
//  Created by Yago Marques on 10/05/23.
//

import UIKit
import Speech

enum VoiceGesturesTypes {
    case tap, longPress
}

class ExplorerHeaderView: UIView, SFSpeechRecognizerDelegate {
    weak var mainView: InputsExplorerView?

    let tapInstruction = "Quando o nome do alimento desejado aparecer corretamente abaixo, toque no ícone de microfone para encerrar a pesquisa por voz"

    let longPressInstruction = "Quando o nome do alimento desejado aparecer corretamente abaixo, solte o ícone de microfone"

    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: .init(identifier: "pt-BR"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false
    var voicePredict = "" {
        didSet {
            mainView?.updateVoicePreview(text: voicePredict)
        }
    }

    init(frame: CGRect, view: InputsExplorerView) {
        self.mainView = view
        super.init(frame: frame)

        buildLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar(frame: .zero)
        search.placeholder = "Pesquisar"
        search.delegate = self
        search.translatesAutoresizingMaskIntoConstraints = false
        search.searchBarStyle = .minimal

        return search
    }()

    private lazy var voiceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        button.layer.cornerCurve = .circular
        button.layer.cornerRadius = 13
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longVoiceButtonHandler))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapVoiceButtonHandler))
        button.addGestureRecognizer(longGesture)
        button.addGestureRecognizer(tapGesture)

        return button
    }()

    @objc
    private func longVoiceButtonHandler(_ sender: UILongPressGestureRecognizer) {
        self.requestSpeechAuthorization()

        let state = sender.state

        switch state {
        case .began:
            startRecording(with: .longPress)
        case .ended:
            stopRecording()
        case .cancelled:
            stopRecording()
        case .failed:
            stopRecording()
        default:
            return
        }
    }

    @objc
    private func tapVoiceButtonHandler() {
        if !isRecording {
            startRecording(with: .tap)
        } else {
            stopRecording()
        }
    }

    func startRecording(with gesture: VoiceGesturesTypes) {
        let tapGestureToHidePreview = UITapGestureRecognizer(target: self, action: #selector(globalTapGestureToRemovePreview))
        mainView?.addGestureRecognizer(tapGestureToHidePreview)
        voicePredict = ""
        mainView?.showVoicePreview(instruction: gesture == .tap ? tapInstruction : longPressInstruction)
        self.recordAndRecognizeSpeech()
        isRecording = true
        voiceButton.backgroundColor = .red
        voiceButton.imageView?.tintColor = .white
        self.searchBar.isUserInteractionEnabled = false
        mainView?.filterSegmentedControl.isUserInteractionEnabled = false
        mainView?.foodGrid.isUserInteractionEnabled = false
    }

    func stopRecording() {
        mainView?.gestureRecognizers?.removeLast()
        mainView?.hideVoicePreview()
        cancelRecording()
        isRecording = false
        voiceButton.backgroundColor = .clear
        voiceButton.imageView?.tintColor = UIColor(named: "NSGreen")
        sendVoicePredict()
        voicePredict = ""
        self.searchBar.isUserInteractionEnabled = true
        mainView?.filterSegmentedControl.isUserInteractionEnabled = true
        mainView?.foodGrid.isUserInteractionEnabled = true
    }

    @objc
    private func globalTapGestureToRemovePreview() {
        stopRecording()
    }

    func sendVoicePredict() {
        if !voicePredict.isEmpty {
            mainView?.controller?.sendVoicePredict(voiceText: voicePredict)
        }
    }

    func cancelRecording() {
        recognitionTask?.finish()
        recognitionTask = nil

        // stop audio
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }

    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            self.sendAlert(title: "Speech Recognizer Error", message: "There has been an audio engine error.")
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            self.sendAlert(title: "Speech Recognizer Error", message: "There has been an audio engine error.")
            return
        }
        if !myRecognizer.isAvailable {
            self.sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not currently available. Check back at a later time.")
            // Recognizer is not available right now
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {

                let bestString = result.bestTranscription.formattedString
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = String(bestString[indexTo...])
                }

                self.checkForContentsSaid(resultString: lastString)
            }
        })
    }

    func checkForContentsSaid(resultString: String) {
        voicePredict.append("\(resultString) ")
    }

    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.voiceButton.isEnabled = true
                case .denied:
                    self.voiceButton.isEnabled = false
                case .restricted:
                    self.voiceButton.isEnabled = false
                case .notDetermined:
                    self.voiceButton.isEnabled = false
                @unknown default:
                    return
                }
            }
        }
    }

    func sendAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        mainView?.controller?.presentVoiceAlert(alert)
    }
}

extension ExplorerHeaderView: ViewCoding {
    func setupView() {
    }

    func setupHierarchy() {
        self.addSubview(searchBar)
        self.addSubview(voiceButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchBar.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.87),
            searchBar.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            voiceButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            voiceButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.1),
            voiceButton.heightAnchor.constraint(equalTo: voiceButton.widthAnchor),
            voiceButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

extension ExplorerHeaderView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            resetSearch()
        } else {
            mainView?.searchFoods(searchBy: searchText)
        }
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        mainView?.filterSegmentedControl.selectedSegmentIndex = 0
        mainView?.filterFoods()
        let tapGestureToHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.mainView?.addGestureRecognizer(tapGestureToHideKeyboard)

        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.mainView?.gestureRecognizers?.removeLast()

        return true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    @objc func dismissKeyboard() {
        self.searchBar.endEditing(true)
    }

    func resetSearch() {
        self.searchBar.text = ""
        self.mainView?.filterFoods()
    }
}
