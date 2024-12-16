//
//  QuoteModel.swift
//  ReligiousAPI
//
//  Created by ADMIN on 13/12/24.
//

import Foundation
struct QuoteModel: Codable{
    let id: Int64
    let religion: String
    let quote: String
    let source: String
}
