//
//  ProfilePhotoError.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 08.05.2025.
//

import Foundation

enum ProfilePhotoError: Error {
    case userNotFound
    case userDocumentNotFound
    case imageUploadFailed
    case urlRetrievalFailed
    case imageProcessingFailed
    case downloadFailed
    case dataFetchingError(String)

    var localizedDescription: String {
        switch self {
        case .userNotFound:
            return "User not found. Please try again."
        case .userDocumentNotFound:
            return "User document not found."
        case .imageUploadFailed:
            return "Failed to upload image. Please try again later."
        case .urlRetrievalFailed:
            return "Failed to get image URL. Please try again later."
        case .imageProcessingFailed:
            return "Unable to process the image. Please try again later."
        case .dataFetchingError(let message):
            return message
        case .downloadFailed:
            return "Download failed."
        }
    }
}
