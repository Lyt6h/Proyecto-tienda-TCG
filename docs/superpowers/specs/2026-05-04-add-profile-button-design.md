# Design Spec: My Profile Button in Settings Menu

**Status:** Draft
**Date:** 2026-05-04
**Topic:** UI / i18n

## 1. Goal
Add a "My Profile" button to the settings menu (gear icon) to provide a placeholder for future profile management. The button must use existing i18n keys and match the project's retro/pixelated aesthetic.

## 2. Context
The settings menu is a floating panel defined in `app/views/layouts/application.html.erb`. It currently contains language selection and a logout button (when authenticated).

## 3. UI/UX Design
- **Placement:** Inside the `#settings-menu`, specifically within the conditional block `if Current.user`, placed directly above the "Sign out" button.
- **Visual Style:**
  - **Tag:** `link_to` (Rails helper)
  - **Path:** `#` (Placeholder)
  - **Font:** `'Press Start 2P', cursive`
  - **Font Size:** `7px`
  - **Colors:** Background: `white`, Text: `black`, Border: `2px solid black`.
  - **Shadow:** `box-shadow: 2px 2px 0px black` (Matches existing UI).
  - **Spacing:** `margin-bottom: 8px` to separate it from the logout button.
- **i18n:** Use `t("layout.profile")`.

## 4. Implementation Details
- **Files to Modify:**
  - `app/views/layouts/application.html.erb`: Insert the new link within the `if Current.user` block inside `#settings-menu`.
- **Logic:**
  - The button will only be visible if `Current.user` is present.
  - It will use `display: block` or `display: flex` with `text-align: center` to match the width of the logout button.

## 5. Verification Plan
- **Manual Check:** 
  1. Open the settings menu as an authenticated user.
  2. Verify the "My Profile" button appears with the correct text in both Spanish and English.
  3. Verify it has no functional link (stays on page).
  4. Verify the aesthetic matches the "Sign out" button but with a white background.
