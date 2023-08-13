//
//  ViewController.swift
//  SlotPickerView
//
//  Created by Cem Olcay on 8/13/23.
//

import UIKit

class ViewController: UIViewController, SlotPickerViewDelegate {
    let slotPicker = SlotPickerView()
    let slotDisplay = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(slotPicker)
        slotPicker.delegate = self
        slotPicker.translatesAutoresizingMaskIntoConstraints = false
        slotPicker.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        slotPicker.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        slotPicker.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        slotPicker.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        slotPicker.addSubview(slotDisplay)
        slotDisplay.axis = .horizontal
        slotDisplay.spacing = 0
        slotDisplay.alignment = .fill
        slotDisplay.distribution = .fillEqually
        slotDisplay.translatesAutoresizingMaskIntoConstraints = false
        slotPicker.leftAnchor.constraint(equalTo: slotDisplay.leftAnchor).isActive = true
        slotPicker.rightAnchor.constraint(equalTo: slotDisplay.rightAnchor).isActive = true
        slotPicker.topAnchor.constraint(equalTo: slotDisplay.topAnchor).isActive = true
        slotPicker.bottomAnchor.constraint(equalTo: slotDisplay.bottomAnchor).isActive = true
        
        slotPicker.slotCount = 50
        for i in 0..<slotPicker.slotCount {
            let view = UIView()
            view.backgroundColor = .gray
            view.tag = i
            //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(tap:))))
            view.layer.borderColor = UIColor.darkGray.cgColor
            view.layer.borderWidth = 0.5
            slotDisplay.addArrangedSubview(view)
        }
    }
    
    func slotPickerViewDidPickSlot(_ slotPickerView: SlotPickerView) {
        slotDisplay.arrangedSubviews.forEach({ $0.backgroundColor = .gray })
        for slot in slotPickerView.pickedSlots {
            for i in slot.startIndex...slot.endIndex {
                if slotDisplay.arrangedSubviews.indices.contains(i) {
                    slotDisplay.arrangedSubviews[i].backgroundColor = .red
                }
            }
        }
    }
    
    @IBAction func didTap(tap: UITapGestureRecognizer) {
        print("tap \(tap.view!.tag)")
    }
}
