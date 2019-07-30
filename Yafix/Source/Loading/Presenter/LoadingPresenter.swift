//
//  LoadingViewPresenter.swift
//  Yafix
//
//  Created by Артём Зайцев on 27/04/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import Foundation
import AviasalesSDK

protocol LoadingView: class {
    init(searchInfo: JRSDKSearchInfo)
    func presentSearchResult(searchResult: JRSDKSearchResult)
    func jumpToRoot()
}


protocol LoadingViewPresenter {
    init(view: LoadingView, searchInfo: JRSDKSearchInfo)
    func handleLoad()
}


class LoadingPresenter: NSObject, LoadingViewPresenter {
    unowned let view: LoadingView
    let searchInfo: JRSDKSearchInfo
    let searchPerformer: JRSDKSearchPerformer = AviasalesSDK.sharedInstance().createSearchPerformer()
    
    required init(view: LoadingView, searchInfo: JRSDKSearchInfo) {
        self.view = view
        self.searchInfo = searchInfo
    }
    
    func handleLoad() {
        self.searchPerformer.delegate = self
        self.searchPerformer.performSearch(with: self.searchInfo, includeResultsInEnglish: true)
    }
}


extension LoadingPresenter: JRSDKSearchPerformerDelegate {
    func searchPerformer(_ searchPerformer: JRSDKSearchPerformer!, didFinishRegularSearch searchInfo: JRSDKSearchInfo!, with result: JRSDKSearchResult!, andMetropolitanResult metropolitanResult: JRSDKSearchResult!) {
        print("found tickets: ", result.tickets.count)
        self.view.presentSearchResult(searchResult: result)
    }
    
    func searchPerformer(_ searchPerformer: JRSDKSearchPerformer!, didFailSearchWithError error: Error!) {
        print("error, searching tickets: ", error.localizedDescription)
        self.view.jumpToRoot()
    }
    
    func searchPerformer(_ searchPerformer: JRSDKSearchPerformer!, didFinalizeSearchWith searchInfo: JRSDKSearchInfo!, error: Error!) {
        print("did finalize search")
    }
    
    func searchPerformer(_ searchPerformer: JRSDKSearchPerformer!, didFindSomeTickets newTickets: JRSDKSearchResultsChunk!, in searchInfo: JRSDKSearchInfo!, temporaryResult: JRSDKSearchResult!, temporaryMetropolitanResult: JRSDKSearchResult!) {
        print("did find some tickets: ", temporaryResult.tickets.count)
    }
}
