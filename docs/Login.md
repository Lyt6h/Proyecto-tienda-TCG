# Relatos 10 y 20: Inicio y Cierre de Sesión (Versión Mejorada)

## Descripción
Se implementó un sistema de autenticación robusto y flexible con una experiencia de usuario temática de Pokémon GBA.

## Lo que se hizo:
1.  **Login Híbrido Pro:** El sistema detecta automáticamente si el usuario ingresó su **Email** o su **Nombre de Entrenador (Username)**.
2.  **Seguridad Anti-Fuerza Bruta:** Implementación de `rate_limit` (máximo 10 intentos por cada 3 minutos) para proteger las cuentas.
3.  **UX Estilo GBA:**
    *   **Alertas con Animación:** Los errores de credenciales activan un cuadro de alerta rojo con efecto de sacudida (*shake*).
    *   **Limpieza de Interfaz:** Se eliminaron las alertas duplicadas en el header para centralizar todo en el formulario.
    *   **Privacidad Extrema:** Se aplicaron nombres de campos dinámicos para bloquear el autocompletado persistente de los navegadores modernos.
4.  **Gestión de Configuración:** El menú de ajustes (tuerca) ahora se cierra automáticamente al cerrar sesión para garantizar una interfaz limpia al siguiente usuario.
5.  **Internacionalización:** Soporte completo para Español e Inglés en mensajes de error y bienvenida.

## Pendientes / Mejoras Futuras:
*   **Recuérdame:** Implementar cookies de larga duración (30 días).
*   **Recuperación por Email:** Integrar un servicio de correos real en el siguiente sprint.
