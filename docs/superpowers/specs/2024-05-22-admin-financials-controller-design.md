# Design Spec: Admin Financials Controller

## 1. Overview
The `Admin::FinancialsController` provides the logic for the Admin Financial Dashboard, aggregating data from the `Order` model to show key financial metrics and a ledger of recent transactions.

## 2. Architecture
- **Layer**: Controller (Admin Namespace)
- **Base Class**: `Admin::ApplicationController` (inherits from `ApplicationController` and enforces admin access).
- **Model**: `Order` (primary data source).

## 3. Implementation Details

### Controller: `app/controllers/admin/financials_controller.rb`

The `index` action will calculate the following:

1.  **Total Earnings (`@total_earnings`)**:
    - Query: `Order.where(status: ["accepted", "delivered", "completed"]).sum(:service_fee)`
    - Purpose: Shows the total platform revenue from completed/accepted sales.

2.  **Escrow Vault (`@escrow_vault`)**:
    - Query: `Order.where(status: "pending_approval").sum(:total_price)`
    - Purpose: Shows the total amount currently held in escrow (awaiting approval).

3.  **Star Seller (`@star_seller`)**:
    - Query:
      ```ruby
      star_seller_data = Order.where(status: ["accepted", "delivered", "completed"])
                             .group(:seller_id)
                             .order('count_id DESC')
                             .count(:id)
                             .first
      @star_seller = User.find_by(id: star_seller_data&.first)&.username || "---"
      ```
    - Purpose: Identifies the seller with the highest volume of successful transactions.

4.  **Golden Day (`@golden_day`)**:
    - Query:
      ```ruby
      golden_day_data = Order.where(status: ["accepted", "delivered", "completed"])
                            .group("DATE(created_at)")
                            .order('sum_service_fee DESC')
                            .sum(:service_fee)
                            .first
      @golden_day = golden_day_data&.first&.strftime("%d/%m/%Y") || "---"
      ```
    - Purpose: Highlights the most profitable day for the platform.

5.  **Market Volume (`@market_volume`)**:
    - Query: `Order.where.not(status: "rejected").sum(:total_price)`
    - Purpose: Total transaction volume (excluding rejected orders).

6.  **Transaction History (`@orders`)**:
    - Query: `Order.includes(:client, :seller).order(created_at: :desc).limit(100)`
    - Purpose: Recent ledger for administrative review.

## 4. Testing Strategy
- **File**: `test/controllers/admin/financials_controller_test.rb`
- **Tests**:
  - Access control (guest vs. user vs. admin).
  - Correctness of aggregated calculations using fixture data.
  - Presence of instance variables in the `index` action.

## 5. Security & Constraints
- Admin access only (enforced by `Admin::ApplicationController`).
- Read-only operations for calculations.
- Efficient querying (using `sum`, `group`, and eager loading for ledger).
