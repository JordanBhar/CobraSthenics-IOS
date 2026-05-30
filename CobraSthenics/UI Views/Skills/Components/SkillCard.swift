import SwiftUI

struct SkillCard: View {
    let skill: Skill

    private var accent: Color { skill.family.accent }
    private var colors: [Color] { skill.family.colors }

    var body: some View {
        AppCard(padding: 0, border: accent.opacity(0.22)) {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top, spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .fill(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                            RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .stroke(accent.opacity(0.25), lineWidth: 1)
                            Image(systemName: SkillsConstants.Card.unlockedIcon)
                                .foregroundStyle(accent)
                                .font(.system(size: 20))
                        }
                        .frame(width: 52, height: 52)

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(skill.name)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(AppColor.textPrimary)
                                Spacer()
                                Image(systemName: SkillsConstants.Card.chevronIcon)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(AppColor.textHint)
                            }
                            Text("\(SkillsConstants.Card.tierLabel) \(skill.tierIndex) \(SkillsConstants.Card.tierOfLabel) \(skill.totalTiers) · \(skill.currentTierName)")
                                .font(.appCaption)
                                .foregroundStyle(AppColor.textSecondary)
                            TierDots(current: skill.tierIndex, total: skill.totalTiers, accent: accent)
                                .padding(.top, 2)
                        }
                    }

                    HStack(spacing: 10) {
                        statTile(SkillsConstants.Card.bestLabel, value: SkillsConstants.Card.emptyValue, color: accent)
                        statTile(SkillsConstants.Card.targetLabel, value: skill.targetDisplay ?? SkillsConstants.Card.emptyValue, color: AppColor.textSecondary)
                        progressTile
                    }
                }
                .padding(AppSpacing.md)

                Rectangle().fill(AppColor.border).frame(height: 1)
                HStack(spacing: AppSpacing.xs) {
                    actionTile(SkillsConstants.Actions.train, systemImage: SkillsConstants.Actions.trainIcon, color: accent, filled: true)
                        .frame(maxWidth: .infinity)
                    actionTile(SkillsConstants.Actions.analyseForm, systemImage: SkillsConstants.Actions.analyseFormIcon, color: accent, filled: false)
                        .frame(maxWidth: .infinity * 2)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
            }
        }
    }

    private func statTile(_ label: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .tracking(1)
                .foregroundStyle(AppColor.textHint)
            Text(value)
                .font(.system(size: 17, weight: .black, design: .monospaced))
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(AppColor.elevated)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private var progressTile: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(SkillsConstants.Card.progressLabel)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .tracking(1)
                .foregroundStyle(AppColor.textHint)
            AppProgressBar(progress: 0, color: accent, height: 6)
            Text("0%")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundStyle(accent)
        }
        .frame(maxWidth: .infinity * 2, alignment: .leading)
        .padding(10)
        .background(AppColor.elevated)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private func actionTile(_ title: String, systemImage: String, color: Color, filled: Bool) -> some View {
        HStack(spacing: 6) {
            Image(systemName: systemImage).font(.system(size: 13, weight: .bold))
            Text(title.uppercased())
                .font(.system(size: 11, weight: .heavy))
                .tracking(0.6)
        }
        .foregroundStyle(filled ? .white : color)
        .frame(maxWidth: .infinity)
        .frame(height: 40)
        .background(filled ? color : color.opacity(0.14))
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .stroke(filled ? Color.clear : color.opacity(0.32), lineWidth: 1)
        )
    }
}
