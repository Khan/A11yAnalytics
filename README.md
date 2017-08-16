# A11yAnalytics
A tool to help you understand your users' accessibility needs.

## Overview
Apple provides *wonderful* accessibility tools for users and developers. While every app *should*
support all of iOS' accessibility capabilities, many don't. This tool is intended to help you
advocate for better accessibility support in your products.

To help your team better understand the accessibility needs of your users, this tool bundles up a
`[String: String]` dictionary of accessibility settings for the current user of your app.

In aggregate, this information can help your team advocate to build better accessibility into your
app, or to decide what accessibility efforts you should work on first.

## Usage
You can get accessibility settings with a single line of code:
```swift
import AccessibilityAnalytics

let a11yInfo: [String: String] = AccessibilityAnalytics.currentSettings()

// Whatever analytics tool you use, it probably accepts a [String: String] info for events!
GenericAnalyticsService.shared.reportEvent(named: "accessibility_settings", info: self.analyticsInfo)
```

## Installation
`// TODO (bryan): add Cocoapods / Carthage instructions here`
