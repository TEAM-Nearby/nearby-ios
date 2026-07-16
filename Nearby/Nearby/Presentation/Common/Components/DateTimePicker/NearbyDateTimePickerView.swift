//
//  NearbyDateTimePickerView.swift
//  Nearby
//
//  Created by 장지인 on 7/6/26.
//

import UIKit

import SnapKit
import Then

final class NearbyDateTimePickerView: BaseView {

    // MARK: - UI Components

    private let selectedBackgroundView = UIView()
    private let pickerView = UIPickerView()

    // MARK: - Properties

    var dateDidChange: ((Date) -> Void)?
    
    private let calendar = Calendar.current
    private let months = Array(1...12)
    private let hours = Array(0...23)
    private let minutes = stride(from: 0, through: 55, by: 5).map { $0 }
    
    private var selectedMonth: Int
    private var selectedDay: Int
    private var selectedHour: Int
    private var selectedMinute: Int

    private var days: [Int] {
        let year = calendar.component(.year, from: Date())
        let dateComponents = DateComponents(year: year, month: selectedMonth)
        guard
            let date = calendar.date(from: dateComponents),
            let range = calendar.range(of: .day, in: .month, for: date)
        else {
            return Array(1...31)
        }

        return Array(range)
    }

    var selectedDate: Date {
        let year = calendar.component(.year, from: Date())
        let components = DateComponents(year: year, month: selectedMonth, day: selectedDay, hour: selectedHour, minute: selectedMinute)

        return calendar.date(from: components) ?? Date()
    }
    
    // MARK: - Initializer

    init(date: Date = Date()) {
        let components = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: date)
        selectedMonth = components.month ?? 1
        selectedDay = components.day ?? 1
        selectedHour = components.hour ?? 0
        selectedMinute = ((components.minute ?? 0) / 5) * 5

        super.init(frame: .zero)

        setPickerPosition()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

    override func layoutSubviews() {
        super.layoutSubviews()

        pickerView.subviews.forEach {
            $0.backgroundColor = .clear
        }
    }

    override func setStyle() {
        backgroundColor = .white
        selectedBackgroundView.do {
            $0.backgroundColor = .bgSurfaceGrey0
            $0.layer.cornerRadius = 16
        }

        pickerView.do {
            $0.backgroundColor = .clear
            $0.dataSource = self
            $0.delegate = self
        }
    }

    override func setUI() {
        addSubviews(selectedBackgroundView, pickerView)
    }

    override func setLayout() {
        selectedBackgroundView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }

        pickerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Methods

    private func setPickerPosition() {
        pickerView.do {
            $0.selectRow(selectedMonth - 1, inComponent: 0, animated: false)
            $0.selectRow(max(selectedDay - 1, 0), inComponent: 1, animated: false)
            $0.selectRow(selectedHour, inComponent: 2, animated: false)
            $0.selectRow(minutes.firstIndex(of: selectedMinute) ?? 0, inComponent: 3, animated: false)
        }
    }

    private func title(component: Int, row: Int) -> String {
        switch component {
        case 0:
            return String(format: "%02d월", months[row])
        case 1:
            return String(format: "%02d일", days[row])
        case 2:
            return String(format: "%02d시", hours[row])
        case 3:
            return String(format: "%02d분", minutes[row])
        default:
            return ""
        }
    }

    private func isSelected(component: Int, row: Int) -> Bool {
        switch component {
        case 0:
            return months[row] == selectedMonth
        case 1:
            return days[row] == selectedDay
        case 2:
            return hours[row] == selectedHour
        case 3:
            return minutes[row] == selectedMinute
        default:
            return false
        }
    }
}

// MARK: - UIPickerViewDataSource

extension NearbyDateTimePickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return days.count
        case 2:
            return hours.count
        case 3:
            return minutes.count
        default:
            return 0
        }
    }
}

// MARK: - UIPickerViewDelegate

extension NearbyDateTimePickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 48
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 48 + 8
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        
        label.text = title(component: component, row: row)
        label.textAlignment = .center
        label.font = NearbyFont.b2Sb16.font
        label.textColor = isSelected(component: component, row: row) ? .primary50 : .grey20
        
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            selectedMonth = months[row]

            if selectedDay > days.count {
                selectedDay = days.count
            }

            pickerView.reloadComponent(0)
            pickerView.reloadComponent(1)
            pickerView.selectRow(selectedDay - 1, inComponent: 1, animated: false)
        case 1:
            selectedDay = days[row]
            pickerView.reloadComponent(component)
        case 2:
            selectedHour = hours[row]
            pickerView.reloadComponent(component)
        case 3:
            selectedMinute = minutes[row]
            pickerView.reloadComponent(component)
        default:
            break
        }

        dateDidChange?(selectedDate)
    }
}
