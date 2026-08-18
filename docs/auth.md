# 🔑 Sistema de Autenticación

Para este proyecto, hemos implementado el sistema de autenticación nativo introducido en **Rails 8**. Siguiendo el principio **KISS**, evitamos gemas pesadas y optamos por una solución simple.

## 1. ¿Cómo se construyó?
Se utilizó el generador oficial de Rails 8:
```bash
bin/rails generate authentication
bin/rails db:migrate
```

Este comando configuró automáticamente los modelos, controladores y la seguridad base necesaria para el manejo de sesiones.

## 2. Arquitectura del Sistema

| Componente             | Archivo                                 | Función                                                        |
|------------------------|-----------------------------------------|----------------------------------------------------------------|
| Modelo User            | app/models/user.rb                      | Representa al Entrenador. Usa has_secure_password.              |
| Modelo Session         | app/models/session.rb                   | Rastrea quién está conectado y desde dónde.                     |
| Atributos Globales     | app/models/current.rb                   | Permite acceder al usuario actual con Current.user.             |
| Controlador Sesiones   | app/controllers/sessions_controller.rb  | Maneja el Login y Logout.                                       |
| Controlador Password   | app/controllers/passwords_controller.rb | Flujo de recuperación de contraseña.                            |

## 3. Seguridad y Encriptación
### A. Las contraseñas (BCrypt)

No guardamos contraseñas en texto plano en la base de datos (eso seria un riesgo crítico). Usamos el algoritmo **BCrypt**. Cuando un usuario se registra con la clave "password123", Rails lo transforma en un "hash" matemático inentendible (ej. $2a$12$KIX...) llamado password_digest. Al iniciar sesión, Rails compara matemáticamente los hashes, por lo que la base de datos jamás conoce la clave real.

### B. El Estado de la Sesión (Cookies)

El protocolo web (HTTP) no recuerda quién eres al cambiar la pagina. Para solucionar esto, cuando inicias sesión con éxito, el servidor genera una **Cookie HttpOnly** (una credencial temporal encriptada) y la guarda en tu navegador. El **ApplicationController** lee esta cookie en cada clic para dejarte pasar.

### C. Recuperación de Claves (Tokens temporales)

No podemos mostrar contraseñas antiguas. Cuando un usuario olvida su clave, Rails genera un Token (una cadena de texto aleatoria temporal) y lo envia por correo. Ese link funciona como un "Pase VIP" de un solo uso que expira en 15 minutos para permitir crear una clave nueva de forma segura.

## 4. Diseño e Interfaz (CSS Aislado)

Para las pantallas de acceso, diseñamos una interfaz temática (Una pokebola sobre Pueblo Paleta) usando CSS puro. 

### Aislamiento de Estilos:
Para evitar que el fondo borroso y el mapa afecten a las paginas internas de la aplicación (como el Dashboard), encapsulamos todo el CSS del login dentro de una clase llamada ```.poke-page```

- El ```<body>``` principal de la app se mantiene limpio
- Solo las rutas de ```/session/new``` y ```/registration/new``` estan envueltas en ```<div class="poke-page">```, garantizando que cada componente de la app tenga su propio diseño sin conflictos globales. 

## 5. El Flujo de Uso:
El sistema ya cuenta con una interfaz gráfica completa para todo el ciclo de vida del usuario:

1. **Sign Up (Registro)**: Entra a ```localhost:3000/registration/new``` (o haz clic en "¡Regístrate!" en la portada). Llena el formulario con tu email y contraseña. Al registrarte, el sistema te inicia sesión automaticamente. 
2. **Log In (Iniciar Sesión)**: Si ya tienes cuenta, entra a ```localhost:3000/session/new```. Al poner tus credenciales correctas, el servidor crea tu sesión.
3. **Página Protegida**: Una vez dentro, serás redirigido al Dashboard interno (welcome#index), donde verás un mensaje dinámico con tu Current.user.email_address.
4. **Log Out (Cerrar Sesión)**: Dentro del Dashboard hay un botón rojo. Este botón ejecuta una petición tipo DELETE al servidor (por seguridad web, no usamos un enlace normal GET). Esto destruye la cookie de tu navegador y te devuelve al Login, cerrando el ciclo.

## 6. Recuperar contraseña:

El envío de correos funciona distinto dependiendo de si estás en localhost: o en la web real:

- **En tu computador (Localhost)**: Para no hacer spam, no se envía un correo de verdad. Si pides recuperar tu clave, ve a la terminal donde corriste rails s. Verás un montón de texto verde simulando el correo. Busca ahí adentro un link largo, cópialo y pégalo en tu navegador para cambiar tu clave.
- **En Internet (Producción en Render)**: La app ya está conectada de verdad a Gmail. Si pides recuperar tu clave en la página pública, ¡el correo sí te llegará a tu bandeja de entrada!