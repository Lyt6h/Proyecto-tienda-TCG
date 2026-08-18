# Purchase Request and Escrow System Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement a purchase request system where sellers must approve orders, including a 5% service fee and a visual notification system.

**Architecture:** 
- Add financial and status fields to the `Order` model via migration.
- Update `CartsController#checkout` to create orders in `pending_approval` state with calculated fees.
- Create a `SalesController` for sellers to manage (accept/reject) incoming requests.
- Implement visual badges in the main navigation using conditional layout logic and I18n.

**Tech Stack:** Rails, Minitest, I18n, Vanilla CSS.

---

### Task 1: Database Migration and Model Updates

**Files:**
- Create: `db/migrate/YYYYMMDDHHMMSS_add_financial_fields_to_orders.rb`
- Modify: `app/models/order.rb`
- Modify: `config/locales/views/layout/layout.es.yml`
- Modify: `config/locales/views/layout/layout.en.yml`

- [ ] **Step 1: Generate the migration**
```bash
bin/rails generate migration AddFinancialFieldsToOrders subtotal:decimal service_fee:decimal total_price:decimal buyer_notification_seen:boolean
```

- [ ] **Step 2: Update the migration file with defaults**
```ruby
class AddFinancialFieldsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :subtotal, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :orders, :service_fee, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :orders, :total_price, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :orders, :buyer_notification_seen, :boolean, default: false
    
    # Update existing status validation context
    # No change needed to column type if already string
  end
end
```

- [ ] **Step 3: Run migration**
```bash
bin/rails db:migrate
```

- [ ] **Step 4: Update Order model validations**
```ruby
class Order < ApplicationRecord
  belongs_to :client, class_name: "User"
  belongs_to :seller, class_name: "User"
  has_many :order_items, dependent: :destroy
  has_many :listings, through: :order_items

  validates :status, inclusion: { in: %w[pending_approval accepted delivered rejected completed] }
  validates :subtotal, :service_fee, :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
```

- [ ] **Step 5: Add I18n keys for notifications and sales**
Modify `config/locales/views/layout/layout.es.yml`:
```yaml
    my_sales: "Mis Ventas 💰"
    logout_success_title: "¡SESIÓN CERRADA!"
```
Modify `config/locales/views/layout/layout.en.yml`:
```yaml
    my_sales: "My Sales 💰"
    logout_success_title: "SESSION CLOSED!"
```

- [ ] **Step 6: Commit**
```bash
git add .
git commit -m "db: add financial and notification fields to orders"
```

---

### Task 2: Update Checkout Logic and Stock Reservation

**Files:**
- Modify: `app/controllers/carts_controller.rb`
- Modify: `app/views/carts/show.html.erb`

- [ ] **Step 1: Update checkout method to calculate fees and reserve stock**
```ruby
# In app/controllers/carts_controller.rb
def checkout
  @cart = Current.user.cart
  if @cart.cart_items.any?
    # Agrupar por vendedor para crear una orden por cada uno
    items_by_seller = @cart.cart_items.group_by { |item| item.listing.seller_id }
    
    ActiveRecord::Base.transaction do
      items_by_seller.each do |seller_id, items|
        subtotal = items.sum { |i| i.listing.price * i.quantity }
        service_fee = subtotal * 0.05
        total_price = subtotal + service_fee
        
        order = Order.create!(
          client: Current.user,
          seller_id: seller_id,
          status: "pending_approval",
          subtotal: subtotal,
          service_fee: service_fee,
          total_price: total_price
        )
        
        items.each do |item|
          order.order_items.create!(
            listing: item.listing,
            quantity: item.quantity,
            unit_price: item.listing.price
          )
          # Reservar stock
          item.listing.update!(stock: item.listing.stock - item.quantity)
        end
      end
      @cart.cart_items.destroy_all
    end
    redirect_to products_path, flash: { checkout_success: true }
  else
    redirect_to cart_path, alert: t("flash.carts.empty")
  end
end
```

