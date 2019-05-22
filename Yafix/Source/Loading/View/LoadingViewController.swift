//
//  LoadingViewController.swift
//  Yafix
//
//  Created by Артём Зайцев on 27/04/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit
import AviasalesSDK

class LoadingViewController: UIViewController, LoadingView {
    var presenter: LoadingViewPresenter!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    required init(searchInfo: JRSDKSearchInfo) {
        super.init(nibName: nil, bundle: nil)
        presenter = LoadingPresenter(view: self, searchInfo: searchInfo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.handleLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        activityIndicator.stopAnimating()
        super.viewDidDisappear(animated)
    }
    
    func presentSearchResult(searchResult: JRSDKSearchResult) {
        let destVC = SearchResultsViewController(searchResult: searchResult)
        self.navigationController?.pushViewController(destVC, animated: true)
    }
}
