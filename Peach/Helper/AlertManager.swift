//
//  AlertManager.swift
//  Peach
//
//  Created by dean on 2019/10/18.
//  Copyright © 2019 WeOnlyLiveOnce. All rights reserved.
//

import Foundation
import UIKit
import SwiftEntryKit

//class AlertManager {
//    private func showButtonBarMessage(attributes: EKAttributes) {
//        let title = EKProperty.LabelContent(
//            text: "Dear Reader!",
//            style: .init(
//                font: MainFont.medium.with(size: 15),
//                color: .black,
//                displayMode: displayMode
//            )
//        )
//        let description = EKProperty.LabelContent(
//            text: "Get your coupon for a free book now",
//            style: .init(
//                font: MainFont.light.with(size: 13),
//                color: .black,
//                displayMode: displayMode
//            )
//        )
//        let image = EKProperty.ImageContent(
//            imageName: "ic_books",
//            displayMode: displayMode,
//            size: CGSize(width: 35, height: 35),
//            contentMode: .scaleAspectFit
//        )
//        let simpleMessage = EKSimpleMessage(
//            image: image,
//            title: title,
//            description: description
//        )
//        let buttonFont = MainFont.medium.with(size: 16)
//        let closeButtonLabelStyle = EKProperty.LabelStyle(
//            font: buttonFont,
//            color: Color.Gray.a800,
//            displayMode: displayMode
//        )
//        let closeButtonLabel = EKProperty.LabelContent(
//            text: "NOT NOW",
//            style: closeButtonLabelStyle
//        )
//        let closeButton = EKProperty.ButtonContent(
//            label: closeButtonLabel,
//            backgroundColor: .clear,
//            highlightedBackgroundColor: Color.Gray.a800.with(alpha: 0.05)) {
//                SwiftEntryKit.dismiss()
//        }
//        let okButtonLabelStyle = EKProperty.LabelStyle(
//            font: buttonFont,
//            color: Color.Teal.a600,
//            displayMode: displayMode
//        )
//        let okButtonLabel = EKProperty.LabelContent(
//            text: "LET ME HAVE IT",
//            style: okButtonLabelStyle
//        )
//        let okButton = EKProperty.ButtonContent(
//            label: okButtonLabel,
//            backgroundColor: .clear,
//            highlightedBackgroundColor: Color.Teal.a600.with(alpha: 0.05),
//            displayMode: displayMode) { [unowned self] in
//                var attributes = self.dataSource.bottomAlertAttributes
//                attributes.entryBackground = .color(color: Color.Teal.a600)
//                attributes.entranceAnimation = .init(
//                    translate: .init(duration: 0.65, spring: .init(damping: 0.8, initialVelocity: 0))
//                )
//                let image = UIImage(named: "ic_success")!
//                let title = "Congratz!"
//                let description = "Your book coupon is 5w1ft3ntr1k1t"
//                self.showPopupMessage(attributes: attributes,
//                                      title: title,
//                                      titleColor: .white,
//                                      description: description,
//                                      descriptionColor: .white,
//                                      buttonTitleColor: .subText,
//                                      buttonBackgroundColor: .white,
//                                      image: image)
//        }
//        let buttonsBarContent = EKProperty.ButtonBarContent(
//            with: closeButton, okButton,
//            separatorColor: Color.Gray.light,
//            buttonHeight: 60,
//            displayMode: displayMode,
//            expandAnimatedly: true
//        )
//        let alertMessage = EKAlertMessage(
//            simpleMessage: simpleMessage,
//            imagePosition: .left,
//            buttonBarContent: buttonsBarContent
//        )
//        let contentView = EKAlertMessageView(with: alertMessage)
//        var att = EKAttributes()
//        att = attributes
//        att.position = .bottom
//        SwiftEntryKit.display(entry: contentView, using: att)
//    }
//}
