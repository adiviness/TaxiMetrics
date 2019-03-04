//
//  ViewController.swift
//  TaxiMetrics
//
//  Created by Austin Diviness on 2/28/2019.
//  Copyright © 2019 Austin Diviness. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var boroughPickupTextField: UITextField!;
    @IBOutlet var zonePickupTextField: UITextField!;
    @IBOutlet var boroughDropoffTextField: UITextField!;
    @IBOutlet var zoneDropoffTextField: UITextField!;
    @IBOutlet var picker: UIPickerView!;

    var boroughsList = ["Manhattan", "Bronx", "Brooklyn", "Moon"];
    var zonesList = ["Astoria", "Chinatown", "Seattle", "Denver"];
    var activePickerSelectionType: ActivePickerSelectionType = .BoroughPickup;

    var apiData: [String:[String]] = [:];
    let api = ApiInteraction();

    enum ActivePickerSelectionType {
        case BoroughPickup
        case BoroughDropoff
        case ZonePickup
        case ZoneDropoff
    };

    override func viewDidLoad() {
        super.viewDidLoad();
        api.queryBoroughs(funcParam: handleBoroughListReceive);

        picker.isHidden = true;
        picker.delegate = self;
        picker.dataSource = self;

        boroughPickupTextField.text = "blah";
        boroughPickupTextField.delegate = self;

        zonePickupTextField.text = "zone pickup";
        zonePickupTextField.delegate = self;

        boroughDropoffTextField.text = "borough dropoff";
        boroughDropoffTextField.delegate = self;

        zoneDropoffTextField.text = "zone dropoff";
        zoneDropoffTextField.delegate = self;
    }

    // Description:
    //  - sets the number of components (columns) that the picker view has
    // Arguments:
    // - pickerView - the picker view to set the column count for
    // Return Value:
    // - the number of components in the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }

    // Description:
    // - sets the number of rows in a component of a picker view
    // Arguments:
    // - pickerView - the picker view to set
    // - component - the component in the picker view to set
    // Return Value:
    // - the number of row in a component of the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (activePickerSelectionType == .BoroughPickup ||
            activePickerSelectionType == .BoroughDropoff) {
            return boroughsList.count;
        }
        else {
            return zonesList.count;
        }
    }

    // Description:
    // - fetches the text for a given for in a picker view's component.
    // - selects text base on what the active select type for the picker is
    // Arguments:
    // - pickerView - picker view to get item for
    // - row - row in picker view to get text for
    // - component - component to select row from
    // Return Value:
    // - string containing text for the row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (activePickerSelectionType == .BoroughPickup ||
            activePickerSelectionType == .BoroughDropoff) {
            return boroughsList[row];
        }
        else if (activePickerSelectionType == .ZonePickup) {
            let borough = boroughPickupTextField.text!;
            if (apiData[borough] != nil) {
                return apiData[borough]?[row];
            }
            else {
                return "";
            }
        }
        else {
            let borough = boroughDropoffTextField.text!;
            if (apiData[borough] != nil) {
                return apiData[borough]?[row];
            }
            else {
                return "";
            }
        }
    }

    // Description:
    // - sets associated text field to picker view selection upon user selection.
    // Arguments:
    // - pickerView - the picker view that was selected
    // - row - the row index that was selected
    // - component - the component that was selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("picked");
        switch (activePickerSelectionType) {
        case .BoroughPickup:
            boroughPickupTextField.text = boroughsList[row];
            fetchZoneData(borough: boroughsList[row]);
        case .BoroughDropoff:
            boroughDropoffTextField.text = boroughsList[row];
            fetchZoneData(borough: boroughsList[row]);
        case .ZonePickup:
            let borough = boroughPickupTextField.text!;
            if (apiData[borough] != nil) {
                zonePickupTextField.text = apiData[borough]?[row];
            }
        case .ZoneDropoff:
            let borough = boroughDropoffTextField.text!;
            if (apiData[borough] != nil) {
                zoneDropoffTextField.text = zonesList[row];
            }
        };
        pickerView.isHidden = true;
    }

    // Description:
    // - overrides handles for text field to display associated picker view instead.
    // - changes active picker selection type and reload picker data.
    // - allow picker to be shown.
    // Arguments:
    // - textField - the text field that's asking if it can be edited
    // Return Value:
    // - false, the text field can't be directly edited
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField === boroughPickupTextField) {
            activePickerSelectionType = .BoroughPickup
        }
        else if (textField === boroughDropoffTextField) {
            activePickerSelectionType = .BoroughDropoff;
        }
        else if (textField === zonePickupTextField) {
            activePickerSelectionType = .ZonePickup;
        }
        else if (textField === zoneDropoffTextField) {
            activePickerSelectionType = .ZoneDropoff;
        }
        else {
            // TODO error here
            print("error!");
        }
        picker.reloadAllComponents();
        picker.isHidden = false;
        return false;
    }

    // Description:
    // - replaces all data in boroughsList with data and continues api call chain
    // Arguments:
    // - data - data to fill boroughsList with
    func handleBoroughListReceive(data: [String]) {
        boroughsList = data;
        for item in data {
            apiData[item] = [];
        }
        for item in data {
            print(item);
            fetchZoneData(borough: item);
        }
    }

    func fetchZoneData(borough: String) {
        api.queryZones(borough: borough, funcParam: handleZoneData);
    }

    func handleZoneData(borough: String, data: [String]) {
        apiData[borough] = data;
        print ("here: \(borough)");
    }

}

