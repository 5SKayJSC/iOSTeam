//
//  ExpandableLabel.swift
//  5SKayBaseSwift
//
//  Created by Quynh Nguyen on 10/14/17.
//  Copyright © 2017 5SKay JSC. All rights reserved.
//


typealias LineIndexTuple = (line: CTLine, index: Int)

import UIKit

/**
 * The delegate of ExpandableLabel.
 */
public protocol ExpandableLabelDelegate : NSObjectProtocol {
    func willExpandLabel(_ label: ExpandableLabel)
    func didExpandLabel(_ label: ExpandableLabel)
    func shouldExpandLabel(_ label: ExpandableLabel) -> Bool
    
    func willCollapseLabel(_ label: ExpandableLabel)
    func didCollapseLabel(_ label: ExpandableLabel)
    func shouldCollapseLabel(_ label: ExpandableLabel) -> Bool
}

extension ExpandableLabelDelegate {
    public func shouldExpandLabel(_ label: ExpandableLabel) -> Bool {
        return Static.DefaultShouldExpandValue
    }
    public func shouldCollapseLabel(_ label: ExpandableLabel) -> Bool {
        return Static.DefaultShouldCollapseValue
    }
    public func willCollapseLabel(_ label: ExpandableLabel) {}
    public func didCollapseLabel(_ label: ExpandableLabel) {}
}

private struct Static {
    fileprivate static let DefaultShouldExpandValue : Bool = true
    fileprivate static let DefaultShouldCollapseValue : Bool = false
}

/**
 * ExpandableLabel
 */
open class ExpandableLabel : UILabel {
    
    /// The delegate of ExpandableLabel
    weak open var delegate: ExpandableLabelDelegate?
    
    /// Set 'true' if the label should be collapsed or 'false' for expanded.
    @IBInspectable open var collapsed : Bool = true {
        didSet {
            super.attributedText = (collapsed) ? self.collapsedText : self.expandedText
            super.numberOfLines = (collapsed) ? self.collapsedNumberOfLines : 0
        }
    }
    
    /// Set the link name (and attributes) that is shown when collapsed.
    /// The default value is "More". Cannot be nil.
    @IBInspectable open var collapsedAttributedLink : NSAttributedString! {
        didSet {
            self.collapsedAttributedLink = collapsedAttributedLink.copyWithAddedFontAttribute(font)
        }
    }
    
    /// Set the link name (and attributes) that is shown when expanded.
    /// The default value is "Less". Can be nil.
    @IBInspectable open var expandedAttributedLink : NSAttributedString?
    
    
    
    /// Set the ellipsis that appears just after the text and before the link.
    /// The default value is "...". Can be nil.
    open var ellipsis : NSAttributedString?{
        didSet {
            self.ellipsis = ellipsis?.copyWithAddedFontAttribute(font)
        }
    }
    
    
    //
    // MARK: Private
    //
    
    fileprivate var expandedText : NSAttributedString?
    fileprivate var collapsedText : NSAttributedString?
    fileprivate var linkHighlighted : Bool = false
    fileprivate let touchSize = CGSize(width: 44, height: 44)
    fileprivate var linkRect : CGRect?
    fileprivate var collapsedNumberOfLines : NSInteger = 0
    fileprivate var expandedLinkPosition: NSTextAlignment?
    
    open override var numberOfLines: NSInteger {
        didSet {
            collapsedNumberOfLines = numberOfLines
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    fileprivate func commonInit() {
        isUserInteractionEnabled = true
        lineBreakMode = NSLineBreakMode.byClipping
        numberOfLines = 3
        expandedAttributedLink = nil
        collapsedAttributedLink = NSAttributedString(string: "Read More", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: font.pointSize)])
        ellipsis = NSAttributedString(string: "...")
    }
    
    open override var text: String? {
        set(text) {
            if let text = text {
                expandedText = getExpandedTextForText(text, link: expandedAttributedLink)?.copyWithAddedFontAttribute(font)
                self.attributedText = NSAttributedString(string: text)
            } else {
                self.attributedText = nil
            }
        }
        get {
            return self.attributedText?.string
        }
    }
    
