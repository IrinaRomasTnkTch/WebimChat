import Foundation
import UIKit

// ChatTableViewController.swift
let documentFileStatusImageViewImage = UIImage.chatImageWith(named: "FileDownloadError") ?? UIImage()
let leadingSwipeActionImage =
    UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ?
        UIImage.chatImageWith(named: "ReplyCircleToTheLeft") ?? UIImage() :
        UIImage.chatImageWith(named: "ReplyCircleToTheLeft")?.flipImage(.horizontally) ?? UIImage()
let trailingSwipeActionImage =
    UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ?
        UIImage.chatImageWith(named: "ReplyCircleToTheLeft")?.flipImage(.horizontally) ?? UIImage() :
        UIImage.chatImageWith(named: "ReplyCircleToTheLeft") ?? UIImage()

// ImageViewController.swift
let saveImageButtonImage = UIImage.chatImageWith(named: "ImageDownload") ?? UIImage()
let fileShare = UIImage.chatImageWith(named: "FileShare") ?? UIImage()


// FlexibleTableViewCell.swift
let documentFileStatusButtonDownloadOperator = UIImage.chatImageWith(named: "FileDownloadButtonOperator") ?? UIImage()
let documentFileStatusButtonDownloadVisitor = UIImage.chatImageWith(named: "FileDownloadButtonVisitor") ?? UIImage()
let documentFileStatusButtonDownloadError = UIImage.chatImageWith(named: "FileDownloadError") ?? UIImage()
let documentFileStatusButtonDownloadSuccessOperator = UIImage.chatImageWith(named: "FileDownloadSuccessOperator") ?? UIImage()
let documentFileStatusButtonDownloadSuccessVisitor = UIImage.chatImageWith(named: "FIleDownloadSeccessVisitor") ?? UIImage()
let documentFileStatusButtonUploadVisitor = UIImage.chatImageWith(named: "FileUploadButtonVisitor.pdf") ?? UIImage()

// PopupActionTableViewCell.swift
let replyImage = UIImage.chatImageWith(named: "ActionReply") ?? UIImage()
let copyImage = UIImage.chatImageWith(named: "ActionCopy") ?? UIImage()
let editImage = UIImage.chatImageWith(named: "ActionEdit") ?? UIImage()
let deleteImage = UIImage.chatImageWith(named: "ActionDelete")?.colour(actionColourDelete) ?? UIImage()

// SurveyRadioButtonViewController.swift
let selectedSurveyPoint = UIImage.chatImageWith(named: "selectedSurveyPoint") ?? UIImage()
let unselectedSurveyPoint = UIImage.chatImageWith(named: "unselectedSurveyPoint") ?? UIImage()
