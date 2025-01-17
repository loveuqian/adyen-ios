//
// Copyright (c) 2021 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Adyen
import Foundation

/// Describes any voucher action object.
public protocol AnyVoucherAction {

    /// The Apple wallet pass token.
    var passCreationToken: String? { get }
}
