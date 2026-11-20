//
//  KeyboardViewController.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import SwiftUI
import UIKit

/// The Alltag keyboard: shows the SwiftUI keys and passes what is typed to the text field.
///
/// Typing works without Full Access and without a network. Nothing typed leaves the iPhone here.
final class KeyboardViewController: UIInputViewController {
    /// The App Group the app shares its theme through.
    static let group = "group.i8r4him.Alltag"

    private let model = KeyboardModel()
    private let feedback = SystemKeyFeedback()
    private var height: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Without Full Access the shared settings can't be read; the keyboard is gold then.
        if let raw = UserDefaults(suiteName: Self.group)?.string(forKey: CompanionLook.Key.palette),
           let palette = CompanionPalette(rawValue: raw) { AppTheme.shared.palette = palette }

        model.document = ProxyDocument(controller: self)
        model.feedback = feedback
        model.suggester = DictionarySuggestions()
        model.onNextKeyboard = { [weak self] in self?.advanceToNextInputMode() }

        let host = UIHostingController(rootView: KeyboardView(model: model))
        host.safeAreaRegions = []
        host.view.backgroundColor = .clear
        host.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(host)
        view.addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        host.didMove(toParent: self)

        let height = view.heightAnchor.constraint(equalToConstant: KeyboardView.height(isCompact: false))
        height.priority = UILayoutPriority(999)
        height.isActive = true
        self.height = height
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Asked once per appearance: the answer doesn't change while the keyboard shows.
        feedback.allowsHaptics = hasFullAccess
        refresh()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let wanted = KeyboardView.height(isCompact: traitCollection.verticalSizeClass == .compact)
        if height?.constant != wanted { height?.constant = wanted }
    }

    override func textDidChange(_ textInput: UITextInput?) {
        super.textDidChange(textInput)
        refresh()
    }

    private func refresh() {
        model.documentChanged(traits)
    }

    /// What the text field asks for: capitals, the return key, and whether words are offered.
    private var traits: KeyboardTraits {
        let proxy = textDocumentProxy
        let plain: [UIKeyboardType] = [.emailAddress, .URL, .twitter, .webSearch, .numberPad, .phonePad, .decimalPad]
        let offers = proxy.autocorrectionType != .no && !plain.contains(proxy.keyboardType ?? .default)
        return KeyboardTraits(capitalisation: Self.capitalisation(proxy.autocapitalizationType ?? .sentences),
                              returnKey: Self.returnKey(proxy.returnKeyType ?? .default),
                              showsGlobe: needsInputModeSwitchKey,
                              offersSuggestions: offers,
                              returnEnabled: !(proxy.enablesReturnKeyAutomatically ?? false) || proxy.hasText)
    }

    private static func capitalisation(_ type: UITextAutocapitalizationType) -> AutoCapitalisation {
        switch type {
        case .none: return .none
        case .words: return .words
        case .allCharacters: return .allCharacters
        case .sentences: return .sentences
        @unknown default: return .sentences
        }
    }

    private static func returnKey(_ type: UIReturnKeyType) -> ReturnKeyKind {
        switch type {
        case .go, .route, .join: return .forward
        case .google, .yahoo, .search: return .search
        case .send: return .send
        case .done: return .done
        case .next, .continue: return .next
        case .default, .emergencyCall: return .normal
        @unknown default: return .normal
        }
    }
}

/// The text field as the typing engine sees it.
private final class ProxyDocument: TextDocument {
    private weak var controller: UIInputViewController?

    init(controller: UIInputViewController) {
        self.controller = controller
    }

    var textBeforeCursor: String { controller?.textDocumentProxy.documentContextBeforeInput ?? "" }

    func insert(_ text: String) {
        controller?.textDocumentProxy.insertText(text)
    }

    func deleteBackward() {
        controller?.textDocumentProxy.deleteBackward()
    }

    func moveCursor(by offset: Int) {
        controller?.textDocumentProxy.adjustTextPosition(byCharacterOffset: offset)
    }
}
