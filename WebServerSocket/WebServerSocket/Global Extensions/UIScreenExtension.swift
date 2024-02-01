//
//  UIScreenExtension.swift
//  WebServerSocket
//
//  Created by Tolu Oridota on 1/30/24.
//

import Foundation
import UIKit

extension UIScreen {
    
    var screenHeight: ScreenHeight {
        let height = UIScreen.main.bounds.height
        switch height {
        case _ where height < 812: return .Small
        case _ where (height < 896) && (height >= 812): return .Medium
        case _ where (height >= 896): return .Large
        default: return .Medium
        }
    }
    
    var screenWidth: ScreenWidth {
        let width = UIScreen.main.bounds.width
        switch width {
        case _ where (width >= 414) && (width <= 428):
            return .Large
        case _ where (width > 375) && (width <= 390):
            return .Medium
        case _ where (width < 390):
            return .Small
        default: return .Large
        }
    }
    
    var exactScreenWidth: PrecisionScreenWidth {
        let width = UIScreen.main.bounds.width
        switch width {
        case _ where (width >= 375) && (width < 390):
            return .Small
        case _ where (width >= 390) && (width < 414):
            return .Medium
        case _ where (width >= 414) && (width < 428):
            return .Large
        case _ where (width >= 428) && (width < 430):
            return .ExtraLarge
        case _ where (width >= 430) && (width < 476):
            return .ExtraXLarge
        default: return .ExtraXLarge
        }
    }
    
    var openingNameCharLimit: Int {
        let width = UIScreen.main.bounds.width
        switch width {
        case _ where (width >= 375) && (width < 390):
            //return .Small
            return 32
        case _ where (width >= 390) && (width < 414):
            //return .Medium
            return 34
        case _ where (width >= 414) && (width < 428):
            //return .Large
            return 40
        case _ where (width >= 428) && (width < 430):
            //return .ExtraLarge
            return 40
        case _ where (width >= 430) && (width < 476):
            //return .ExtraXLarge
            return 40
        default: return 40
        }
    }
    
    var iPadScreenWidth: IPadScreenWidth {
        let width = UIScreen.main.bounds.width
        switch width {
        case _ where (width > 834) && (width <= 1024):
            return .ExtraLarge
        case _ where (width > 820) && (width <= 834):
            return .Large
        case _ where (width > 768) && (width <= 820):
            return .Medium
        case _ where (width > 744) && (width <= 768):
            return .Small
        case _ where (width > 0) && (width <= 744):
            return .Small
        default: return .ExtraLarge
        }
    }
    
    var iPadScreenHeight: IPadScreenHeight {
        let height = UIScreen.main.bounds.height
        switch height {
        case _ where (height > 1194) && (height <= 1366):
            return .ExtraLarge
        case _ where (height > 1180) && (height <= 1194):
            return .Large
        case _ where (height > 1080) && (height <= 1180):
            return .Medium
        case _ where (height > 1024) && (height <= 1080):
            return .Small
        case _ where (height > 0) && (height <= 1024):
            return .Mini
        default: return .ExtraLarge
        }
    }
    
    var deviceIdiom: DeviceHardwareType {
        let idiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch idiom {
        case .unspecified: return .iPhone
        case .phone: return .iPhone
        case .pad: return .iPad
        case .tv: return .tvOS
        case .carPlay: return .carPlay
        case .mac: return .mac
        default: return .iPhone
        }
    }
    
    var isLargeScreen: Bool {
        let size = UIScreen.main.screenWidth
        return (size == .Large)
    }
    
    var isMediumScreen: Bool {
        let size = UIScreen.main.screenWidth
        return (size == .Medium)
    }
    
    var isSmallScreen: Bool {
        let size = UIScreen.main.screenWidth
        return (size == .Small)
    }
    
}
