//
//  UIImageView + download.swift
//  Yafix
//
//  Created by Артём Зайцев on 30.07.2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadAndSetupImage(with url: URL, completion: @escaping (_ ok: Bool) -> Void ) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    completion(false)
                    return
                }
            DispatchQueue.main.async() {
                self.image = image
                completion(true)
            }
            }.resume()
    }
}
