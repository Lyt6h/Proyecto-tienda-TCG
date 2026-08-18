# Spec: Admin Financial Dashboard (Libro Contable)

## 1. Introducción
Este sistema proporciona a los administradores una herramienta de análisis financiero para supervisar las ganancias de la plataforma, el flujo de dinero en mediación (escrow) y el rendimiento de los usuarios. Se implementará como una nueva sección dentro del panel de administración.

## 2. Objetivos
- Visualizar de forma centralizada las ganancias por cargos de servicio (3%).
- Supervisar el dinero retenido en solicitudes de compra pendientes.
- Identificar a los usuarios con mejor desempeño en ventas.
- Mantener la integridad de los datos financieros históricos.
- Soporte completo para multi-idioma (I18n).

## 3. Requerimientos Funcionales

### A. Indicadores Clave (KPI Cards)
La vista superior mostrará 5 métricas críticas:
1. **Ganancias Totales:** Suma de `service_fee` de todas las órdenes con estado `accepted`, `delivered` o `completed`.
2. **Bóveda Escrow:** Suma de `total_price` de todas las órdenes con estado `pending_approval`.
3. **Vendedor Estrella:** Usuario con el mayor número de órdenes en estado `accepted`.
4. **Día de Oro:** Fecha con la mayor suma de `service_fee` recolectada.
5. **Volumen de Mercado:** Suma de `total_price` de todas las órdenes registradas (excluyendo rechazadas).

### B. Registro de Transacciones (Ledger Table)
Una tabla con paginación que detalle cada transacción:
- ID de la Orden.
- Fecha y Hora.
- Cliente (Comprador) y Vendedor.
- Desglose: Subtotal, Fee (3%), Total.
- Estado actual (con código de colores retro).

### C. Navegación e Internacionalización
- **Acceso:** Botón "Libro Contable 💵" en el Dashboard de Admin.
- **I18n:** Todas las etiquetas, títulos y mensajes de error estarán disponibles en `es` y `en`.

## 4. Diseño Técnico

### Controlador
`Admin::FinancialsController#index`
- Encargado de realizar los cálculos de agregación de SQL (Sum, Count, Group By).

### Rutas
`get "/admin/financials", to: "admin/financials#index", as: :admin_financials`

### Vista
`app/views/admin/financials/index.html.erb`
- Usará el contenedor `pokedex-frame-large`.
- Estilos CSS consistentes con el diseño administrativo actual.

## 5. Casos de Prueba
- Verificar que solo los administradores puedan acceder a la vista.
- Validar que los cálculos de comisión (3%) coincidan con la base de datos.
- Asegurar que el cambio de idioma actualice todos los campos del dashboard.
