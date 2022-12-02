// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Error
  internal static let error = L10n.tr("Localizable", "error")
  /// Featured
  internal static let featured = L10n.tr("Localizable", "featured")
  /// By %@ - %@
  internal static func homeCellSubtitle(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "home_cell_subtitle", String(describing: p1), String(describing: p2))
  }
  /// %i views
  internal static func homeVideoViews(_ p1: Int) -> String {
    return L10n.tr("Localizable", "home_video_views", p1)
  }
  /// Retry
  internal static let retry = L10n.tr("Localizable", "retry")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
