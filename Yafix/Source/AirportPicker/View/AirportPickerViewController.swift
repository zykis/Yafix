//
//  AirportPickerViewController.swift
//  Yafix
//
//  Created by Артём Зайцев on 02/05/2019.
//  Copyright © 2019 Артём Зайцев. All rights reserved.
//

import UIKit
import AviasalesSDK

class AirportPickerViewController: UIViewController, AirportPickerViewProtocol {
    var presenter: AirportPickerPresenterProtocol!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var closeButon: UIButton!
    @IBOutlet var suggestionLabel: UILabel!
    
    required init(type: AirportType, selection: @escaping (JRSDKAirport) -> Void) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = AirportPickerPresenter(view: self, type: type, selection: selection)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.searchTextField.addTarget(self, action: #selector(AirportPickerViewController.searchTextFieldTextChanged(textField:)), for: .editingChanged)
        self.closeButon.addTarget(self, action: #selector(AirportPickerViewController.dismissAnimated), for: .touchUpInside)
        self.searchTextField.delegate = self
        setTableViewHidden(hidden: true)
        searchTextField.becomeFirstResponder()
    }
    
    @IBAction func clearSearchTextField() {
        searchTextField.text = ""
        searchTextField.becomeFirstResponder()
    }
    
    @objc func searchTextFieldTextChanged(textField: UITextField) {
        self.presenter.set(searchString: textField.text ?? "")
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setTableViewHidden(hidden: Bool) {
        self.tableView.isHidden = hidden
        self.suggestionLabel.isHidden = hidden
    }
}


private extension AirportPickerViewController {
    func setupTableView() {
        let background = UIView(frame: CGRect(x: 0,
                                              y: -480,
                                              width: self.tableView.bounds.width,
                                              height: self.tableView.bounds.height + 480 * 2))
        background.backgroundColor = backgroundColor
        self.tableView.backgroundView = background
        self.tableView.register(UINib(nibName: AirportPickerCell.identifier, bundle: nil), forCellReuseIdentifier: AirportPickerCell.identifier)
    }
}


extension AirportPickerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = self.presenter.viewModelForCell(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: AirportPickerCell.identifier) as! AirportPickerCell
        cell.setup(viewModel: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.numberOfRowsInSection(section: section)
    }
}


extension AirportPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.select(at: indexPath)
    }
}


extension AirportPickerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
