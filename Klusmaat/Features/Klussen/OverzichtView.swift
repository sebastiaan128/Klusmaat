
import SwiftUI

struct OverzichtView: View {
    @Binding var filters: KlusFilters

    var body: some View {
        NavigationStack {
            ResultatenView(filters: $filters, klussen: KlusService.voorbeeldKlussen)
        }
    }
}

#Preview {
    @Previewable @State var filters = KlusFilters()
    OverzichtView(filters: $filters)
}