    open override var attributedText: NSAttributedString? {
        set(attributedText) {
            if let attributedText = attributedText, attributedText.length > 0 {
                self.collapsedText = getCollapsedTextForText(attributedText, link: (linkHighlighted) ? collapsedAttributedLink.copyWithHighlightedColor() : collapsedAttributedLink)
                super.attributedText = (self.collapsed) ? self.collapsedText : self.expandedText;
            } else {
                super.attributedText = nil
            }
        }
        get {
            return super.attributedText
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        attributedText = expandedText
    }
    
    fileprivate func textWithLinkReplacement(_ lineIndex : LineIndexTuple, text : NSAttributedString, linkName : NSAttributedString) -> NSAttributedString {
        let lineText = text.textForLine(lineIndex.line)
        var lineTextWithLink = lineText
        (lineText.string as NSString).enumerateSubstrings(in: NSMakeRange(0, lineText.length), options: [.byWords, .reverse]) { (word, subRange, enclosingRange, stop) -> () in
            let lineTextWithLastWordRemoved = lineText.attributedSubstring(from: NSMakeRange(0, subRange.location))
            let lineTextWithAddedLink = NSMutableAttributedString(attributedString: lineTextWithLastWordRemoved)
            if let ellipsis = self.ellipsis {
                lineTextWithAddedLink.append(ellipsis)
                lineTextWithAddedLink.append(NSAttributedString(string: " ", attributes: [NSFontAttributeName : self.font]))
            }
            lineTextWithAddedLink.append(linkName)
            let fits = self.textFitsWidth(lineTextWithAddedLink)
            if (fits == true) {
                lineTextWithLink = lineTextWithAddedLink
                let lineTextWithLastWordRemovedRect = lineTextWithLastWordRemoved.boundingRectForWidth(self.frame.size.width)
                let wordRect = linkName.boundingRectForWidth(self.frame.size.width)
                let width = lineTextWithLastWordRemoved.string == "" ? self.frame.width : wordRect.size.width
                self.linkRect = CGRect(x: lineTextWithLastWordRemovedRect.size.width, y: self.font.lineHeight * CGFloat(lineIndex.index), width: width, height: wordRect.size.height)
                stop.pointee = true
            }
        }
        return lineTextWithLink
    }
    
    fileprivate func getCollapsedTextForText(_ text : NSAttributedString?, link: NSAttributedString) -> NSAttributedString? {
        guard let text = text else { return nil }
        let lines = text.linesForWidth(frame.size.width)
        if (collapsedNumberOfLines > 0 && collapsedNumberOfLines < lines.count) {
            let lastLineRef = lines[collapsedNumberOfLines-1] as CTLine
            let lineIndex = findLineWithWords(lastLine: lastLineRef, text: text, lines: lines)
            let modifiedLastLineText = textWithLinkReplacement(lineIndex, text: text, linkName: link)
            let collapsedLines = NSMutableAttributedString()
            let differenceFromStart = (collapsedNumberOfLines-1) - lineIndex.index
            let emptyLineIndent = (2 + differenceFromStart)
            if collapsedNumberOfLines-emptyLineIndent > 0 {
                for index in 0...collapsedNumberOfLines-emptyLineIndent  {
                    collapsedLines.append(text.textForLine(lines[index]))
                }
            } else {
                collapsedLines.append(text.textForLine(lines[0]))
            }
            collapsedLines.append(modifiedLastLineText)
            return collapsedLines
        }
        return text
    }
    
    
    fileprivate func findLineWithWords(lastLine: CTLine, text: NSAttributedString, lines: [CTLine]) -> LineIndexTuple {
        var lastLineRef = lastLine
        var lastLineIndex = collapsedNumberOfLines - 1
        var lineWords = spiltInToWords(str: text.textForLine(lastLineRef).string as NSString)
        while lineWords.count < 2 && lastLineIndex > 0 {
            lastLineIndex -=  1
            lastLineRef = lines[lastLineIndex] as CTLine
            lineWords = spiltInToWords(str: text.textForLine(lastLineRef).string as NSString)
        }
        return (lastLineRef, lastLineIndex)
    }
    
    fileprivate func spiltInToWords(str: NSString) -> [String] {
        var strings: [String] = []
        str.enumerateSubstrings(in: NSMakeRange(0, str.length), options: [.byWords, .reverse]) { (word, subRange, enclosingRange, stop) -> () in
            if let unwrappedWord = word {
                strings.append(unwrappedWord)
            }
            if strings.count > 1 { stop.pointee = true }
        }
        return strings
    }
    
    fileprivate func textFitsWidth(_ text : NSAttributedString) -> Bool {
        return (text.boundingRectForWidth(frame.size.width).size.height <= font.lineHeight) as Bool
    }
    
    fileprivate func textWillBeTruncated(_ text : NSAttributedString) -> Bool {
        let lines = text.linesForWidth(frame.size.width)
        return collapsedNumberOfLines > 0 && collapsedNumberOfLines < lines.count
    }
    
    // MARK: Touch Handling
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setLinkHighlighted(touches, event: event, highlighted: true)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        setLinkHighlighted(touches, event: event, highlighted: false)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !collapsed {
            if shouldCollapse() {
                delegate?.willCollapseLabel(self)
                collapsed = true
                delegate?.didCollapseLabel(self)
                linkHighlighted = isHighlighted
                setNeedsDisplay()
            }
        }else{
            if shouldExpand() && setLinkHighlighted(touches, event: event, highlighted: false) {
                delegate?.willExpandLabel(self)
                collapsed = false
                delegate?.didExpandLabel(self)
            }
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        setLinkHighlighted(touches, event: event, highlighted: false)
    }
    
    @discardableResult fileprivate func setLinkHighlighted(_ touches: Set<UITouch>?, event: UIEvent?, highlighted : Bool) -> Bool {
        let touch = event?.allTouches?.first
        let location = touch?.location(in: self)
        if let location = location, let linkRect = linkRect {
            let finger = CGRect(x: location.x-touchSize.width/2, y: location.y-touchSize.height/2, width: touchSize.width, height: touchSize.height);
            if collapsed && finger.intersects(linkRect) {
                linkHighlighted = highlighted
                setNeedsDisplay()
                return true
            }
        }
        return false
    }
    
    fileprivate func shouldCollapse() -> Bool {
        return delegate?.shouldCollapseLabel(self) ?? Static.DefaultShouldCollapseValue
    }
    
    fileprivate func shouldExpand() -> Bool {
        return delegate?.shouldExpandLabel(self) ?? Static.DefaultShouldExpandValue
    }
}

extension ExpandableLabel {
    
