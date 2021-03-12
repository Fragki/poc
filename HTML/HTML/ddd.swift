////
////  ContentView.swift
////  HTML
////
////  Created by fragi on 11/03/2021.
////
//
//import SwiftUI
//
//struct ContentView: View {
//
//    var body: some View {
//        VStack(spacing: 0, content: {
//            AttributedText(attributedText: t())
//                .font(.system(size: 22, weight: .regular))
//                .background(Color.red)
//            Text("Hello, world!")
//                .padding()
//            Spacer()
//        })
//
//    }
//
//    func t() -> NSAttributedString? {
//        return try? NSMutableAttributedString(data: Data("<h1>bbbbbbccc</h1>".utf8),
//                                                      options: [.documentType: NSAttributedString.DocumentType.html],
//                                                      documentAttributes: nil)
//    }
//}
//
//struct AttributedText: View {
//    @State var attributedText: NSAttributedString?
//    @State private var desiredHeight: CGFloat = 0
//    @State private var url: URL?
//
//    var body: some View {
//        HTMLText(attributedString: $attributedText,
//                 desiredHeight: $desiredHeight,
//                 linkPressed: {
//            self.url = $0
//        })
//        .frame(height: desiredHeight)
//        .sheet(isPresented: .init(get: { url != nil },
//                                  set: { displayWebpage in
//            if !displayWebpage { url = nil }
//        })) {
//            SafariView(url: url!)
//        }
//    }
//
//}
//
//import SafariServices
//import SwiftUI
//
//struct SafariView: UIViewControllerRepresentable {
//    let url: URL
//
//    func makeUIViewController(context: Context) -> some UIViewController {
//        SFSafariViewController(url: url)
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewControllerType,
//                                context: Context) { }
//}
//
//
//fileprivate struct HTMLText: UIViewRepresentable {
//    @Binding var attributedString: NSAttributedString?
//    @Binding var desiredHeight: CGFloat
//    var linkPressed: ((URL) -> Void)?
//
//    func makeUIView(context: UIViewRepresentableContext<Self>) -> HTMLLabel {
//        HTMLLabel()
//    }
//
//    func updateUIView(_ uiView: HTMLLabel, context: UIViewRepresentableContext<Self>) {
//        guard let attributedString = attributedString else { return }
//        uiView.linkPressed = linkPressed
//        uiView.attributedText = NSMutableAttributedString(attributedString: attributedString)
////            .setBaseFont(baseFont: .)
//            .addingAttributes([.foregroundColor: UIColor.label])
//            .untilPhrase("…")
//            .trimTrailingWhiteSpace()
//        uiView.tintColor = .black
//        uiView.isEditable = false
//
//        DispatchQueue.main.async {
//            let size = uiView.intrinsicContentSize
//            guard size.height != self.desiredHeight else { return }
//            self.desiredHeight = size.height
//        }
//    }
//}
//fileprivate final class HTMLLabel: UITextView {
//    var linkPressed: ((URL) -> Void)?
//
//    private var attributedTextCopy: NSAttributedString?
//
//    convenience init() {
//        self.init(frame: .zero)
//        delegate = self
//        textContainerInset = .zero
//        textContainer.lineFragmentPadding = 0
//        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//    }
//
//    override var intrinsicContentSize: CGSize {
//        systemLayoutSizeFitting(.init(width: frame.width,
//                                      height: UIView.layoutFittingCompressedSize.height),
//                                withHorizontalFittingPriority: .required,
//                                verticalFittingPriority: .fittingSizeLevel)
//    }
//
//    func characterTapped(at tapPoint: CGPoint) -> Int? {
//        guard let attributedText = attributedText else { return nil }
//        let layoutManager = NSLayoutManager()
//        let textStorage = NSTextStorage(attributedString: attributedText)
//        textStorage.addLayoutManager(layoutManager)
//        layoutManager.addTextContainer(textContainer)
//
//        let textBoundingBox = layoutManager.usedRect(for: textContainer)
//        let textContainerOffset = CGPoint(x: (bounds.size.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
//                                          y: (bounds.size.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
//        let locationOfTouchInTextContainer = CGPoint(x: tapPoint.x - textContainerOffset.x,
//                                                     y: tapPoint.y - textContainerOffset.y)
//        return layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
//    }
//}
//
//extension HTMLLabel: UITextViewDelegate {
//    func textView(_ textView: UITextView,
//                  shouldInteractWith URL: URL,
//                  in characterRange: NSRange,
//                  interaction: UITextItemInteraction) -> Bool {
//
//        linkPressed?(URL)
//        return false
//    }
//}
//
//extension NSMutableAttributedString {
//    private var wholeRange: NSRange {
//        .init(location: 0, length: length)
//    }
//
//    func setBaseFont(baseFont: UIFont, preserveFontSizes: Bool = true) -> Self {
//        let baseDescriptor = baseFont.fontDescriptor
//        beginEditing()
//        enumerateAttribute(.font, in: wholeRange, options: []) { object, range, _ in
//            guard let font = object as? UIFont else { return }
//            let traits = font.fontDescriptor.symbolicTraits
//            guard let descriptor = baseDescriptor.withSymbolicTraits(traits) else { return }
//            let newSize = preserveFontSizes ? descriptor.pointSize : baseDescriptor.pointSize
//            let newFont = UIFont(descriptor: descriptor, size: newSize)
//            self.removeAttribute(.font, range: range)
//            self.addAttribute(.font, value: newFont, range: range)
//        }
//        endEditing()
//        return self
//    }
//
//    func addingAttributes(_ attrs: [NSAttributedString.Key: Any],
//                          range: NSRange? = nil) -> Self {
//        addAttributes(attrs, range: range ?? wholeRange)
//        return self
//    }
//}
//extension NSAttributedString {
//    func untilPhrase(_ phrase: String) -> NSAttributedString {
//        guard let range = string.range(of: phrase, options: .backwards) else {
//            return self
//        }
//        let nsRange = NSRange(range, in: string)
//        let length = nsRange.location + nsRange.length
//        return attributedSubstring(from: NSRange(location: 0, length: length))
//    }
//
//    public func trimTrailingWhiteSpace() -> NSAttributedString {
//        let invertedSet = CharacterSet.whitespacesAndNewlines.inverted
//        let endRange = string.utf16.description.rangeOfCharacter(from: invertedSet, options: .backwards)
//        guard let endLocation = endRange?.upperBound else {
//            return NSAttributedString(string: string)
//        }
//        let length = string.utf16.distance(from: string.utf16.startIndex, to: endLocation)
//        let range = NSRange(location: 0, length: length)
//        return attributedSubstring(from: range)
//    }
//}
