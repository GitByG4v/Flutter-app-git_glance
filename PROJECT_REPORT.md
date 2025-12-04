# GitGlance Project Report

## 1. Project Overview
**GitGlance** is a Flutter application designed for students and developers to visualize GitHub profiles, analyze repositories, and discover trending open-source projects. It features a modern, minimal "White & Blue" UI with smooth liquid animations and glassmorphism effects.

## 2. Architecture & Tech Stack
The project follows a clean, modular architecture separating UI, Logic, and Data.

- **Framework**: Flutter (Dart)
- **State Management**: `setState` (Local state), `FutureBuilder` (Async data fetching).
- **Networking**: `http` package for GitHub API integration.
- **UI Libraries**:
    - `fl_chart`: For language statistics charts.
    - `url_launcher`: For opening external links.
    - `google_fonts`: For typography (Outfit & Inter).

### Folder Structure
- **`lib/api/`**: Handles network requests (`GithubService`).
- **`lib/models/`**: Data models (`User`, `Repo`, `Roadmap`).
- **`lib/screens/`**: Full-page views (`Search`, `Dashboard`, `Discover`, `Learn`).
- **`lib/widgets/`**: Reusable UI components (`GlassContainer`, `SlidingCard`, `RepoInsightSheet`).
- **`lib/utils/`**: Constants, Colors, and Styles.

## 3. Key Features & Implementation

### A. Search & Dashboard
- **Flow**: User enters a username -> `SearchScreen` passes it to `DashboardScreen`.
- **Implementation**:
    - `DashboardScreen` calls `GithubService.getUser()` and `getRepos()`.
    - Data is displayed using `FutureBuilder`.
    - **Language Chart**: Calculates language distribution from the fetched repositories.

### B. Repo Insight (Analysis)
- **Goal**: Analyze a repository's quality and health.
- **Trigger**: Tapping a repository card in the Dashboard.
- **Scoring Logic** (Total 100 pts):
    1.  **Structure (40 pts)**: Checks for License, Description (>10 chars), and Topics.
    2.  **Health (40 pts)**: Checks if Repo Size > 100KB and Language is defined.
    3.  **Popularity (10 pts)**: Checks Stars (>100 or >10) and Forks (>20).
    4.  **Maintenance (10 pts)**: Checks Recency (<6 months) and Open Issues (<50).
- **Feedback**: Returns specific "Good Things" and "Gaps" lists based on the checks.

### C. Discover (Trending)
- **Goal**: Suggest popular projects for learning.
- **Implementation**:
    - `GithubService.getTrendingRepos()` fetches repos with >1000 stars.
    - Displayed in `DiscoverScreen` using `ProjectCard`.

### D. Learn (Roadmaps)
- **Goal**: Provide career guidance.
- **Implementation**:
    - Static list of `Roadmap` objects in `LearnScreen`.
    - Opens external roadmap URLs when tapped.

## 4. Data Flow
1.  **API Layer**: `GithubService` makes HTTP GET requests to `api.github.com`.
2.  **Model Layer**: JSON responses are parsed into `User` and `Repo` objects using `fromJson` factories.
3.  **UI Layer**: Widgets consume these objects.
    - `RepoInsightSheet` consumes a `Repo` object to calculate the score locally.
    - `DashboardScreen` consumes `User` and `List<Repo>` to render the profile and list.

## 5. UI/UX Highlights
- **Liquid Background**: Custom painter animation for a fluid background effect.
- **Glassmorphism**: `GlassContainer` uses `BackdropFilter` for a frosted glass look.
- **Animations**: `SlidingCard` animates items into view with a staggered delay.
