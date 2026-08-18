# 📊 Documentación del Modelo de Datos (Diagrama E/R)

Este documento explica la estructura de la base de datos para nuestro **Marketplace de Cartas Pokémon**. El modelo ha sido refinado para el Sprint 1 para cumplir con los requisitos académicos de multivendedor y gestión de catálogo bajo demanda.

---

## 🛠 Diagrama DBML (Para dbdiagram.io)

```dbml
// Marketplace de Cartas Pokémon Perfeccionado - Grupo 97
// IIC2143 Ingeniería de Software 2026-1
// Estado: Sprint 1 Finalizado

Table users {
  id integer [primary key]
  email_address varchar [unique, not null]
  password_digest varchar [not null]
  username varchar [unique, not null]
  is_admin boolean [default: false]
  created_at timestamp
  updated_at timestamp
}

Table sessions {
  id integer [primary key]
  user_id integer [not null]
  ip_address varchar
  user_agent varchar
  expires_at timestamp
  created_at timestamp
}

Table cards {
  id integer [primary key]
  name varchar [not null]
  card_number varchar [note: 'Ej: 04/102']
  expansion varchar [note: 'Set al que pertenece']
  rarity varchar
  energy_type varchar [note: 'Fuego, Agua, etc.']
  release_year integer
  image_url varchar [note: 'URL oficial de la API']
  created_at timestamp
  updated_at timestamp
}

Table listings {
  id integer [primary key]
  seller_id integer [not null]
  card_id integer [not null]
  price decimal [not null]
  stock integer [default: 1]
  condition varchar [note: 'Mint, Near Mint, Played']
  status varchar [default: 'active', note: 'active o sold_out']
  created_at timestamp
  updated_at timestamp
}

Table carts {
  id integer [primary key]
  user_id integer [not null]
  created_at timestamp
  updated_at timestamp
}

Table cart_items {
  id integer [primary key]
  cart_id integer [not null]
  listing_id integer [not null]
  quantity integer [default: 1]
  created_at timestamp
  updated_at timestamp
}

Table orders {
  id integer [primary key]
  client_id integer [not null]
  seller_id integer [not null, note: 'Cada orden pertenece a un vendedor específico']
  status varchar [default: 'pending', note: 'pending, accepted, delivered']
  created_at timestamp
  updated_at timestamp
}

Table order_items {
  id integer [primary key]
  order_id integer [not null]
  listing_id integer [not null]
  unit_price decimal [note: 'Precio capturado al momento de la compra']
  quantity integer
}

Table reviews {
  id integer [primary key]
  order_item_id integer [unique, not null]
  item_rating integer [note: 'Calificación del producto (1 a 5)']
  seller_rating integer [note: 'Calificación del vendedor (1 a 5)']
  comment text
  created_at timestamp
}

// Relaciones de Integridad
Ref: sessions.user_id > users.id
Ref: listings.seller_id > users.id
Ref: listings.card_id > cards.id
Ref: carts.user_id - users.id
Ref: cart_items.cart_id > carts.id
Ref: cart_items.listing_id > listings.id
Ref: orders.client_id > users.id
Ref: orders.seller_id > users.id
Ref: order_items.order_id > orders.id
Ref: order_items.listing_id > listings.id
Ref: reviews.order_item_id - order_items.id
```

---

## 1. Identidad y Acceso (Core)

### `users`
Es el corazón de la plataforma.
- **Roles**: Un usuario puede ser comprador y vendedor simultáneamente. Solo se diferencia el rol de administrador mediante `is_admin`.
- **Username**: Nombre de Entrenador único, utilizado para la identidad pública en el marketplace.

---

## 2. El Mercado (Catálogo e Inventario)

Separamos la información en dos tablas para no repetir datos (Normalización):

### `cards` — El Catálogo (Enciclopedia)
Contiene los datos estáticos y oficiales de las cartas obtenidos mediante la Pokémon TCG API.
- **`energy_type` y `release_year`**: Esenciales para el sistema de filtros avanzados.

### `listings` — La Vitrina (Publicaciones)
Es lo que cada vendedor pone a la venta. Aquí vive el **precio**, el **stock** y el **estado** (Mint, Played).

---

## 3. Flujo de Compra (Multivendedor)

El sistema está diseñado para manejar carritos mixtos de forma eficiente.

### `carts` y `cart_items`
Siguen la convención de Rails para persistir la selección del usuario antes de la compra.

### `orders` y `order_items`
Al realizar una compra, el sistema divide el carrito en **múltiples órdenes (una por cada vendedor)**. Esto permite que cada vendedor gestione su propio estado (Pendiente/Aceptado) de forma independiente, cumpliendo con la rúbrica del proyecto.

---

## 4. Confianza y Feedback

### `reviews`
Reseñas duales que califican tanto el **artículo** como al **vendedor**, garantizando transparencia total en la comunidad de entrenadores.

---

## 🛠 Consideraciones Técnicas

1. **Integridad Referencial**: Uso de claves foráneas para asegurar que no existan ítems de carrito o de órdenes huérfanos.
2. **Normalización**: La separación de `cards` y `listings` previene la duplicación de datos oficiales y asegura la consistencia del catálogo.
3. **Escalabilidad**: El diseño de órdenes separadas por vendedor permite que el sistema crezca sin conflictos en transacciones multivendedor complejas.
