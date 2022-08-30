//
//  UIImageViewExtensions.swift
//  OrderFood
//
//  Created by ThanhThuy on 09/08/2022.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImage (from url:URL) {
        contentMode = .scaleToFill
        let dataTask = URLSession.shared.dataTask(with: url, completionHandler: {
            (data,  response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  let mimeType = response?.mimeType,mimeType.hasPrefix("image"),
                  let data = data , error == nil,
                    let image = UIImage(data: data)
                    else {
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }

        })
        dataTask.resume()
    }
}
