# Admin Financial Dashboard Navigation Entry Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a "Financial Ledger" button to the Admin Dashboard to allow administrators to access the financial reports.

**Architecture:** The button will be placed in the Admin Dashboard index view, next to the existing support mailbox button, inside a flex container for alignment.

**Tech Stack:** Ruby on Rails, ERB, Tailwind/Vanilla CSS (using project-defined admin classes).

---

### Task 1: Add Navigation Button to Admin Dashboard

**Files:**
- Modify: `app/views/admin/dashboard/index.html.erb`

- [ ] **Step 1: Add the "Financial Ledger" button**

In `app/views/admin/dashboard/index.html.erb`, find the flex container containing the support mailbox button and add the new button next to it.

```erb
<div style="display: flex; justify-content: flex-end; margin-bottom: 20px;">
  <%= link_to t("admin.financials.ledger_btn"), admin_financials_path, class: "admin-btn-blue btn-interactive", style: "font-size: 10px; padding: 12px 20px; margin-right: 10px;" %>
  <%= link_to t("support.admin.mailbox_btn"), admin_support_messages_path, class: "admin-btn-yellow btn-interactive", style: "font-size: 10px; padding: 12px 20px;" %>
</div>
```

- [ ] **Step 2: Verify the change manually (if possible)**
Since I'm in a CLI environment, I'll rely on automated tests and checking the file content.

### Task 2: Add Automated Test for the Button

**Files:**
- Modify: `test/controllers/admin/dashboard_controller_test.rb`

- [ ] **Step 1: Add test case for the ledger button**

```ruby
  test "debería mostrar el botón del libro contable en el dashboard si es admin" do
    admin = users(:one)
    admin.update!(is_admin: true)
    sign_in_as(admin)

    get admin_dashboard_path
    assert_response :success
    assert_select "a[href=?]", admin_financials_path, text: I18n.t("admin.financials.ledger_btn")
  end
```

- [ ] **Step 2: Run the test**

Run: `bin/rails test test/controllers/admin/dashboard_controller_test.rb`
Expected: PASS

- [ ] **Step 3: Commit the changes**

```bash
git add app/views/admin/dashboard/index.html.erb test/controllers/admin/dashboard_controller_test.rb
git commit -m "admin: add link to financial dashboard in main dashboard"
```
