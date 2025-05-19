// Copyright 2025 Wayne W Bishop. All rights reserved.
//
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License. You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.

import Vapor
import OpenAPIRuntime
import OpenAPIVapor

// Define a handler that implements the generated protocol
actor HelloHandler: APIProtocol {
    
    private let translationService: TranslationService
       
       init(translationService: TranslationService = TranslationService()) {
           self.translationService = translationService
       }
       
       func translateText(_ input: Operations.translateText.Input) async throws -> Operations.translateText.Output {
           // Extract text from request
           guard case let .json(jsonBody) = input.body else {
               throw Abort(.badRequest)
           }
           
           let textToTranslate = jsonBody.text
           let sourceLanguage = jsonBody.sourceLanguage ?? "en"
           let targetLanguage = jsonBody.targetLanguage ?? "fr"
           
           // Use the translation service
           let translatedText = translationService.translate(
               text: textToTranslate,
               from: sourceLanguage,
               to: targetLanguage
           )
           
           // Create response JSON
           let responseJSON = Operations.translateText.Output.Ok.Body.json(
               .init(
                   original: textToTranslate,
                   translated: translatedText,
                   sourceLanguage: sourceLanguage,
                   targetLanguage: targetLanguage
               )
           )
           
           return .ok(.init(body: responseJSON))
       }
        
    
    func getGreeting(_ input: Operations.getGreeting.Input) async throws -> Operations.getGreeting.Output {
        let bodyContent: String
        
        if let name = input.query.name {
            bodyContent = "Hello, \(name), have a great day!"
        } else {
            bodyContent = "Hello, world!"
        }
        
        let body = HTTPBody(stringLiteral: bodyContent)
        let responseBody = Operations.getGreeting.Output.Ok.Body.plainText(body)
        let okResponse = Operations.getGreeting.Output.Ok(body: responseBody)
        
        return .ok(okResponse)
    }
    
}
