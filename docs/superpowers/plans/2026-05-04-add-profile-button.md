# Add My Profile Button Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a "My Profile" button to the settings menu in the application layout, using i18n and matching the retro aesthetic.

**Architecture:** Modified Rails view (ERB) with inline styling to match existing patterns in `application.html.erb`.

**Tech Stack:** Ruby on Rails, ERB, CSS (Inline/Retro style).

---

### Task 1: Add Profile Button to Settings Menu

**Files:**
- Modify: `app/views/layouts/application.html.erb`

- [ ] **Step 1: Identify insertion point**
Find the `if Current.user` block inside the `#settings-menu` div.

- [ ] **Step 2: Insert the Profile button code**
Add the following code before the `button_to t("layout.sign_out")`:

```erb
<%= link_to t("layout.profile"), "#", style: "display: block; background: white; color: black; border: 2px solid black; padding: 10px; cursor: pointer; font-family: 'Press Start 2P', cursive; font-size: 7px; box-shadow: 2px 2px 0px black; border-radius: 4px; width: 100%; text-decoration: none; text-align: center; margin-bottom: 8px; box-sizing: border-box;" %>
```

- [ ] **Step 3: Verify style consistency**
Ensure the button matches the width and padding of the logout button. The `box-sizing: border-box;` and `width: 100%` are key here.

- [ ] **Step 4: Commit changes**

```bash
git add app/views/layouts/application.html.erb
git commit -m "feat: add My Profile button to settings menu"
```

---

### Task 2: Verification

- [ ] **Step 1: Manual verification**
Open the application, click the gear icon, and verify:
1. The button "My Profile" (EN) / "Tu perfil" (ES) appears when logged in.
2. The style is consistent with the logout button but with a white background.
3. Clicking it does nothing (href="#").
4. Changing the language updates the button text.
