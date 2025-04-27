//
//  UIImageView+Extension.swift
//  BungaeJangter
//
//  Created by 김학철 on 4/27/25.
//

import UIKit
import Kingfisher

enum CImageCache {
    case year
    case month
    case week
    case day
    case never
    case temporary
    
    var instance: ImageCache {
        switch self {
        case .year:
            let cache = ImageCache(name: "ImageCacheExpYear")
            cache.diskStorage.config.expiration = .days(365) // 1년 만료
            return cache
        case .month:
            let cache = ImageCache(name: "ImageCacheExpMonth")
            cache.diskStorage.config.expiration = .days(30) // 1달 만료
            return cache
        case .week:
            let cache = ImageCache(name: "ImageCacheExpWeek")
            cache.diskStorage.config.expiration = .days(7) // 1주 만료
            return cache
        case .day:
            let cache = ImageCache(name: "ImageCacheExpDay")
            cache.diskStorage.config.expiration = .days(1) // 1일 만료
            return cache
        case .never:
            let cache = ImageCache(name: "ImageCacheExpNever")
            cache.diskStorage.config.expiration = .never
            return cache
            
        case .temporary:
            let cache = ImageCache(name: "ImageCacheExpTemporary")
            cache.diskStorage.config.expiration = .seconds(60 * 60) // 1시간
            return cache
        }
    }
}
extension UIImageView {
    func setImage(_ url: String, placeholder: UIImage? = nil, cache: CImageCache = .week) {
        if let placeholder = placeholder {
            self.image = placeholder
        }
        guard let url = URL(string: url) else {
            return
        }
        self.kf.setImage(with: url, placeholder: placeholder, options: [.targetCache(cache.instance)])
    }
}
