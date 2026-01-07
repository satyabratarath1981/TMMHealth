# TMMHealth
TMM Mock App 

Project Setup & Architecture Foundation

Focus: Clean structure and scalability.
	•	Created a SwiftUI-based iOS project targeting iOS 17
	•	Established a clear MVVM-based folder structure
	•	Introduced a central AppRootView to control app flow
	•	Avoided default template views to prevent early technical debt

Key Outcome:
A production-ready project foundation with clear separation of concerns.

⸻

Design System & Premium UI Foundation

Focus: Consistency, polish, and Dark Mode readiness.
	•	Implemented a lightweight design system:
	•	Spacing scale
	•	Typography hierarchy
	•	Color abstraction
	•	Created reusable UI components:
	•	Primary button with animation and haptics
	•	Card container with elevation and rounded corners
	•	Ensured automatic Dark Mode support

Key Outcome:
A consistent, premium visual language used across the app.

⸻

Onboarding Flow & State Management

Focus: Product clarity and clean UI state handling.
	•	Built a premium onboarding experience with a clear value proposition
	•	Introduced explicit onboarding states:
	•	Idle
	•	Requesting permission
	•	Denied (Limited Mode)
	•	Completed
	•	Avoided alert-only permission UX by providing a dedicated Limited Mode screen

Key Outcome:
A polished onboarding flow that clearly communicates value and handles edge cases gracefully.

⸻

HealthKit Permissions & Service Abstraction

Focus: Correctness, safety, and testability.
	•	Enabled HealthKit capability and added required usage descriptions
	•	Abstracted HealthKit behind a HealthService protocol
	•	Implemented a real HealthKitService using async/await
	•	Added a MockHealthService for testing and preview support
	•	Wired HealthKit authorization cleanly into onboarding flow

Key Outcome:
Correct and testable HealthKit permission handling without UI-framework coupling.

⸻

App Flow Control & Dashboard Skeleton

Focus: Scalable navigation and clean app flow.
	•	Introduced a global AppState to manage app flow
	•	Implemented onboarding → dashboard transition at the app root level
	•	Created Dashboard screen with explicit states:
	•	Loading
	•	Empty
	•	Loaded
	•	Error
	•	Avoided navigation logic inside feature views

Key Outcome:
A scalable, production-style app flow with clear screen responsibilities.

⸻

HealthKit Daily Aggregates (Correct Data Usage)

Focus: HealthKit correctness and performance.
	•	Implemented daily step count and active calorie fetching
	•	Used HKStatisticsQuery with daily aggregation
	•	Avoided naive summing of raw HealthKit samples
	•	Fetched steps and calories in parallel using async/await
	•	Displayed real HealthKit data on the dashboard

Key Outcome:
Accurate, efficient HealthKit data usage aligned with Apple best practices.

⸻

Offline Cache & Instant Dashboard Load

Focus: Performance and offline-first experience.
	•	Introduced SwiftData for local persistence
	•	Cached daily aggregated health values (not raw samples)
	•	Implemented instant dashboard loading from cache
	•	Refreshed HealthKit data in the background
	•	Ensured correct UI behavior even when offline

Key Outcome:
Fast launch times, offline usability, and production-grade data handling.

⸻

Day Trends & Swift Charts

Focus: Visual clarity and meaningful data presentation.
	•	Implemented a 7-day trend chart using Swift Charts
	•	Added Steps / Calories toggle with a custom, premium control
	•	Read chart data from cached daily aggregates
	•	Ensured charts are readable in both Light and Dark Mode
	•	Gracefully handled low-data scenarios
