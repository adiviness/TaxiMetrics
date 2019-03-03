//
//  ViewController.swift
//  TaxiMetrics
//
//  Created by Austin Diviness on 2/28/2019.
//  Copyright © 2019 Austin Diviness. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var boroughsTextField: UITextField!;
    @IBOutlet var boroughsPicker: UIPickerView!;

    var boroughsList = ["Manhattan", "Bronx", "Brooklyn", "Moon"];

    override func viewDidLoad() {
        super.viewDidLoad();
        boroughsPicker.isHidden = true;
        self.view.addSubview(boroughsPicker);
        boroughsTextField.text = "blah";
        boroughsTextField.delegate = self;
        boroughsPicker.delegate = self;
        boroughsPicker.dataSource = self;
    }

    // Description:
    //  - sets the number of components (columns) that the picker view has
    // Arguments:
    // - pickerView - the picker view to set the column count for
    // Return Value:
    // - the number of components in the picker view
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1;
    }

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
        return boroughsList.count;
    }

    // Description:
    // - fetches the text for a given for in a picker view's component
    // Arguments:
    // - pickerView - picker view to get item for
    // - row - row in picker view to get text for
    // - component - component to select row from
    // Return Value:
    // - string containing text for the row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return boroughsList[row];
    }

    // Description:
    // - sets associated text field to picker view selection upon user selection
    // Arguments:
    // - pickerView - the picker view that was selected
    // - row - the row index that was selected
    // - component - the component that was selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        boroughsTextField.text = boroughsList[row];
        pickerView.isHidden = true;
    }

    // Description:
    // - overrides handles for text field to display associated picker view instead
    // Arguments:
    // - textField - the text field that's asking if it can be edited
    // Return Value:
    // - false, the text field can't be directly edited
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        boroughsPicker.isHidden = false;
        return false;
    }

}

