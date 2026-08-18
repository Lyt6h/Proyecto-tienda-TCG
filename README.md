# Grupo 97 - Marketplace de Cartas Pokémon

## 🚀 Link Página Web
[two026-1-grupo-97.onrender.com](https://two026-1-grupo-97.onrender.com)

---

## 🛠️ Guía para Levantar la App Localmente

Sigue estos pasos para configurar tu entorno de desarrollo desde cero y tener los datos de prueba listos.

### 1. Instalar dependencias 
Asegúrate de tener Ruby instalado (revisar `.ruby-version`).
```bash
bundle install
```

### 2. Configurar la Base de Datos
Este comando creará la base de datos, aplicará las migraciones y cargará los **datos iniciales** (Cartas oficiales de la API y usuarios de prueba).
```bash
bin/rails db:setup
```
*Nota: Si ya tienes la base de datos creada y solo quieres actualizar los datos, usa `bin/rails db:seed`.*

### 3. Levantar el Servidor Local
```bash
bin/rails server
```
Visita [localhost:3000](http://localhost:3000) para ver la app corriendo.

---

## 📊 Diagrama Entidad-Relación (E/R)

![Diagrama Entidad-Relación](docs/diagram.png)

*Puedes encontrar el detalle técnico y el código DBML en la [Guía del Diagrama](docs/diagram.md).*

---

## 👨🏻‍💼 Vista Administrador:

Se puede logear a la vista del administrador con las siguientes credenciales:

Username: admin
Contraseña: password123.

Ahi se puede ver a todos los usuarios registrados en la app y mas detalles. El admin tiene control de eliminar/banear usuarios y tambien de eliminar publicaciones.

## 📚 Documentación del Sprint 1

Hemos documentado cada una de las funcionalidades implementadas en este sprint para facilitar la revisión y el desarrollo futuro:

*   👤 **[Guía de Registro (Relato 9)](docs/Register.md)** - Detalles sobre el registro de entrenadores y validaciones GBA.
*   🔑 **[Guía de Inicio de Sesión (Relatos 10 y 20)](docs/Login.md)** - Funcionamiento del login híbrido y gestión de sesiones.
*   🃏 **[Guía de Catálogo e Inspección (Relato 7)](docs/Catalog.md)** - Cómo funciona el buscador y la vista de detalle.
*   🛒 **[Guía de Ventas y Carrito (Relatos 6, 8 y 12)](docs/Sell.md)** - Lógica de compra, reducción de stock y órdenes.
*   🌐 **[Guía de Internacionalización (i18n)](docs/i18n.md)** - Cómo manejar los idiomas (ES/EN) en el proyecto.
*   🛡️ **[Guía de Autenticación](docs/auth.md)** - Detalles técnicos sobre la seguridad y el acceso.
*   📐 **[Especificación del Diagrama](docs/diagram.md)** - Explicación detallada del modelo de datos.

---

## ✅ Otros

*   **Setup RuboCop:** El análisis estático de código ya está configurado y se recomienda ejecutarlo antes de cada commit: `bundle exec rubocop`.
