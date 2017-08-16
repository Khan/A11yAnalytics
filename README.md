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

The dictionary that you get back will look like this:

```
[
    "a11y: anything enabled?": "true",
    "a11y: any audio enabled?": "false",
    "a11y: any interaction enabled?": "false",
    "a11y: any visual enabled?": "true",

    "assistiveTouchEnabled": "false",    
    "boldTextEnabled": "true", 
    "closedCaptioningEnabled": "false",
    "darkerSystemColorsEnabled": "false",
    "grayscaleEnabled": "false",
    "guidedAccessEnabled": "false",
    "invertColorsEnabled": "false"
    "monoAudioEnabled": "false",
    "preferredContentSize": "04 L large (default)",
    "reduceMotionEnabled": "false", 
    "reduceTransparencyEnabled": "false", 
    "shakeToUndoEnabled": "true", 
    "speakScreenEnabled": "false",
    "speakSelectionEnabled": "false",
    "switchControlEnabled": "false", 
    "voiceOverEnabled": "false", 
]
```

The summary and the details for each capability are optional. 
For example, if you just want to know the dynamic type size and the summary:

```swift
AccessibilityAnalytics.currentSettings(for: [.preferredContentSize], includeSummary: true)
```


## Installation
`// TODO (bryan): add Cocoapods / Carthage instructions here`
