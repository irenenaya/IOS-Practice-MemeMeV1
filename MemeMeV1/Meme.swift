//
// Struct that holds Meme data

import Foundation
import UIKit

// MARK: - Meme
struct Meme {
    var toptext : String = ""
    var bottomtext : String = ""
    var originalImage : UIImage
    var memedImage : UIImage
}

extension Meme {
    
    static var allMemes = [Meme]()
}
