//
//  ProfileViewModel.swift
//  eCommerceApp
//
//  Created by chvck on 7.10.2024.
//

import Foundation
import RxSwift

class ProfileViewModel {
    
    var repo = Repository()
    var currentUser: BehaviorSubject<User?> = BehaviorSubject(value: nil)
    
    init(){
        currentUser = repo.currentUser
    }
    
    func logout(){
        repo.logout()
    }
    
    func fetchCurrentUserData(){
        repo.fetchCurrentUserData()
    }
    
}
