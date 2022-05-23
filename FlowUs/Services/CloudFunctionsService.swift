//
//  CloudFunctionsService.swift
//  FlowUs
//
//  Created by Lucas Goldner on 12.05.22.
//

import Firebase
import Foundation

class CloudFunctionsService {
    let defaultRegion: String = "europe-west1"
    private lazy var functions = Functions.functions(region: defaultRegion)
    static let instance = CloudFunctionsService()

    init() {}

    func getHelloWorld() {
        print("Called")
        functions.httpsCallable("helloWorld").call { result, error in
            if let error = error as NSError? {
                print(error)
            }
            if let data = result?.data as? [String: Any],
               let text = data["message"] as? String
            {
                print(text)
            }
        }
    }
}
