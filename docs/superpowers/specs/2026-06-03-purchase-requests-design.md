# Spec: Sistema de Solicitudes de Compra y Mediación (Escrow)

## 1. Introducción
Este sistema transforma el proceso de compra actual (directo y automático) en un modelo de **Solicitud de Compra** con mediación de la plataforma. La aplicación actuará como intermediaria, reteniendo el pago (ficticio) y cobrando un cargo por servicio hasta que el vendedor decida aceptar o rechazar la transacción.

## 2. Objetivos
- Implementar un flujo de aprobación de ventas por parte del vendedor.
- Incorporar un **Cargo por Servicio del 5%** (Modelo PuntoTicket: el comprador paga el extra).
- Gestionar el stock de forma segura (reserva al solicitar, liberación al rechazar).
- Crear un sistema de notificaciones visuales mediante badges (círculos rojos) en el menú.

## 3. Modelo de Datos (Cambios)

### Tabla `orders` (Nuevos Campos)
- `subtotal`: decimal (Monto que recibe el vendedor).
- `service_fee`: decimal (Cargo del 5% para la app).
- `total_price`: decimal (`subtotal + service_fee`, monto pagado por el comprador).
- `status`: String (Estados: `pending_approval`, `accepted`, `rejected`).
- `buyer_notification_seen`: boolean (Para el badge `!` del comprador).

### Lógica de Stock
- **Al crear la solicitud:** El stock del `Listing` disminuye inmediatamente.
- **Si se rechaza:** El stock del `Listing` aumenta de nuevo.

## 4. Flujo de Usuario

### A. Comprador (Checkout)
1. El usuario ve en su carrito el subtotal y el cargo por servicio (5%).
2. Al presionar "Pagar", se crean las órdenes en estado `pending_approval`.
3. Se muestra un Pop-up de éxito informando que se ha enviado la solicitud al vendedor.

### B. Vendedor (Nueva Sección "Mis Ventas")
1. Verá un indicador (badge rojo con número) en el menú.
2. En la vista "Mis Ventas", podrá ver las solicitudes con botones **[ ACEPTAR ✅ ]** y **[ RECHAZAR ❌ ]**.
3. Al aceptar, el estado pasa a `accepted`.
4. Al rechazar, el estado pasa a `rejected` y se devuelve el stock.

### C. Sistema de Notificaciones
- **Vendedor:** Badge rojo con el conteo de órdenes `pending_approval` dirigidas a él.
- **Comprador:** Badge rojo con un `!` en "Mis Compras" si tiene órdenes que cambiaron a `accepted` o `rejected` y no han sido vistas (`buyer_notification_seen: false`).

## 5. Diseño Visual
- Se mantendrá la estética **Pokedex/Retro GBA** actual.
- Los botones de Aceptar/Rechazar usarán los colores estándar: Verde (`#4CAF50`) y Rojo (`#E3350D`).
- Los badges de notificación serán círculos rojos pequeños con fuente 'Press Start 2P'.

## 6. Plan de Trabajo (Resumen)
1. Generar migración para actualizar la tabla `orders`.
2. Actualizar `CartsController#checkout` para calcular comisiones y estados.
3. Crear `SalesController` y vista `sales/index.html.erb` (Mis Ventas).
4. Implementar lógica de botones Aceptar/Rechazar en `SalesController`.
5. Actualizar `application.html.erb` para mostrar los badges de notificación.
