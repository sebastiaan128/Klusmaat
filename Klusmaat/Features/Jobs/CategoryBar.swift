import SwiftUI

struct CategoryBar: View {
    @Binding var selected: JobCategory?
    @Namespace private var underline

    private let categories: [JobCategory?] = [nil, .garden, .painting, .repair, .assembly, .pickup, .indoor]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal) {
                HStack(spacing: 24) {
                    ForEach(categories, id: \.self) { category in
                        Button {
                            withAnimation(.snappy) {
                                selected = category
                            }
                        } label: {
                            VStack(spacing: 6) {
                                Image(systemName: category?.icon ?? "square.grid.2x2")
                                    .font(.title3)
                                Text(category?.rawValue ?? "Alles")
                                    .font(.caption)
                                if selected == category {
                                    Rectangle()
                                        .fill(Color.textPrimary)
                                        .frame(height: 2)
                                        .matchedGeometryEffect(id: "underline", in: underline)
                                } else {
                                    Color.clear
                                        .frame(height: 2)
                                }
                            }
                            .foregroundStyle(selected == category ? Color.textPrimary : Color.textSecondary)
                        }
                        .buttonStyle(.plain)
                        .accessibilityAddTraits(selected == category ? .isSelected : [])
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .scrollIndicators(.hidden)

            Divider()
        }
    }
}

#Preview {
    @Previewable @State var selected: JobCategory?
    CategoryBar(selected: $selected)
}
