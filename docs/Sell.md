# Relatos 6, 8 y 12: Carrito de Compras y Realización de Compra

## Descripción
Se implementó un sistema de gestión de compras que permite a los Entrenadores seleccionar cartas de otros vendedores, gestionar su mochila de ítems y finalizar la adquisición mediante un proceso de "Trato Hecho".

## Lo que se hizo:
1.  **Mochila Pokémon (Carrito):**
    *   Interfaz dedicada para revisar los ítems seleccionados.
    *   Cálculo automático de totales según cantidad y precio de cada vendedor.
    *   Traducciones temáticas (ej: "Mochila" en lugar de "Carrito").
2.  **Lógica de Compra (Checkout):**
    *   **Procesamiento por Vendedor:** Al realizar la compra, el sistema agrupa automáticamente los ítems y genera una `Order` individual para cada vendedor involucrado.
    *   **Actualización de Stock en Tiempo Real:** Al confirmar la compra ("Pagar Todo"), el sistema descuenta automáticamente las unidades adquiridas del inventario del vendedor.
    *   **Gestión de Agotados:** Si el stock de una carta llega a 0, esta desaparece automáticamente de la tienda pública. En la sección del vendedor, se muestra con una línea roja diagonal y la etiqueta "SIN STOCK".
3.  **Seguridad y Restricciones:**
    *   **Validación de Stock al Añadir:** No se permite añadir más unidades de las disponibles en el carrito.
    *   **Filtro Anti-Autocompra:** Los usuarios no pueden ver ni comprar sus propias cartas en la galería principal.
    *   **Integridad de Datos:** Todo el proceso de compra se ejecuta dentro de una transacción de base de datos (si algo falla, nada se procesa).
4.  **UX Temática:** Mensajes de confirmación estilo GBA al completar la transacción con éxito.

## Pendientes / Limitaciones (Sprint 1):
*   **Buzón de Vendedor:** Actualmente el stock se descuenta y la orden se crea en la base de datos, pero **aún no se ha implementado la interfaz de notificaciones o buzón** para que el vendedor vea quién le compró (se delegó para el Sprint 2).
*   **Gestión de Pedidos:** El cliente puede comprar, pero aún no tiene una vista de historial para ver el estado de sus solicitudes (Pendiente/Enviado).
*   **Pasarela de Pago:** Como indica la rúbrica, el pago es externo y no es gestionado por la plataforma en esta etapa.
