//
//  String_Exts.swift
//  Peach
//
//  Created by dean on 2019/8/29.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import UIKit
import CommonCrypto

enum HMACAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func toCCHmacAlgorithm() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:
            result = kCCHmacAlgMD5
        case .SHA1:
            result = kCCHmacAlgSHA1
        case .SHA224:
            result = kCCHmacAlgSHA224
        case .SHA256:
            result = kCCHmacAlgSHA256
        case .SHA384:
            result = kCCHmacAlgSHA384
        case .SHA512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func heightForWithFont(font: UIFont, width: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        
        label.sizeToFit()
        return label.frame.height
    }
    func replace(target: String, withString: String) -> String {
        return replacingOccurrences(of: target, with: withString)
    }
    
    func index(from: Int) -> Index {
        return index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[...toIndex])
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    //    func substring(start: Int, end: Int) -> String {
    //        if start < 0 || start > count {
    //            print("start index \(start) out of bounds")
    //            return ""
    //        } else if end < 0 || end > count {
    //            print("end index \(end) out of bounds")
    //            return ""
    //        }
    //        let startIndex = characters.index(self.startIndex, offsetBy: start)
    //        let endIndex = characters.index(self.startIndex, offsetBy: end)
    //        let range = startIndex ..< endIndex
    //
    //        return substring(with: range)
    //    }
    //
    //    func substring(start: Int, location: Int) -> String {
    //        if start < 0 || start > count {
    //            print("start index \(start) out of bounds")
    //            return ""
    //        } else if location < 0 || start + location > count {
    //            print("end index \(start + location) out of bounds")
    //            return ""
    //        }
    //        let startIndex = characters.index(self.startIndex, offsetBy: start)
    //        let endIndex = characters.index(self.startIndex, offsetBy: start + location)
    //        let range = startIndex ..< endIndex
    //
    //        return substring(with: range)
    //    }
    
    static func toJSonString(data: Any) -> String {
        var jsonString = ""
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            
        } catch {
            print(error.localizedDescription)
        }
        
        return jsonString
    }
    
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    
    func endIndex(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    
    func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start ..< endIndex) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start ..< endIndex) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
    
    func getUrls(str: String) -> [String] {
        var urls = [String]()
        
        do {
            let dataDetector = try NSDataDetector(types:
                NSTextCheckingTypes(NSTextCheckingResult.CheckingType.link.rawValue))
            
            let res = dataDetector.matches(in: str,
                                           options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                           range: NSMakeRange(0, str.count))
            
            for checkingRes in res {
                urls.append((str as NSString).substring(with: checkingRes.range))
            }
        } catch {
            print(error)
        }
        return urls
    }
    
    func between(_ left: String, _ right: String) -> String? {
        guard
            let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards),
            left != right && leftRange.upperBound != rightRange.lowerBound
            else { return nil }
        
        return String(self[leftRange.upperBound ... index(before: rightRange.lowerBound)])
    }
    
    func toDate(dateFormat: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        let date: Date? = dateFormatter.date(from: self)
        return date
    }

    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        return self.sizeOfString(usingFont: font).width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        return self.sizeOfString(usingFont: font).height
    }
    
    var stringWidth: CGFloat {
        let constraintRect = CGSize(width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude)
        let boundingBox = self.trimmingCharacters(in: .whitespacesAndNewlines).boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
        return boundingBox.width
    }
    
    var stringHeight: CGFloat {
        let constraintRect = CGSize(width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude)
        let boundingBox = self.trimmingCharacters(in: .whitespacesAndNewlines).boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
        return boundingBox.height
    }
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func isValidateEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        print(emailTest.evaluate(with: self))
        return emailTest.evaluate(with: self)
        
        /*
         Correct but not in use
         這個檢查沒檔字數限制
         
         
         let regex = try! NSRegularExpression(pattern: "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
         "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
         "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
         "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
         "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
         "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
         "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])", options: .caseInsensitive)
         return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
         
         */
        
    }
    func isValidatePassword() -> Bool {
        //        let emailReg = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,8}$"
        //        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailReg)
        //        return emailTest.evaluate(with: text)
        //^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,8}$
        //^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,8}$
        //^([A-Za-z0-9]){5,7}[A-Z]{1,}$
        //^(?=.*[a-z])(?=.*[A-Z]).{6,8}$"
        let regex = try! NSRegularExpression(pattern: "^(?=.*[0-9])(?=.*[a-zA-Z])(?=\\S+$).{6,16}$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    //=====  加解密  =====
    /// AES解密String
    ///
    /// - Parameters:
    ///   - keyData: AES key轉Data值
    ///   - ivData: AES IV轉Data值
    /// - Returns: 解密後的字串
    func decryptAES128By(keyData: NSData, ivData: NSData) -> String {
        guard let encryptData = NSData(base64Encoded: self, options: .init(rawValue: 0)) else {
            print("AES加密字串轉Data失敗")
            return ""
        }
        
        let bufferSize = size_t(encryptData.length + kCCBlockSizeAES128)
        let buffer = malloc(bufferSize)
        var encryptedBytes: size_t = 0
        
        let cryptStatus: CCCryptorStatus = CCCrypt(UInt32(kCCDecrypt), UInt32(kCCAlgorithmAES128), UInt32(kCCOptionPKCS7Padding), keyData.bytes, kCCKeySizeAES128, ivData.bytes, encryptData.bytes, encryptData.length, buffer, bufferSize, &encryptedBytes)
        
        if cryptStatus == kCCSuccess {
            let decryptData = Data(bytes: buffer!, count: encryptedBytes)
            
            free(buffer)
            
            if let decryptString = String(data: decryptData, encoding: .utf8) {
                return decryptString
            } else {
                print("解密Dat轉字串失敗")
                return ""
            }
        } else {
            print("解密失敗：\(cryptStatus)")
            return ""
        }
    }
    
    func hmac(algorithm: HMACAlgorithm, key: String) -> String {
        let cKey = key.cString(using: String.Encoding.utf8)
        let cData = self.cString(using: String.Encoding.utf8)
        var result = [CUnsignedChar](repeating: 0, count: Int(algorithm.digestLength()))
        CCHmac(algorithm.toCCHmacAlgorithm(), cKey!, Int(strlen(cKey!)), cData!, Int(strlen(cData!)), &result)
        let hmacData:NSData = NSData(bytes: result, length: (Int(algorithm.digestLength())))
        let hmacBase64 = hmacData.base64EncodedString(options: [])
        return String(hmacBase64)
    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
            } catch {
                print("ConvertToDictionary fail:\(error.localizedDescription)")
            }
        }
        return nil
    }
}
