//
//  A11yAnalytics.swift
//  A11yAnalytics
//
//  Created by Bryan Clark on 8/9/17.
//  Copyright © 2017 Khan Academy. All rights reserved.
//

import UIKit

/// A simple-to-query tool for checking what the user's current accessibility settings are.
/// Useful for figuring out what type-size preferences, reduce-motion settings, etc are used.
public class AccessibilityAnalytics: NSObject {

    /// A list of all of the currently-supported accessibility capabilities.
    /// You can find most of these in Apple's documentation here:
    /// https://developer.apple.com/documentation/uikit/accessibility
    public enum Capability {
        case assistiveTouchRunning
        case voiceOverRunning
        case switchControlRunning
        case shakeToUndoEnabled
        case closedCaptioningEnabled
        case boldTextEnabled
        case darkerSystemColorsEnabled
        case grayscaleEnabled
        case guidedAccessEnabled
        case invertColorsEnabled
        case monoAudioEnabled
        case reduceMotionEnabled
        case reduceTransparencyEnabled
        case speakScreenEnabled
        case speakSelectionEnabled

        /// Also known as "Dynamic Type"
        case preferredContentSize

        static let all: [Capability] = [
            .assistiveTouchRunning,
            .voiceOverRunning,
            .switchControlRunning,
            .shakeToUndoEnabled,
            .closedCaptioningEnabled,
            .boldTextEnabled,
            .darkerSystemColorsEnabled,
            .grayscaleEnabled,
            .guidedAccessEnabled,
            .invertColorsEnabled,
            .monoAudioEnabled,
            .reduceMotionEnabled,
            .reduceTransparencyEnabled,
            .speakScreenEnabled,
            .speakSelectionEnabled,
            .preferredContentSize,
        ]

        public enum Kind {
            case audio, interaction, visual
            static let all: [Kind] = [.audio, .interaction, .visual]
        }
    }

    /// Retrieves the current accessibility settings for the user, useful for most analytics tools!
    public static func currentSettings(includeSummary: Bool = true) -> [String: String] {
        // NOTE (bryan): I'd have this as a default parameter for `currentSettings(for:)`
        // but @objc can't understand the [Capability] parameter, hence this implementation.
        return currentSettings(for: Capability.all, includeSummary: includeSummary)
    }

    /// Retrieves the current accessibility settings for the user useful for most analytics tools!
    /// Here, you can specify a subset of capabilities -- for example, if you're only interested
    /// in Dynamic Type, then pass in `[.preferredContentSize]`.
    public static func currentSettings(
        for capabilities: [Capability],
        includeSummary: Bool = true
    ) -> [String: String] {
        let summary = includeSummary
            ? summaryOfAccessibilitySettings()
            : [:]

        let output: [String: String] = capabilities
            .reduce(summary) { (accumulator, capability) in
                var result = accumulator
                result[capability.analyticsKey] = capability.currentValue.analyticsDescription
                return result
            }
        return output
    }

    /// Don't want to report any detailed accessibility settings to your analytics service?
    /// This returns a simple overview, with no specific capabilities mentioned.
    public static func summaryOfAccessibilitySettings() -> [String: String] {
        let capabilities = Capability.all

        // First, let's figure out what audio/interaction/visual settings are used:
        var summary: [String: String] = Capability.Kind.all
            .reduce([:]) { (accumulator, kind) in
                var result = accumulator
                let anyNonDefaultInThisKind = capabilities.reduce(false) { return $0 || ($1.kind == kind && $1.isNonDefault) }
                result[kind.analyticsKey] = anyNonDefaultInThisKind.analyticsDescription
                return result
            }

        // Then we add the "is any capability at all enabled?" value.
        summary[AccessibilityAnalytics.summaryAnythingEnabledKey] = capabilities
            .reduce(false) { $0 || $1.isNonDefault }
            .analyticsDescription

        return summary
    }

    internal static let summaryAnythingEnabledKey = "a11y: anything enabled?"
}

internal extension AccessibilityAnalytics.Capability {
    /// The current value for the accessibility setting.
    var currentValue: AnalyticsDescribable {
        switch self {
        case .assistiveTouchRunning:
            return UIAccessibility.isAssistiveTouchRunning
        case .voiceOverRunning:
            return UIAccessibility.isVoiceOverRunning
        case .switchControlRunning:
            return UIAccessibility.isSwitchControlRunning
        case .shakeToUndoEnabled:
            return UIAccessibility.isShakeToUndoEnabled
        case .closedCaptioningEnabled:
            return UIAccessibility.isClosedCaptioningEnabled
        case .boldTextEnabled:
            return UIAccessibility.isBoldTextEnabled
        case .darkerSystemColorsEnabled:
            return UIAccessibility.isDarkerSystemColorsEnabled
        case .grayscaleEnabled:
            return UIAccessibility.isGrayscaleEnabled
        case .guidedAccessEnabled:
            return UIAccessibility.isGuidedAccessEnabled
        case .invertColorsEnabled:
            return UIAccessibility.isInvertColorsEnabled
        case .monoAudioEnabled:
            return UIAccessibility.isMonoAudioEnabled
        case .reduceMotionEnabled:
            return UIAccessibility.isReduceMotionEnabled
        case .reduceTransparencyEnabled:
            return UIAccessibility.isReduceTransparencyEnabled
        case .speakScreenEnabled:
            return UIAccessibility.isSpeakScreenEnabled
        case .speakSelectionEnabled:
            return UIAccessibility.isSpeakSelectionEnabled

        /// Also known as "Dynamic Type Size"
        case .preferredContentSize:
            return UIApplication.shared.preferredContentSizeCategory
        }
    }

