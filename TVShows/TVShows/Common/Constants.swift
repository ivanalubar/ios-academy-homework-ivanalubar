//
//  Constants.swift
//  TVShows
//
//  Created by Infinum on 23/07/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

import Foundation

enum Constants {
    
    enum Storyboards {
        static let showDetails = "ShowDetails"
        static let login = "Login"
        static let home = "Home"
        static let addNewEpisode = "AddNewEpisode"
        static let episodeDetails = "EpisodeDetails"
        static let comments = "Comments"
        static let uiImagePicker = "UIImagePicker"
        static let collectionHome = "CollectionViewHome"
    }
    
    enum Controllers {
        static let showDetailsViewConstroller = "ShowDetailsViewController"
        static let loginViewController = "LoginViewController"
        static let addNewEpisodeViewConstroller = "AddNewEpisodeViewController"
        static let episodeDetailsViewConstroller = "EpisodeDetailsViewController"
        static let commentsViewConstroller = "CommentsViewController"
        static let uiImagePickerViewController = "UIImagePickerViewController"
        static let homeViewController = "HomeViewController"
    }
    
    enum AlertMessages {
        static let failMessageTitle = "Failed"
        static let loginFailure = "User can not be logged in"
        static let registrationFaliure = "Registration failed"
        static let getShowsFaliure = "Could not load the list of shows"
        static let getShowDetailsFailure = "Could not load the show details"
        static let addEpisodeFailure = "Could not add the episode"
        static let ok = "ok"
        static let sucessMessageTitle = "Success"
        static let loginSuccess = "You are logged in"
        static let registrationSuccess = "Registration succeeded"
        static let addEpisodeSuccess = "Episode has been successfully added"
        static let deleteFail = "You don't have permission to delete this comment"
    }
    
    enum Images {
        static let passwordHide = "ic-characters-hide"
        static let passwordShow = "ic-hide-password"
        static let checked = "ic-checkbox-filled"
        static let unchecked = "ic-checkbox-empty"
        static let logout = "ic-logout"
        static let navigateBack = "ic-navigate-back"
        static let listview = "ic-listview"
        static let gridview = "ic-gridview"
        static let userPlaceholder1 = "img-placeholder-user1"
        static let userPlaceholder2 = "img-placeholder-user2"
        static let userPlaceholder3 = "img-placeholder-user2"
    }
    
    enum ButtonNames {
        static let cancel = "Cancel"
        static let add = "Add"
        static let username = "Username"
        static let password = "Password"
        static let episodeTitele = "Episode title"
        static let seasonNumber = "Season number"
        static let episodeNumber = "Episode number"
        static let episodeDescription = "Episode description"
    }

}
