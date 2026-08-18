# Relato 9: Registro de Usuarios (Entrenadores)

## Descripción
Se implementó un sistema de registro para nuevos usuarios, permitiéndoles unirse a la plataforma como "Entrenadores". El flujo está diseñado para ser sencillo, seguro y temático, capturando los datos esenciales para la operación del marketplace.

## Lo que se hizo:
1.  **Nuevos Atributos de Usuario:** Se extendió la tabla `users` para incluir `username` (Nombre de Entrenador), el cual es único y obligatorio.
2.  **Formulario Temático:** Interfaz inspirada en una Pokebola GBA con diseño responsivo.
3.  **Seguridad y Validaciones:**
    *   **Autenticación:** Uso de `has_secure_password` (BCrypt) para el hash de contraseñas.
    *   **Username Alfanumérico:** Validación estricta que solo permite letras y números (sin espacios ni símbolos), evitando problemas de formato.
    *   **Longitud de Contraseña:** Se exige un mínimo de 6 caracteres para mejorar la seguridad de las cuentas.
    *   **Unicidad:** Validación a nivel de modelo para asegurar que no existan correos o nombres de usuario duplicados (insensible a mayúsculas/minúsculas).
    *   **Protección de Privacidad:** Bloqueo de auto-rellenado del navegador en campos sensibles (`autocomplete: off`).
4.  **Experiencia de Usuario (UX) Pokémon:**
    *   **Manejo de Errores Contextual:** En lugar de listas de texto planas, se implementó un sistema de alertas individuales por campo.
    *   **Tooltips GBA:** Iconos de advertencia (⚠️) que, al pasar el mouse, despliegan un globo de texto con estilo retro (Rojo Fuego) explicando el error.
5.  **Internacionalización (i18n):** Todo el flujo de registro y sus mensajes de error están totalmente traducidos al Español (ES) e Inglés (EN).
6.  **Robustez de Navegación:** Implementación de rutas con *scope* de lenguaje para evitar errores de página no encontrada al cambiar de idioma durante el registro.

## Pendientes / Mejoras Futuras:
*   **Validación de Formato de Email:** Aunque se valida la presencia, falta una validación por expresión regular (Regex) más estricta en el servidor.
