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

struct TranslationService {
    
    // Simple dictionary of translations - all we need for a demo
    private let translations: [String: String] = [
        "hello": "bonjour",
        "goodbye": "au revoir",
        "thank you": "merci",
        "how are you": "comment allez-vous",
        "good morning": "bonjour",
        "good evening": "bonsoir",
        "please": "s'il vous plaît",
        "excuse me": "excusez-moi",
        "sorry": "désolé",
        "yes": "oui",
        "no": "non",
        "cat": "chat",
        "dog": "chien",
        "fish": "poisson",
        "bird": "oiseau",
        "car": "voiture",
        "house": "maison",
        "tree": "arbre",
        "computer": "ordinateur",
        "book": "livre",
        "phone": "téléphone",
        "keyboard": "clavier",
        "mouse": "souris",
    ]
    
    ///Obtain translated french values from associated key english keys
    func translate(text: String, from sourceLanguage: String, to targetLanguage: String) -> String {
        // Only handle English to French for now
        guard sourceLanguage == "en" && targetLanguage == "fr" else {
            return "\(text) [Translation not supported for \(sourceLanguage) to \(targetLanguage)]"
        }
        
        let lowerText = text.lowercased()
        return translations[lowerText] ?? "\(text) [No translation available]"
    }
}
