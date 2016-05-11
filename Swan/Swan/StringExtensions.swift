//
//  StringExtensions.swift
//  Swan
//
//  Created by Antti Laitala on 22/05/15.
//
//

import Foundation

public extension String {

    /// Returns the uppercase representation of this string taking into account the current app locale.
    var upcase: String {
        return uppercaseStringWithLocale(NSLocale.appLocale())
    }
    
    /// Returns the downcase representation of this string taking into account the current app locale.
    var downcase: String {
        return lowercaseStringWithLocale(NSLocale.appLocale())
    }
    
    /// Returns a string object containing the characters of the `String` that lie within a given range.
    subscript(subRange: Range<Int>) -> String {
        return substringWithRange(startIndex.advancedBy(subRange.startIndex)..<startIndex.advancedBy(subRange.endIndex))
    }

    /// Returns a string object containing the characters of the `String` that lie within a given range.
    subscript(subRange: NSRange) -> String {
        return substringWithRange(startIndex.advancedBy(subRange.location)..<startIndex.advancedBy(subRange.location + subRange.length))
    }

    /// Remove the indicated `subRange` of characters.
    ///
    /// Invalidates all indices with respect to `self`.
    ///
    /// - Complexity: O(`self.count`).
    /// - Returns: String that was removed
    mutating func removeRange(subRange: Range<Int>) -> String {
        let removed = self[subRange]
        removeRange(startIndex.advancedBy(subRange.startIndex)..<startIndex.advancedBy(subRange.endIndex))
        return removed
    }
    
}

// MARK: Hashing

/*
public extension String {
    
    func md2() -> String {
        return (self as NSString).digestUsingHashFunction(.MD2)
    }
    
    func md4() -> String {
        return (self as NSString).digestUsingHashFunction(.MD4)
    }
    
    func md5() -> String {
        return (self as NSString).digestUsingHashFunction(.MD5)
    }
    
    func sha1() -> String {
        return (self as NSString).digestUsingHashFunction(.SHA1)
    }
    
    func sha224() -> String {
        return (self as NSString).digestUsingHashFunction(.SHA224)
    }
    
    func sha256() -> String {
        return (self as NSString).digestUsingHashFunction(.SHA256)
    }
    
    func sha384() -> String {
        return (self as NSString).digestUsingHashFunction(.SHA384)
    }
    
    func sha512() -> String {
        return (self as NSString).digestUsingHashFunction(.SHA512)
    }
    
}
*/

// MARK: Regex

public extension String {
    
    func match(pattern: String) throws -> [String] {
        let regexp = try createRegexWithPattern(pattern)
        let matches = regexp.matchesInString(self, options: NSMatchingOptions(), range: NSMakeRange(0, characters.count))
        var results = [String]()
        for match in matches {
            results.append(self[match.range])
        }
        return results
    }
    
    func gsub(pattern: String, replacement: String) throws -> String {
        let regexp = try createRegexWithPattern(pattern)
        return regexp.stringByReplacingMatchesInString(self, options: NSMatchingOptions(), range: NSMakeRange(0, characters.count), withTemplate: replacement)
    }
    
    func gsub(pattern: String, replacementClosure: (String) -> (String)) throws -> String {
        let regexp = try createRegexWithPattern(pattern)
        let matches = regexp.matchesInString(self, options: NSMatchingOptions(), range: NSMakeRange(0, characters.count))
        var result = ""
        var idx = 0
        for match in matches {
            let replacement = replacementClosure(self[match.range])
            // Insert unmodified content.
            result += self[idx..<match.range.location]
            // Replace modified content.
            result += replacement
            idx = match.range.location + match.range.length
        }
        result += self[idx..<characters.count]
        return result
    }

    static private var regexpCache = [String: NSRegularExpression]()

    private func createRegexWithPattern(pattern: String) throws -> NSRegularExpression {
        var regexp: NSRegularExpression? = String.regexpCache[pattern]
        if regexp == nil {
            regexp = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions())
            String.regexpCache[pattern] = regexp
        }
        return regexp!
    }
    
}

