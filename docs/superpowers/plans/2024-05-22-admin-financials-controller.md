# Admin Financials Controller Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement the aggregation logic and ledger for the Admin Financial Dashboard.

**Architecture:** A Rails controller in the `Admin` namespace that aggregates data from the `Order` model and exposes it to the view. It leverages ActiveRecord's aggregation and grouping capabilities for efficient data retrieval.

**Tech Stack:** Ruby on Rails (ActiveRecord, ActionController).

---

### Task 1: Controller Setup and Access Control Test

**Files:**
- Create: `app/controllers/admin/financials_controller.rb`
- Create: `test/controllers/admin/financials_controller_test.rb`

- [ ] **Step 1: Create the controller skeleton**

```ruby
class Admin::FinancialsController < Admin::ApplicationController
  def index
    # To be implemented in Task 2
  end
end
```

- [ ] **Step 2: Write the initial failing tests (Access Control)**

```ruby
require "test_helper"

class Admin::FinancialsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @admin = users(:one)
    @admin.update!(is_admin: true)
  end

  test "should deny access if not admin" do
    sign_in_as(@user)
    @user.update!(is_admin: false)
    get admin_financials_path
    assert_redirected_to root_path
    assert_equal "Acceso denegado. No eres administrador.", flash[:alert]
  end

  test "should allow access if admin" do
    sign_in_as(@admin)
    get admin_financials_path
    assert_response :success
  end
end
```

- [ ] **Step 3: Run the tests and verify failure**
Run: `rails test test/controllers/admin/financials_controller_test.rb`
Expected: FAIL (No route matches [GET] "/admin/financials")

- [ ] **Step 4: Add route for financials**
Modify `config/routes.rb`:
```ruby
namespace :admin do
  # ... existing routes
  get 'financials', to: 'financials#index'
end
```

- [ ] **Step 5: Run the tests and verify failure**
Run: `rails test test/controllers/admin/financials_controller_test.rb`
Expected: FAIL (ActionView::MissingTemplate) since we don't have a view yet (but the controller exists).

- [ ] **Step 6: Create a dummy view to make tests pass**
Run: `mkdir -p app/views/admin/financials && touch app/views/admin/financials/index.html.erb`

- [ ] **Step 7: Run the tests and verify they pass**
Run: `rails test test/controllers/admin/financials_controller_test.rb`
Expected: PASS

- [ ] **Step 8: Commit**
```bash
git add app/controllers/admin/financials_controller.rb test/controllers/admin/financials_controller_test.rb config/routes.rb app/views/admin/financials/index.html.erb
git commit -m "admin: setup financials controller and routes"
```

---

### Task 2: Implement Financial Aggregations

**Files:**
- Modify: `app/controllers/admin/financials_controller.rb`
- Modify: `test/controllers/admin/financials_controller_test.rb`

- [ ] **Step 1: Write failing tests for data aggregations**

Add to `test/controllers/admin/financials_controller_test.rb`:
```ruby
  test "index should assign financial metrics" do
    sign_in_as(@admin)
    get admin_financials_path
    
    assert_not_nil assigns(:total_earnings)
    assert_not_nil assigns(:escrow_vault)
    assert_not_nil assigns(:star_seller)
    assert_not_nil assigns(:golden_day)
    assert_not_nil assigns(:market_volume)
    assert_not_nil assigns(:orders)
  end
```

- [ ] **Step 2: Run the tests and verify failure**
Run: `rails test test/controllers/admin/financials_controller_test.rb`
Expected: FAIL (expected not to be nil)

- [ ] **Step 3: Implement aggregation logic in controller**

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

- [ ] **Step 4: Run the tests and verify they pass**
Run: `rails test test/controllers/admin/financials_controller_test.rb`
Expected: PASS

- [ ] **Step 5: Commit**
```bash
git add app/controllers/admin/financials_controller.rb test/controllers/admin/financials_controller_test.rb
git commit -m "admin: implement financial aggregation logic"
```
