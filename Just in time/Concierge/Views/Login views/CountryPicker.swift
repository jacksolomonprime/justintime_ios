//Credit to: https://github.com/mobven/CountryPicker/blob/master/docs/SwiftUI.md

import SwiftUI
import CountryPicker

struct CountryPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = CountryPickerViewController

    @Binding var country: Country?

    let countryPicker = CountryPickerViewController()
    func makeUIViewController(context: Context) -> CountryPickerViewController {
        countryPicker.selectedCountry = "GB"
        countryPicker.delegate = context.coordinator
        return countryPicker
    }

    func updateUIViewController(_ uiViewController: CountryPickerViewController, context: Context) {
        //
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, CountryPickerDelegate {
        var parent: CountryPicker
        init(_ parent: CountryPicker) {
            self.parent = parent
        }
        
        //Notify parent when country is picked
        func countryPicker(didSelect country: Country) {
            print("SELECTED COUNTRY \(country)")
            parent.country = country
        }
    }
}
