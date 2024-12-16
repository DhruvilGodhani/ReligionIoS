//
//  APIManager.swift
//  ReligiousAPI
//
//  Created by ADMIN on 13/12/24.
//

import Foundation
import Alamofire

let url: String = "https://fight-addictions-api.deno.dev/spiritual/quotes/Islam"
func fetchQuotesAF(completionHandler: @escaping(Result<[QuoteModel], Error>) -> Void){
    AF.request(url).responseDecodable(of: [QuoteModel].self){ response in
        switch response.result{
        case .success(let data):
            completionHandler(.success(data))
        case .failure(let error):
            completionHandler(.failure(error))
        }
        
    }
}
//func apiCall(completionHandler: @escaping(Result<[QuoteModel], Error>) -> Void){
//    AF.request("https://fight-addictions-api.deno.dev/spiritual/quotes").responseDecodable(of: [QuoteModel].self){
//        response in
//        switch response.response{
//        case .su
//        }
//    }
//}
