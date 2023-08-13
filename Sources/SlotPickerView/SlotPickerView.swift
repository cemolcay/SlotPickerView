// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public protocol SlotPickerViewDelegate: AnyObject {
    func slotPickerViewDidPickSlot(_ slotPickerView: SlotPickerView)
}

public struct SlotItemData: Identifiable {
    public var startIndex: Int
    public var endIndex: Int
    public var id: UUID
    
    public var length: Int {
        return (endIndex - startIndex) + 1
    }
    
    public init(startIndex: Int, endIndex: Int) {
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.id = UUID()
    }
    
    public func collides(with other: SlotItemData) -> Bool {
        let c1 = (other.startIndex >= startIndex && other.startIndex <= endIndex)
        let c2 = other.endIndex <= endIndex && startIndex <= other.endIndex
        return c1 || c2
    }
}

public class SlotPickerView: UIView {
    public var slotCount: Int = 0
    public var pickedSlots: [SlotItemData] = []
    public var delegate: SlotPickerViewDelegate?
    
    private var startIndex: Int?
    private var currentIndex: Int?
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard slotCount > 0, currentIndex == nil,
        let location = touches.first?.location(in: self) else { return }
        let slotWidth = frame.size.width / CGFloat(slotCount)
        let index = min(Int(location.x / slotWidth), (slotCount - 1))
        
        currentIndex = index
        startIndex = index
        let pickingSlot = SlotItemData(
            startIndex: min(startIndex!, currentIndex!),
            endIndex: max(startIndex!, currentIndex!))
        
        pickedSlots.append(pickingSlot)
        removeCollisions(for: pickingSlot)
        
        delegate?.slotPickerViewDidPickSlot(self)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard slotCount > 0, currentIndex != nil, pickedSlots.last != nil,
        let location = touches.first?.location(in: self) else { return }
        let slotWidth = frame.size.width / CGFloat(slotCount)
        let index = min(Int(location.x / slotWidth), (slotCount - 1))
        guard index != currentIndex else { return }
        currentIndex = index
        
        pickedSlots[pickedSlots.count - 1].startIndex = min(startIndex!, currentIndex!)
        pickedSlots[pickedSlots.count - 1].endIndex = max(startIndex!, currentIndex!)
        
        removeCollisions(for: pickedSlots.last!)
        delegate?.slotPickerViewDidPickSlot(self)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        startIndex = nil
        currentIndex = nil
        delegate?.slotPickerViewDidPickSlot(self)
    }
    
    func removeCollisions(for slot: SlotItemData) {
        // come from left side - push start position to left
            
            // if the new end position passes the collision end position, remove it
        
        // come from inside
        
            // towards left = push end position to left,
        
                // if the new start position passes the collision start position, remove it
        
            // towards right = push start position to right
            
                // if the new end position passes the collision end position, remove it
        
        // come from right side - push end position to left
        
            // if the new start position passes the collision start position, remove it
        
        
        var removeIndicies = [Int]()
        for (i, pickedSlot) in pickedSlots.enumerated() {
            if pickedSlot.id == slot.id { continue }
            if slot.collides(with: pickedSlot) {
                removeIndicies.append(i)
            }
        }
        removeIndicies.reversed().forEach({ pickedSlots.remove(at: $0) })
    }
}
