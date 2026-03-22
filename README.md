#  BT2: Enterprise Recruitment & Talent Management System

![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen)
![Python](https://img.shields.io/badge/Backend-Python_3.13-3776AB)
![Flask](https://img.shields.io/badge/Framework-Flask-000000)
![UI](https://img.shields.io/badge/UX-Glassmorphism-blue)
![Database](https://img.shields.io/badge/DB-SQL_Server-CC2927)
![License](https://img.shields.io/badge/License-MIT-green)

**BT2** es una solución integral de reclutamiento (ATS - Applicant Tracking System) diseñada para centralizar y optimizar la vinculación entre empresas de alto nivel y profesionales. Este proyecto personal implementa una arquitectura **Full Stack** orientada a la eficiencia, seguridad de datos y una experiencia de usuario inmersiva.

---

##  Key Features (Módulos Críticos)

###  High-Fidelity UI/UX
* **Glassmorphism Design:** Interfaz moderna basada en capas de transparencia y desenfoque (blur) mediante CSS3 avanzado y Bootstrap 5.3.
* **Dynamic Interactivity:** Uso de **Swiper.js** para sliders de ofertas destacadas y testimonios con soporte táctil y de ratón.
* **Multimedia Engine:** Fondos de video optimizados en los módulos de `Login` y `Registro` para maximizar la retención del usuario.

###  Backend & Business Logic
* **RESTful Architecture:** Motor en Flask que gestiona peticiones asíncronas y separa la lógica de negocio del cliente.
* **Security & Auth:** Validación de sesiones, cifrado de credenciales y protección contra inyecciones mediante sanitización de inputs.
* **File Management:** Sistema de carga y validación de Currículums en formato PDF, asegurando la integridad de los documentos.

###  Database & Analytics
* **Relational Schema:** Diseño de base de datos robusto (SQL Server) optimizado para consultas rápidas de vacantes y perfiles.
* **Admin Dashboard:** Panel de control centralizado para la supervisión de métricas, validación de empresas y gestión de postulaciones.

---

##  Stack Tecnológico

| Capa | Tecnologías |
| :--- | :--- |
| **Frontend** | HTML5, CSS3 (Variables, Glassmorphism), JavaScript (ES6+), Bootstrap 5.3 |
| **Backend** | Python 3.13, Flask Framework |
| **Database** | SQL Server (Esquema relacional en `BDD_BT.sql`) |
| **Libraries** | Swiper.js, Bootstrap Icons, Animate.css |
| **DevOps** | Git, Venv (Virtual Environments), .gitignore |

---

##  Vistas



---
##  Estructura del Ecosistema

El repositorio mantiene una organización modular estricta para garantizar la escalabilidad:

```text
BT2/
├── app.py              # Motor principal (Backend Flask)
├── index.html          # Landing Page & Entry Point
├── BDD_BT.sql          # Arquitectura de la Base de Datos
├── css/                # Hojas de estilo modulares (Index, Login, Dashboard)
├── js/                 # Lógica de interacción y validaciones
├── multimedia/         # Assets: Video-backgrounds, Logos, Images
└── src/                # Vistas secundarias
    ├── login.html      # Gestión de accesos
    ├── registro.html   # Captura de nuevos perfiles
    ├── dashboard.html  # Panel de usuario/admin
    └── [otros].html    # Documentación legal y soporte
