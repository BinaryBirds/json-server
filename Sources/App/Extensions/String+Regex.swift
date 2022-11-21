//
//  File.swift
//  
//
//  Created by Viasz-Kádi Ferenc on 2022. 11. 21..
//

import Foundation

extension String {

    func replacingMatches(
        pattern: String,
        replace: (String) -> String?
    ) -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])

            let matches = regex.matches(
                in: self,
                options: [],
                range: NSMakeRange(0, self.count)
            )

            let mutableString = NSMutableString(string: self)
            matches.reversed().forEach { match in
                guard
                    let range = Range(match.range, in: self),
                    let replacement = replace(String(self[range]))
                else { return}

                regex.replaceMatches(
                    in: mutableString,
                    options: .reportCompletion,
                    range: match.range,
                    withTemplate: replacement
                )
            }

            return String(mutableString)
        } catch {
            return self
        }
    }
}
