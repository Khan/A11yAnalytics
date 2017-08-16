//
//  A11yAnalyticsTests.swift
//  A11yAnalyticsTests
//
//  Created by Bryan Clark on 8/9/17.
//  Copyright © 2017 Khan Academy. All rights reserved.
//

import XCTest
@testable import A11yAnalytics

class A11yAnalyticsTests: XCTestCase {

    /// To make analytics more legible in arbitrary analytics tools,
    /// we want to make sure that the values are alpha-sorted.
    func testDynamicTypeIsAlphabeticallySorted() {
        let dynamicTypeSizes: [UIContentSizeCategory] = [
            .unspecified,
            .extraSmall,
            .small,
            .medium,
            .large,
            .extraLarge,
            .extraExtraLarge,
            .extraExtraExtraLarge,
            .accessibilityMedium,
            .accessibilityLarge,
            .accessibilityExtraLarge,
            .accessibilityExtraExtraLarge,
            .accessibilityExtraExtraExtraLarge,
        ]

        // Let's sort 'em programmatically...
        let analyticsDescriptions = dynamicTypeSizes
            .map { return $0.analyticsDescription }
        let alphaSortedDescriptions = analyticsDescriptions
            .sorted { return $0 < $1 }

        // ...and check that they match the expected order!
        XCTAssertEqual(analyticsDescriptions, alphaSortedDescriptions)
    }

    /// Verifies that Capability.defaultValue is accurate.
    func testDefaultValuesAreCorrect() {
        AccessibilityAnalytics.Capability.all
            .forEach { capability in
                let defaultDescription: String
                switch capability {

                // Default value is `false`
                case .assistiveTouchRunning,
                     .boldTextEnabled,
                     .closedCaptioningEnabled,
                     .darkerSystemColorsEnabled,
                     .grayscaleEnabled,
                     .guidedAccessEnabled,
                     .invertColorsEnabled,
                     .monoAudioEnabled,
                     .reduceMotionEnabled,
                     .reduceTransparencyEnabled,
                     .speakScreenEnabled,
                     .speakSelectionEnabled,
                     .switchControlRunning,
                     .voiceOverRunning:
                    defaultDescription = false.analyticsDescription

                // Default value is `true`
                case .shakeToUndoEnabled:
                    defaultDescription = true.analyticsDescription

                // Other
                case .preferredContentSize:
                    defaultDescription = UIContentSizeCategory.large.analyticsDescription
                }
                XCTAssertEqual(defaultDescription, capability.defaultValue.analyticsDescription)
            }
    }
    
}
