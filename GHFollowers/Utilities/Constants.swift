//
//  Constants.swift
//  GHFollowers
//
//  Created by Mohamed Elbendary on 18/08/2026.
//

import UIKit

enum SFSymbols {
    static let location = UIImage(systemName: "mappin.and.ellipse")
    static let repos = UIImage(systemName: "folder")
    static let gists = UIImage(systemName: "text.alignleft")
    static let followers = UIImage(systemName: "heart")
    static let following = UIImage(systemName: "person.2")
}

enum Images {
    static let placeholder = UIImage(named: "avatar-placeholder")
    static let emptyStateLogo = UIImage(named: "empty-state-logo")
    static let ghLogo = UIImage(named: "gh-logo")
}

enum DeviceTypes {
    private static var currentScreen: UIScreen? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first(where: { $0.activationState == .foregroundActive })?
            .screen
            ?? UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.screen
    }

    enum ScreenSize {
        static var width: CGFloat {
            currentScreen?.bounds.size.width ?? 0
        }
        static var height: CGFloat {
            currentScreen?.bounds.size.height ?? 0
        }
        static var maxLength: CGFloat {
            max(width, height)
        }
        static var minLength: CGFloat {
            min(width, height)
        }
    }

    static var scale: CGFloat {
        UITraitCollection.current.displayScale
    }

    static var nativeScale: CGFloat {
        currentScreen?.nativeScale ?? 1.0
    }

    static let idiom = UIDevice.current.userInterfaceIdiom

    static let isiPhoneSE = idiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone8Standard =
        idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed =
        idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard =
        idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed =
        idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale > scale
    static let isiPhoneX = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr =
        idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad = idiom == .pad && ScreenSize.maxLength >= 1024.0

    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}