    fileprivate func getExpandedTextForText(_ text : String?, link: NSAttributedString?) -> NSAttributedString? {
        guard let text = text else { return nil }
        let expandedText = NSMutableAttributedString()
        expandedText.append(NSAttributedString(string: "\(text)", attributes: [ NSFontAttributeName : font]))
        if let link = link, textWillBeTruncated(expandedText) {
            let spaceOrNewLine = expandedLinkPosition == nil ? "  " : "\n"
            expandedText.append(NSMutableAttributedString(string: "\(spaceOrNewLine)\(link.string)", attributes: link.attributes(at: 0, effectiveRange: nil)))
        }
        
        return expandedText
    }
    
    func setLessLinkWith(lessLink: String, attributes: [String: AnyObject], position: NSTextAlignment?) {
        var alignedattributes = attributes
        if let pos = position {
            expandedLinkPosition = pos
            let titleParagraphStyle = NSMutableParagraphStyle()
            titleParagraphStyle.alignment = pos
            alignedattributes[NSParagraphStyleAttributeName] = titleParagraphStyle
            
        }
        expandedAttributedLink = NSMutableAttributedString(string: lessLink,
                                                           attributes: alignedattributes)
    }
    
}

// MARK: Convenience Methods

private extension NSAttributedString {
    func hasFontAttribute() -> Bool {
        if self.length > 0 {
            let font = self.attribute(NSFontAttributeName, at: 0, effectiveRange: nil) as? UIFont
            return font != nil
        }
        
        return false
    }
    
    func copyWithAddedFontAttribute(_ font : UIFont) -> NSAttributedString {
        if (hasFontAttribute() == false) {
            let copy = NSMutableAttributedString(attributedString: self)
            copy.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, copy.length))
            return copy
        }
        return self.copy() as! NSAttributedString
    }
    
    func copyWithHighlightedColor() -> NSAttributedString {
        let alphaComponent = CGFloat(0.5)
        var baseColor: UIColor? = self.attribute(NSForegroundColorAttributeName, at: 0, effectiveRange: nil) as? UIColor
        if let color = baseColor { baseColor = color.withAlphaComponent(alphaComponent) }
        else { baseColor = UIColor.black.withAlphaComponent(alphaComponent) }
        let highlightedCopy = NSMutableAttributedString(attributedString: self)
        highlightedCopy.removeAttribute(NSForegroundColorAttributeName, range: NSMakeRange(0, highlightedCopy.length))
        highlightedCopy.addAttribute(NSForegroundColorAttributeName, value: baseColor!, range: NSMakeRange(0, highlightedCopy.length))
        return highlightedCopy
    }
    
    func linesForWidth(_ width : CGFloat) -> Array<CTLine> {
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT)))
        let frameSetterRef : CTFramesetter = CTFramesetterCreateWithAttributedString(self as CFAttributedString)
        let frameRef : CTFrame = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, 0), path.cgPath, nil)
        
        let linesNS: NSArray  = CTFrameGetLines(frameRef)
        let linesAO: [AnyObject] = linesNS as [AnyObject]
        let lines: [CTLine] = linesAO as! [CTLine]
        
        return lines
    }
    
    func textForLine(_ lineRef : CTLine) -> NSAttributedString {
        let lineRangeRef : CFRange = CTLineGetStringRange(lineRef)
        let range : NSRange = NSMakeRange(lineRangeRef.location, lineRangeRef.length)
        return self.attributedSubstring(from: range)
    }
    
    func boundingRectForWidth(_ width : CGFloat) -> CGRect {
        return self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)),
                                 options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
    }
}