- [ ] **Step 2: Update Cart view to show Service Fee**
```erb
<%# In app/views/carts/show.html.erb near total %>
<div style="margin-top: 20px; border-top: 4px dashed black; padding-top: 20px;">
  <p style="font-size: 10px;"><%= t("purchases.subtotal") %>: $<%= @cart.cart_items.sum { |i| i.listing.price * i.quantity } %></p>
  <p style="font-size: 10px;">Cargo Servicio (5%): $<%= (@cart.cart_items.sum { |i| i.listing.price * i.quantity } * 0.05).round(2) %></p>
  <h2 style="font-size: 18px; color: #E3350D;">Total: $<%= (@cart.cart_items.sum { |i| i.listing.price * i.quantity } * 1.05).round(2) %></h2>
</div>
```

- [ ] **Step 3: Commit**
```bash
git add .
git commit -m "feat: implement purchase request logic and fee calculation"
```

---

### Task 3: Seller Dashboard ("Mis Ventas")

**Files:**
- Create: `app/controllers/sales_controller.rb`
- Create: `app/views/sales/index.html.erb`
- Modify: `config/routes.rb`

- [ ] **Step 1: Add routes**
```ruby
# In config/routes.rb inside locale scope
resources :sales, only: [:index] do
  member do
    patch :accept
    patch :reject
  end
end
```

- [ ] **Step 2: Create SalesController**
```ruby
class SalesController < ApplicationController
  before_action :require_authentication

  def index
    @pending_sales = Order.where(seller: Current.user, status: "pending_approval").includes(order_items: { listing: :card })
    @completed_sales = Order.where(seller: Current.user).where.not(status: "pending_approval").order(created_at: :desc)
  end

  def accept
    @order = Order.find_by!(id: params[:id], seller: Current.user)
    @order.update!(status: "accepted", buyer_notification_seen: false)
    redirect_to sales_path, notice: "¡Venta aceptada exitosamente!"
  end

  def reject
    @order = Order.find_by!(id: params[:id], seller: Current.user)
    ActiveRecord::Base.transaction do
      @order.update!(status: "rejected", buyer_notification_seen: false)
      # Devolver stock
      @order.order_items.each do |item|
        item.listing.update!(stock: item.listing.stock + item.quantity)
      end
    end
    redirect_to sales_path, notice: "Venta rechazada. El stock ha sido devuelto."
  end
end
```

- [ ] **Step 3: Create Sales View (index.html.erb)**
Reutilizar diseño de `purchases/index.html.erb` pero con botones de acción.

- [ ] **Step 4: Commit**
```bash
git add .
git commit -m "feat: add sales dashboard for sellers"
```

---

### Task 4: Notification System (Badges)

**Files:**
- Modify: `app/views/layouts/application.html.erb`
- Modify: `app/controllers/purchases_controller.rb`

- [ ] **Step 1: Add "Mis Ventas" to navigation and badges**
```erb
<%# In application.html.erb nav section %>
<% pending_sales_count = Order.where(seller: Current.user, status: "pending_approval").count %>
<%= link_to sales_path, style: 'position: relative; ...', class: "btn-interactive" do %>
  <%= t("layout.my_sales") %>
  <% if pending_sales_count > 0 %>
    <span style="position: absolute; top: -5px; right: -5px; background: #E3350D; color: white; border-radius: 50%; padding: 2px 6px; font-size: 8px;"><%= pending_sales_count %></span>
  <% end %>
<% end %>

<% has_new_purchase_updates = Order.where(client: Current.user, buyer_notification_seen: false).where.not(status: "pending_approval").exists? %>
<%= link_to purchases_path, style: 'position: relative; ...', class: "btn-interactive" do %>
  <%= t("purchases.title") %>
  <% if has_new_purchase_updates %>
    <span style="position: absolute; top: -5px; right: -5px; background: #E3350D; color: white; border-radius: 50%; padding: 2px 6px; font-size: 8px;">!</span>
  <% end %>
<% end %>
```

- [ ] **Step 2: Mark purchase notifications as seen when entering index**
```ruby
# In app/controllers/purchases_controller.rb
def index
  @orders = Order.where(client_id: Current.user.id).order(created_at: :desc)
  @orders.where(buyer_notification_seen: false).update_all(buyer_notification_seen: true)
end
```

- [ ] **Step 3: Commit**
```bash
git add .
git commit -m "feat: implement notification badges for buyers and sellers"
```
