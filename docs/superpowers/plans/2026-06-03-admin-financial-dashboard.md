# Admin Financial Dashboard Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement a comprehensive financial dashboard for administrators to track earnings (3% fee), escrow funds, and transaction history.

**Architecture:** 
- New controller `Admin::FinancialsController` to handle data aggregation.
- New view `app/views/admin/financials/index.html.erb` with KPI cards and a transaction table.
- Use existing `Order` and `User` associations for calculations.
- Full I18n support in English and Spanish.

**Tech Stack:** Rails, ActiveRecord (aggregations), I18n, Vanilla CSS.

---

### Task 1: Routes and I18n Setup

**Files:**
- Modify: `config/routes.rb`
- Modify: `config/locales/views/admin/admin.es.yml`
- Modify: `config/locales/views/admin/admin.en.yml`

- [ ] **Step 1: Add the financial dashboard route**
Add to `config/routes.rb` inside the `admin` namespace:
```ruby
namespace :admin do
  get "financials", to: "financials#index", as: :financials
  # ... existing routes
end
```

- [ ] **Step 2: Add I18n keys to Spanish locale**
Add to `config/locales/views/admin/admin.es.yml`:
```yaml
  admin:
    financials:
      title: "LIBRO CONTABLE 💵"
      mailbox_btn: "CORREO SOPORTE 📩"
      ledger_btn: "LIBRO CONTABLE 💵"
      kpis:
        total_earnings: "GANANCIAS APP"
        escrow_vault: "BÓVEDA ESCROW"
        star_seller: "VENDEDOR ESTRELLA"
        golden_day: "DÍA DE ORO"
        market_volume: "FLUJO TOTAL"
      table:
        id: "ID"
        date: "FECHA"
        trainers: "TRAINERS (C ➡️ V)"
        subtotal: "SUBTOTAL"
        fee: "FEE (3%)"
        total: "TOTAL"
        status: "ESTADO"
```

- [ ] **Step 3: Add I18n keys to English locale**
Add to `config/locales/views/admin/admin.en.yml`:
```yaml
  admin:
    financials:
      title: "FINANCIAL LEDGER 💵"
      mailbox_btn: "SUPPORT MAILBOX 📩"
      ledger_btn: "FINANCIAL LEDGER 💵"
      kpis:
        total_earnings: "APP EARNINGS"
        escrow_vault: "ESCROW VAULT"
        star_seller: "STAR SELLER"
        golden_day: "GOLDEN DAY"
        market_volume: "TOTAL VOLUME"
      table:
        id: "ID"
        date: "DATE"
        trainers: "TRAINERS (B ➡️ S)"
        subtotal: "SUBTOTAL"
        fee: "FEE (3%)"
        total: "TOTAL"
        status: "STATUS"
```

- [ ] **Step 4: Commit**
```bash
git add .
git commit -m "admin: add routes and i18n for financial dashboard"
```

---

### Task 2: Controller Implementation (Aggregation Logic)

**Files:**
- Create: `app/controllers/admin/financials_controller.rb`

- [ ] **Step 1: Create the controller with calculations**
```ruby
class Admin::FinancialsController < Admin::ApplicationController
  def index
    # 1. Ganancias Totales (3% de órdenes aceptadas/completadas)
    @total_earnings = Order.where(status: ["accepted", "delivered", "completed"]).sum(:service_fee)

    # 2. Bóveda Escrow (Total de órdenes pendientes)
    @escrow_vault = Order.where(status: "pending_approval").sum(:total_price)

    # 3. Vendedor Estrella (Usuario con más ventas aceptadas)
    star_seller_data = Order.where(status: ["accepted", "delivered", "completed"])
                           .group(:seller_id)
                           .order('count_id DESC')
                           .count(:id)
                           .first
    @star_seller = User.find_by(id: star_seller_data&.first)&.username || "---"

    # 4. Día de Oro (Fecha con más ganancias)
    golden_day_data = Order.where(status: ["accepted", "delivered", "completed"])
                          .group("DATE(created_at)")
                          .order('sum_service_fee DESC')
                          .sum(:service_fee)
                          .first
    @golden_day = golden_day_data&.first&.strftime("%d/%m/%Y") || "---"

    # 5. Volumen de Mercado (Suma de total_price no rechazados)
    @market_volume = Order.where.not(status: "rejected").sum(:total_price)

    # 6. Historial de Transacciones (Ledger)
    @orders = Order.includes(:client, :seller).order(created_at: :desc).limit(100)
  end
end
```

- [ ] **Step 2: Commit**
```bash
git add app/controllers/admin/financials_controller.rb
git commit -m "admin: implement financial aggregation logic"
```

---

### Task 3: View Implementation (KPI Cards & Ledger)

**Files:**
- Create: `app/views/admin/financials/index.html.erb`

- [ ] **Step 1: Create the view with retro styling**
Use `pokedex-frame-large` and implement:
- Flexbox grid for KPI cards.
- Styled table for the ledger.
- Use `number_to_currency` for prices.

- [ ] **Step 2: Commit**
```bash
git add app/views/admin/financials/index.html.erb
git commit -m "admin: implement financial dashboard view"
```

---

### Task 4: Navigation Entry

**Files:**
- Modify: `app/views/admin/dashboard/index.html.erb`

- [ ] **Step 1: Add the "Financial Ledger" button**
Place it next to the support mailbox button.
```erb
<%= link_to t("admin.financials.ledger_btn"), admin_financials_path, class: "admin-btn-blue btn-interactive", style: "font-size: 10px; padding: 12px 20px; margin-right: 10px;" %>
```

- [ ] **Step 2: Commit**
```bash
git add app/views/admin/dashboard/index.html.erb
git commit -m "admin: add link to financial dashboard in main dashboard"
```
