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
    }
    
    enum Controllers {
        static let showDetailsViewConstroller = "ShowDetailsViewController"
        static let loginViewConstroller = "LoginViewController"
        static let homeViewConstroller = "HomeViewController"
        static let addNewEpisodeViewConstroller = "AddNewEpisodeViewController"
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
    }
    
    enum Images {
        static let passwordHide = "ic-characters-hide"
        static let passwordShow = "ic-hide-password"
        static let checked = "ic-checkbox-filled"
        static let unchecked = "ic-checkbox-empty"
    }
    
    enum ButtonNames {
        static let cancel = "Cancel"
        static let add = "Add"
    }

}
