import SwiftUI

struct ItineraryPlanView: View {
    @Environment(ItineraryManager.self) private var manager
    @Environment(AppRouter.self) private var router

    @State private var showSetupSheet   = false
    @State private var showDeleteConfirm = false

    var body: some View {
        Group {
            if let plan = manager.activePlan {
                activePlanView(plan)
            } else {
                emptyState
            }
        }
        .sheet(isPresented: $showSetupSheet) {
            ItinerarySetupSheet()
                .presentationDragIndicator(.visible)
        }
        .confirmationDialog("Clear this itinerary?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
            Button("Clear Plan", role: .destructive) { manager.deletePlan() }
            Button("Cancel", role: .cancel) {}
        }
    }

    // MARK: - Active plan

    private func activePlanView(_ plan: ItineraryPlan) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                planHeader(plan)
                if plan.totalDays > 1 {
                    daySelector(plan)
                }
                stopsSection(plan)
                planActions
            }
            .padding(.bottom, 40)
        }
    }

    // MARK: - Plan header

    private func planHeader(_ plan: ItineraryPlan) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text("\(plan.completedCount) of \(plan.stops.count) visited")
                    .font(.appMeta)
                    .foregroundStyle(Color.appInk3)
                Spacer()
                if plan.totalDays > 1 {
                    Text("\(plan.totalDays)-day plan")
                        .font(.appMeta)
                        .foregroundStyle(Color.appInk3)
                }
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.appCardEdge)
                        .frame(height: 3)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.appInk)
                        .frame(width: geo.size.width * plan.progress, height: 3)
                        .animation(.easeInOut, value: plan.progress)
                }
            }
            .frame(height: 3)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }

    // MARK: - Day selector

    private func daySelector(_ plan: ItineraryPlan) -> some View {
        let days: [Int] = Array(1...plan.totalDays)
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(days, id: \.self) { day in
                    let dayStops  = plan.orderedStops(for: day)
                    let doneCount = dayStops.filter(\.isCompleted).count
                    let isActive  = manager.selectedDay == day
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) { manager.selectedDay = day }
                    } label: {
                        VStack(spacing: 2) {
                            Text("Day \(day)")
                                .font(.system(size: 13, weight: .semibold))
                            Text("\(doneCount)/\(dayStops.count)")
                                .font(.system(size: 11))
                        }
                        .foregroundStyle(isActive ? Color.appPaper : Color.appInk)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(isActive ? Color.appInk : Color.appCard)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.appCardEdge, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .animation(.easeInOut(duration: 0.2), value: isActive)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 16)
    }

    // MARK: - Stops

    @ViewBuilder
    private func stopsSection(_ plan: ItineraryPlan) -> some View {
        let dayStops = plan.orderedStops(for: manager.selectedDay)
        if dayStops.isEmpty {
            Text("No stops for this day.")
                .font(.appBody)
                .foregroundStyle(Color.appInk3)
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
        } else {
            ForEach(dayStops, id: \.id) { stop in
                ItineraryStopRowView(
                    stop: stop,
                    onToggleComplete: { manager.toggleComplete(stop) },
                    onNavigate: { router.navigateTo(pin: stop.asPlacePin) }
                )
                Divider()
                    .background(Color.appHairline)
                    .padding(.horizontal, 16)
            }
        }
    }

    // MARK: - Plan actions

    private var planActions: some View {
        HStack(spacing: 12) {
            Button { showSetupSheet = true } label: {
                Label("Regenerate", systemImage: "arrow.clockwise")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.appInk)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.appCard)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.appCardEdge, lineWidth: 1))
            }
            .buttonStyle(.plain)

            Button { showDeleteConfirm = true } label: {
                Label("Clear Plan", systemImage: "trash")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.red)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.red.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red.opacity(0.2), lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "map")
                .font(.system(size: 36))
                .foregroundStyle(Color.appInk4)
            Text("No itinerary yet")
                .font(.system(size: 20, weight: .medium, design: .serif))
                .foregroundStyle(Color.appInk)
            Text("Generate an optimized day plan from your saved places.")
                .font(.appBody)
                .foregroundStyle(Color.appInk3)
                .multilineTextAlignment(.center)
            Button { showSetupSheet = true } label: {
                Text("Plan Your Day")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.appPaper)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.appInk)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 32)
    }
}
