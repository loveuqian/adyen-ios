//
// Copyright (c) 2021 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Foundation

/// Describes an action in which an EContext Stores voucher is presented to the shopper.
public class EContextStoresVoucherAction: GenericVoucherAction {

    /// Masked shopper telephone number.
    public let maskedTelephoneNumber: String

    /// :nodoc:
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        maskedTelephoneNumber = try container.decode(String.self, forKey: .maskedTelephoneNumber)
        try super.init(from: decoder)
    }

    /// :nodoc:
    private enum CodingKeys: String, CodingKey {
        case maskedTelephoneNumber
    }
}
