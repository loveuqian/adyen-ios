//
// Copyright (c) 2021 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Foundation
import UIKit

extension UIFont {
    
    /// :nodoc:
    public enum Adyen {

        /// :nodoc:
        public static var barTitle: UIFont {
            UIFont.preferredFont(forTextStyle: .title3).adyen.font(with: .semibold)
        }
        
    }
}
