# GitHub Repositories Explorer

A modern SwiftUI Demo project for loading and display list of GitHub repositories. Support grouping, pagination, favorites and handle network errors.

## 🖥️ Features

- List of GitHub Repositories
- Support pagination when scroll down (Infinite scrolling)
- Add to favorites and remove from favorites
- Store favorites locally on device
- Store setting locally on device
- Group repositories by owner type or by fork status
- See repository details
- Handle network errors with ability to retry loading
- Handle empty state
- Showing loading indicator while loading data
- Unit tests and mocks

## 🗂️ Folder Structure

- `Components/` - Reusable UI components
- `Model/` - Contains all data models and domain objects used throughout the application
- `Core/` - Contains foundational modules and services that are used across the app
  - `Network/` - Handle all networking logic, API calls and network abstractions
  - `Storage/` - Manage data persistance
  - `Utility/` - Helper classes and reusable tools
- `Features/` - Organizes the main functional areas of the app
  - `MainTabBar/` - Contains main tab bar
  - `Favorites/` - Manages the user's favorite repositories
  - `Repositories/` - Handles everything related to browsing, grouping and viewing details of GitHub reposiotries.
  - `Settings/` - Settings screen and logic for user preferences
- `GithubRepoExplorerTests/` - Unit tests for the application 


## 📺 ScreenShots
**Normal (Non grouped list of repositories)**

<img width="603" height="1311" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 01 22 33" src="https://github.com/user-attachments/assets/1ca4b91b-1dd3-4dc7-9c77-a7a10eba77c6" />

**Grouped list of repositories (Grouped by Fork status: Forked or Not forked)**

<img width="603" height="1311" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 01 29 17" src="https://github.com/user-attachments/assets/c8802309-55de-424a-824a-f848b3844f65" />

**List of Favorites View**

<img width="603" height="1311" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 01 22 43" src="https://github.com/user-attachments/assets/ccee62e4-2a9a-433c-8e4a-c422d800466a" />

**Settings View**

<img width="603" height="1311" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 01 22 47" src="https://github.com/user-attachments/assets/4664bc57-1e98-4ba9-9b73-1b9cd2a088d9" />

**Details View**

<img width="603" height="1311" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 01 22 56" src="https://github.com/user-attachments/assets/4c89dd46-05fb-483e-ac2b-8d1f85b18044" />

**Loading View**

<img width="603" height="1311" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 01 23 54" src="https://github.com/user-attachments/assets/e50a4b38-fc3a-4780-8419-4f991c47cd3d" />

**Error View**

<img width="603" height="1311" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 01 24 28" src="https://github.com/user-attachments/assets/7a89c67b-533c-4690-b3ad-2b43bcda1066" />

**Empty View**

<img width="603" height="1311" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-15 at 01 24 32" src="https://github.com/user-attachments/assets/efa16eb7-ea18-419c-8bbe-c0c449e9846a" />
