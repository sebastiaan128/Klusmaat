import SwiftUI

struct JobRow: View {
    let job: Job
    var status: String? = nil
    var highlighted = false

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Color.oat
                .overlay {
                    Image(systemName: job.icon)
                        .font(.system(size: 30, weight: .light))
                        .foregroundStyle(Color.coffee.opacity(0.35))
                }
                .overlay {
                    if let url = job.photos.first {
                        JobImage(url: url, maxPoints: 110) { Color.clear }
                    }
                }
                .frame(width: 110, height: 110)
                .clipShape(.rect(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(job.title)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                Text(JobActivity.shared.owns(job) ? "€ \(job.pay)" : "Verdien € \(job.pay)")
                    .font(.headline)
                    .foregroundStyle(Color.brandGreen)
                Spacer(minLength: 10)
                if let status {
                    Text(status)
                        .font(.footnote)
                        .foregroundStyle(highlighted ? Color.brandGreen : Color.textSecondary)
                } else {
                    ViewThatFits(in: .horizontal) {
                        metadata
                        VStack(alignment: .leading, spacing: 2) {
                            if job.isNew { Text("Nieuw").foregroundStyle(Color.brandGreen) }
                            Text("\(job.distance) · \(job.dateLabel)")
                        }
                    }
                    .font(.footnote)
                    .foregroundStyle(Color.textSecondary)
                    Text(job.duration.rawValue)
                        .font(.footnote)
                        .foregroundStyle(Color.textSecondary)
                    Label(job.toolsProvided ? "Gereedschap aanwezig" : "Eigen gereedschap mee",
                          systemImage: job.toolsIcon)
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(job.toolsProvided ? Color.brandGreen : Color.accentOrange)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 110, alignment: .leading)

            Image(systemName: "chevron.right")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.textSecondary)
                .frame(width: 16, height: 110)
                .accessibilityHidden(true)
        }
        .foregroundStyle(Color.textPrimary)
        .multilineTextAlignment(.leading)
        .padding(.vertical, 14)
        .contentShape(.rect)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Opent de klusdetails")
    }

    private var metadata: some View {
        Text("\(Text(job.isNew ? "Nieuw · " : "").foregroundStyle(Color.brandGreen))\(job.distance) · \(job.dateLabel)")
    }
}

#Preview {
    JobRow(job: JobService.sampleJobs[0]).padding()
}
