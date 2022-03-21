//
//  QRCodePage.swift
//  QRCodeGenerator
//
//  Created by Delphine on 2022/3/21.
//

import UIKit

class QRCodePage: UIViewController
{
    @IBOutlet weak var collectionView: UICollectionView!
    
    let urlData: [Int: [String: String]] =
        [
            0: ["url": "https://www.google.com/", "websiteName": "Google"],
            1: ["url": "https://www.youtube.com/", "websiteName": "Youtube"],
            2: ["url": "https://zh.wikipedia.org/wiki/Wikipedia:%E9%A6%96%E9%A1%B5", "websiteName": "Wikipedia"],
            3: ["url": "https://tw.yahoo.com/?p=us", "websiteName": "Yahoo"]
        ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    private func generateQRCodeImage(urlPath: String) -> UIImage?
    {
        guard
            let filter = CIFilter(name: "CIQRCodeGenerator"), // 生成QR Code產生器
            let urlData = urlPath.data(using: .ascii) // 將url字串轉成data
        else { return nil }
        
        filter.setValue(urlData, forKey: "inputMessage") // 將data丟進QR Code產生器
        filter.setValue("Q", forKey: "inputCorrectionLevel") // 層級越高，輸出的QR Code黑色紋路會更多
        
        let scaleTransform = CGAffineTransform(scaleX: 10, y: 10) // 放大QRCode圖片，否則會得到模糊的QRCode
        if let ciImage = filter.outputImage?.transformed(by: scaleTransform)
        {
            // outputImage是一張CIImage，轉成UIImage後return出去
            return UIImage(ciImage: ciImage)
        } else {
            return nil
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension QRCodePage: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return urlData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "qrCodeCell", for: indexPath) as? QRCodeCollectionViewCell,
            let data = urlData[indexPath.item],
            let urlPath = data["url"],
            let websiteName = data["websiteName"]
        else { return UICollectionViewCell() }
        
        let qrCodeImage = generateQRCodeImage(urlPath: urlPath)
        cell.qrCodeImageView.image = qrCodeImage
        cell.websiteLabel.text = websiteName
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension QRCodePage: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let screenWidth = UIScreen.main.bounds.size.width
        let spacing: CGFloat = 20 * 3
        let squareWidth = (screenWidth - spacing) / 2
        return CGSize(width: squareWidth, height: squareWidth)
    }
}
