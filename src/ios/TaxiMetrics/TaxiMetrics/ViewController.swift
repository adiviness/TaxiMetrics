//
//  ViewController.swift
//  TaxiMetrics
//
//  Created by Austin Diviness on 2/28/2019.
//  Copyright © 2019 Austin Diviness. All rights reserved.
//

import UIKit

// Commentary:
// I'm not happy that I've shoved most everything into a single class here,
// they should at least be pulled out into seperate logical sections.
class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var boroughPickupTextField: UITextField!;
    @IBOutlet var zonePickupTextField: UITextField!;
    @IBOutlet var boroughDropoffTextField: UITextField!;
    @IBOutlet var zoneDropoffTextField: UITextField!;
    @IBOutlet var picker: UIPickerView!;
    @IBOutlet var taxiResultTextField: UITextField!;

    // current picker state
    var activePickerSelectionType: ActivePickerSelectionType = .BoroughPickup;

    var apiData: [String:[String]] = [:];
    let api = ApiInteraction();

    var greenCost = 0.0;
    var yellowCost = 0.0;

    // Description:
    // - these are the the possible states for the data the picker
    // can be referring to.
    enum ActivePickerSelectionType {
        case BoroughPickup
        case BoroughDropoff
        case ZonePickup
        case ZoneDropoff
    };

    override func viewDidLoad() {
        super.viewDidLoad();
        api.queryBoroughs(funcParam: handleBoroughListReceive);

        // set picker up
        picker.isHidden = true;
        picker.delegate = self;
        picker.dataSource = self;

        // set text fields up
        // Commentary: I assume that ios has a way to handle strings in a
        // separate resource file like android. I don't plan of having any
        // translations for this app so I'm not messing with it for now.
        boroughPickupTextField.text = "Select";
        boroughPickupTextField.delegate = self;

        zonePickupTextField.text = "Select";
        zonePickupTextField.delegate = self;

        boroughDropoffTextField.text = "Select";
        boroughDropoffTextField.delegate = self;

        zoneDropoffTextField.text = "Select";
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
            return apiData.keys.count;
        }
        else {
            // TODO query the borough list and pull the zone count out
            //return zonesList.count;
            return 10;
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
            let keys = Array(apiData.keys);
            return keys[row];
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
        switch (activePickerSelectionType) {
        case .BoroughPickup:
            let keys: [String] = Array(apiData.keys);
            boroughPickupTextField.text = keys[row];
            fetchZoneData(borough: keys[row]);
        case .BoroughDropoff:
            let keys: [String] = Array(apiData.keys);
            boroughDropoffTextField.text = keys[row];
            fetchZoneData(borough: keys[row]);
        case .ZonePickup:
            let borough = boroughPickupTextField.text!;
            if (apiData[borough] != nil) {
                zonePickupTextField.text = apiData[borough]?[row];
            }
        case .ZoneDropoff:
            let borough = boroughDropoffTextField.text!;
            if (apiData[borough] != nil) {
                zoneDropoffTextField.text = apiData[borough]?[row];
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
        for item in data {
            apiData[item] = [];
        }
        for item in data {
            print(item);
            fetchZoneData(borough: item);
        }
    }

    // Description:
    // - starts an http api request to get zone listing for a borough
    // Arguments:
    // - borough - borough to get zones for
    func fetchZoneData(borough: String) {
        api.queryZones(borough: borough, funcParam: handleZoneData);
    }

    // Description:
    // - callback for zone api. places data in mapping to be used by picker.
    // - borough - the borough that the zone data is associated with
    // - data - the zone data from the request
    func handleZoneData(borough: String, data: [String]) {
        apiData[borough] = data;
    }

    // Description:
    // - starts api requests to calculate cheapest rides from supplied text fields
    @IBAction
    func buttonClicked(sender: UIButton) {
        let pickup = zonePickupTextField.text!;
        let dropoff = zoneDropoffTextField.text!;
        api.queryRideCost(taxi: "green", pickup: pickup, dropoff: dropoff, funcParam: rideCostContinuation);
    }

    // Description:
    // - continuation from green ride cost api request
    // Arguments:
    // - greenResults - costs of green taxi rides
    func rideCostContinuation(greenResults: [String]) {
        greenCost = 0.0;
        for item in greenResults {
            greenCost += Double(item)!;
        }
        greenCost /= Double(greenResults.count);
        print(greenCost);
        // TODO
    }


}