    internal var defaultValue: AnalyticsDescribable {
        switch self {
        case .assistiveTouchRunning:
            return false
        case .voiceOverRunning:
            return false
        case .switchControlRunning:
            return false
        case .shakeToUndoEnabled:
            return true
        case .closedCaptioningEnabled:
            return false
        case .boldTextEnabled:
            return false
        case .darkerSystemColorsEnabled:
            return false
        case .grayscaleEnabled:
            return false
        case .guidedAccessEnabled:
            return false
        case .invertColorsEnabled:
            return false
        case .monoAudioEnabled:
            return false
        case .reduceMotionEnabled:
            return false
        case .reduceTransparencyEnabled:
            return false
        case .speakScreenEnabled:
            return false
        case .speakSelectionEnabled:
            return false
        case .preferredContentSize:
            return UIContentSizeCategory.large
        }
    }

    internal var analyticsKey: String {
        switch self {
        case .assistiveTouchRunning:
            return "assistiveTouchEnabled"
        case .voiceOverRunning:
            return "voiceOverEnabled"
        case .switchControlRunning:
            return "switchControlEnabled"
        case .shakeToUndoEnabled:
            return "shakeToUndoEnabled"
        case .closedCaptioningEnabled:
            return "closedCaptioningEnabled"
        case .boldTextEnabled:
            return "boldTextEnabled"
        case .darkerSystemColorsEnabled:
            return "darkerSystemColorsEnabled"
        case .grayscaleEnabled:
            return "grayscaleEnabled"
        case .guidedAccessEnabled:
            return "guidedAccessEnabled"
        case .invertColorsEnabled:
            return "invertColorsEnabled"
        case .monoAudioEnabled:
            return "monoAudioEnabled"
        case .reduceMotionEnabled:
            return "reduceMotionEnabled"
        case .reduceTransparencyEnabled:
            return "reduceTransparencyEnabled"
        case .speakScreenEnabled:
            return "speakScreenEnabled"
        case .speakSelectionEnabled:
            return "speakSelectionEnabled"
        case .preferredContentSize:
            return "preferredContentSize"
        }
    }

    internal var kind: AccessibilityAnalytics.Capability.Kind {
        switch self {
        case .assistiveTouchRunning:
            return .interaction
        case .boldTextEnabled:
            return .visual
        case .closedCaptioningEnabled:
            return .audio
        case .darkerSystemColorsEnabled:
            return .visual
        case .grayscaleEnabled:
            return .visual
        case .guidedAccessEnabled:
            return .interaction
        case .invertColorsEnabled:
            return .visual
        case .monoAudioEnabled:
            return .audio
        case .preferredContentSize:
            return .visual
        case .reduceMotionEnabled:
            return .visual
        case .reduceTransparencyEnabled:
            return .visual
        case .shakeToUndoEnabled:
            return .interaction
        case .speakScreenEnabled:
            return .interaction
        case .speakSelectionEnabled:
            return .interaction
        case .switchControlRunning:
            return .interaction
        case .voiceOverRunning:
            return .visual
        }
    }

    /// Whether or not the current value is different than the default value
    internal var isNonDefault: Bool {
        return currentValue.analyticsDescription != defaultValue.analyticsDescription
    }
}

internal extension AccessibilityAnalytics.Capability.Kind {
    internal var analyticsKey: String {
        switch self {
        case .audio: return "a11y: any audio enabled?"
        case .visual: return "a11y: any visual enabled?"
        case .interaction: return "a11y: any interaction enabled?"
        }
    }
}

internal protocol AnalyticsDescribable {
    var analyticsDescription: String { get }
}

extension Bool: AnalyticsDescribable {
    var analyticsDescription: String {
        return self.description
    }
}

extension UIContentSizeCategory: AnalyticsDescribable {
    // The
    var analyticsDescription: String {
        switch self {
        case UIContentSizeCategory.unspecified:
            return "00 unspecified"
        case UIContentSizeCategory.extraSmall:
            return "01 XS extra small (-3)"
        case UIContentSizeCategory.small:
            return "02 S small (-2)"
        case UIContentSizeCategory.medium:
            return "03 M medium (-1)"
        case UIContentSizeCategory.large:
            return "04 L large (default)"
        case UIContentSizeCategory.extraLarge:
            return "05 XL extra large (+1)"
        case UIContentSizeCategory.extraExtraLarge:
            return "06 XXL extra extra large (+2)"
        case UIContentSizeCategory.extraExtraExtraLarge:
            return "07 XXXL extra extra extra large (+3)"
        case UIContentSizeCategory.accessibilityMedium:
            return "08 AX1 accessibility medium (+4)"
        case UIContentSizeCategory.accessibilityLarge:
            return "09 AX2 accessibility large (+5)"
        case UIContentSizeCategory.accessibilityExtraLarge:
            return "10 AX3 accessibility extra large (+6)"
        case UIContentSizeCategory.accessibilityExtraExtraLarge:
            return "11 AX4 accessibility extra large (+7)"
        case UIContentSizeCategory.accessibilityExtraExtraExtraLarge:
            return "12 AX5 accessibility extra extra large (+8)"
        default:
            return "Unknown, please file issue: github.com/khan/a11yAnalytics/issues"
        }
    }
}
