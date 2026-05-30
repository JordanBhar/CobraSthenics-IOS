import SwiftUI

public struct ExerciseVideoSection: View {
    public let accent: Color
    public let exerciseName: String
    public let isTimed: Bool

    public init(accent: Color, exerciseName: String, isTimed: Bool) {
        self.accent = accent
        self.exerciseName = exerciseName
        self.isTimed = isTimed
    }

    private var totalSeconds: Int { 28 + (exerciseName.count % 18) }
    private var totalLabel: String {
        let m = totalSeconds / 60
        let s = totalSeconds % 60
        return "\(m):\(String(format: "%02d", s))"
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("WATCH THE MOVEMENT")
                .font(.appLabel)
                .tracking(0.8)
                .foregroundStyle(AppColor.textSecondary)

            ZStack {
                LinearGradient(
                    colors: [accent.opacity(0.22), Color(hex: 0x0E0E0E)],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
                RadialGradient(
                    gradient: Gradient(colors: [accent.opacity(0.22), .clear]),
                    center: UnitPoint(x: 0.82, y: -0.1),
                    startRadius: 10, endRadius: 240
                )
                .allowsHitTesting(false)

                // Form Demo tag
                VStack {
                    HStack {
                        HStack(spacing: 6) {
                            Image(systemName: "video.fill")
                                .font(.system(size: 11))
                                .foregroundStyle(accent)
                            Text("FORM DEMO")
                                .font(.system(size: 9, weight: .bold))
                                .tracking(0.8)
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.black.opacity(0.45))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(.white.opacity(0.08), lineWidth: 1))
                        Spacer()
                        Text("HD")
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .tracking(0.8)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(.black.opacity(0.55))
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(.white.opacity(0.1), lineWidth: 1))
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    }
                    Spacer()
                    HStack {
                        Text(totalLabel)
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(.black.opacity(0.55))
                            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(.white.opacity(0.08), lineWidth: 1))
                        Spacer()
                        HStack(spacing: 6) {
                            ZStack {
                                Circle().fill(LinearGradient(colors: [Color(hex: 0x001D42), Color(hex: 0x003E8A)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                Circle().stroke(AppColor.brand.opacity(0.35), lineWidth: 1)
                                Text("JB")
                                    .font(.system(size: 7, weight: .heavy))
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 16, height: 16)
                            Text("Coach Jordan")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.white.opacity(0.55))
                        }
                    }
                }
                .padding(12)

                // Centered play button
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.95))
                    Image(systemName: "play.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(.black)
                        .offset(x: 2)
                }
                .frame(width: 62, height: 62)
                .shadow(color: accent.opacity(0.4), radius: 16, x: 0, y: 8)
                .shadow(color: .black.opacity(0.4), radius: 6, x: 0, y: 4)
            }
            .aspectRatio(16/9, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
                    .stroke(AppColor.border, lineWidth: 1)
            )
        }
    }
}

#Preview {
    ZStack {
        AppColor.background.ignoresSafeArea()
        ExerciseVideoSection(
            accent: AppColor.brand,
            exerciseName: "Push-Up",
            isTimed: false
        )
        .padding()
    }
}
