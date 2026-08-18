class Admin::FinancialsController < Admin::ApplicationController
  def index
    # 1. Ganancias Totales (3% de órdenes aceptadas/completadas)
    @total_earnings = Order.where(status: [ "accepted", "delivered", "completed" ]).sum(:service_fee)

    # 2. Bóveda Escrow (Total de órdenes pendientes)
    @escrow_vault = Order.where(status: "pending_approval").sum(:total_price)

    # 3. Vendedor Estrella (Usuario con más ventas aceptadas)
    star_seller_data = Order.where(status: [ "accepted", "delivered", "completed" ])
                            .group(:seller_id)
                            .order("count_id DESC")
                            .count(:id)
                            .first
    @star_seller = User.find_by(id: star_seller_data&.first)&.username || "---"

    # 4. Día de Oro (Fecha con más ganancias)
    golden_day_data = Order.where(status: [ "accepted", "delivered", "completed" ])
                           .group("DATE(created_at)")
                           .order("sum_service_fee DESC")
                           .sum(:service_fee)
                           .first
    @golden_day = golden_day_data&.first&.to_date&.strftime("%d/%m/%Y") rescue "---"

    # 5. Volumen de Mercado (Suma de total_price no rechazados)
    @market_volume = Order.where.not(status: "rejected").sum(:total_price)

    # 6. Historial de Transacciones (Ledger)
    @orders = Order.includes(:client, :seller).order(created_at: :desc).limit(100)
  end
end
