-- Creación de la base de datos
CREATE DATABASE BDD_BT
GO

use BDD_BT

-- Tabla de estatus de usuario
CREATE TABLE estatus_usuario(
    id_estatus INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL
);
GO

INSERT INTO estatus_usuario (descripcion) 
VALUES 
('Activo'),
('Inactivo');
GO

-- Tabla de estado del CV
CREATE TABLE estado_cv(
    id_estado_cv INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL
);
GO

INSERT INTO estado_cv (descripcion) 
VALUES 
('Activo'),
('Inactivo');
GO



-- Tabla de usuarios
CREATE TABLE usuarios(
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100),
    correo_electronico VARCHAR(150),
    contraseña VARCHAR(255) NOT NULL,
    id_estatus INT NOT NULL,
    id_estado_cv INT NOT NULL,
    FOREIGN KEY(id_estatus) REFERENCES estatus_usuario(id_estatus),
    FOREIGN KEY(id_estado_cv) REFERENCES estado_cv(id_estado_cv)
);
GO
insert into usuarios(nombre,apellido_paterno,apellido_materno,correo_electronico,contraseña,id_estatus,id_estado_cv)values('hola','hola','hola','hola','hola',1,1)
select*from usuarios


-- Inserción de usuarios
INSERT INTO usuarios (nombre, apellido_paterno, apellido_materno, correo_electronico, contraseña, id_estatus, id_estado_cv) 
VALUES 
('Roque Josue', 'Aguirre', 'Viveros', '123048138@upq.edu.mx', 'Contrasena', 1, 1),
('Erick', 'Alvarez', 'Balderas', '123047831@upq.edu.mx', '123047831', 1, 1),
('Guillermo', 'Alvarez', 'Sanchez', '124050514@upq.edu.mx', '123456789', 1, 1),
('Emiliano', 'Arvizu', 'Rueda', '123045464@upq.edu.mx', '123045464', 1, 1),
('Rafael', 'Baltazar', 'Bonifacio', '123047965@upq.edu.mx', '123047965', 1, 1),
('Eduardo', 'Barron', 'Mendoza', '123045976@upq.edu.mx', '123456789', 1, 1),
('Fernando Daniel', 'Bello', 'Garcia', '123047331@upq.edu.mx', '123047331', 1, 1),
('Maria Cruz', 'Camargo', 'Araujo', '123047616@upq.edu.mx', '210520223', 1, 1),
('Armando Yael', 'Contreras', 'Bejarano', '123047499@upq.edu.mx', '123456789', 1, 1),
('Ana', 'Francisco', 'Nicolas', '123047674@upq.edu.mx', '789012', 1, 1),
('Eduardo', 'Gutierrez', 'Rodriguez', '123048272@upq.edu.mx', 'Heisenberg', 1, 1),
('Luis Fernando', 'Hernandez', 'Dimas', '123045484@upq.edu.mx', '123456789', 1, 1),
('Carlos Alexis', 'Hernandez', 'Ortega', '123047522@upq.edu.mx', '123456789', 1, 1),
('Maria Ines', 'Hernandez', 'Vicencio', '123046059@upq.edu.mx', '123046059', 1, 1),
('Cristopher Josue', 'Herrera', 'Marquina', '123046753@upq.edu.mx', '123456789', 1, 1),
('Jesus', 'Jimenez', 'De Santiago', '123048152@upq.edu.mx', '147852369', 1, 1),
('Alan', 'Jimenez', 'Moran', '123046361@upq.edu.mx', '123046361', 1, 1),
('Maria Guadalupe', 'Jimenez', 'Ruiz', '123046400@upq.edu.mx', '123046400', 1, 1),
('Roberto Mauricio', 'Maya', 'Maldonado', '123047833@upq.edu.mx', '123047833', 1, 1),
('Victor Manuel', 'Molina', 'Caballero', '123046006@upq.edu.mx', 'Charlys123', 1, 1),
('Dulce Maria', 'Morales', 'De Leon', '123046554@upq.edu.mx', '123046554', 1, 1),
('Cristopher Yanhyu', 'Munoz', 'Prado', '123046803@upq.edu.mx', 'Y4nh7u190d3g3m', 1, 1),
('Jose Angel', 'Nieves', 'Franco', '123046088@upq.edu.mx', 'qwerty', 1, 1),
('Andres', 'Rangel', 'Martinez', '122044956@upq.edu.mx', 'Abelardo2021', 1, 1),
('Aaron', 'Sanchez', 'Cervantes', '124050643@upq.edu.mx', 'Aaron123', 1, 1),
('Gabriel Ivan', 'Villafuerte', 'Armenta', 'gabriel.ivan@upq.edu.mx', 'Anexo420', 1, 1);
GO

CREATE TABLE administradores(
    id_administrador INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(100) NOT NULL,
    apellido_materno VARCHAR(100),
    correo_electronico VARCHAR(150),
    contraseña VARCHAR(255) NOT NULL,
);
GO
insert into administradores(nombre,apellido_paterno,apellido_materno,correo_electronico,contraseña)values('prueba','prueba','prueba','prueba@prueba','prueba')
select*from usuarios


-- Tabla de puestos
CREATE TABLE puestos(
    id_puesto INT IDENTITY(1,1) PRIMARY KEY,
    nombre_puesto VARCHAR(100) NOT NULL
);
GO

INSERT INTO Puestos (nombre_puesto) 
VALUES 
('CEO'),
('Full Stack Developer'),
('Project Manager'),
('Policia Cibernetico'),
('Administrador de Base de Datos'),
('Desarrollador Web Front-End'),
('Trainee Soporte TI'),
('Administrador de sistemas'),
('Cientifico De Datos'),
('Analista de Sistemas'),
('Frontend Developer'),
('Especialista en ciberseguridad'),
('Tecnico en redes'),
('Administrador de Redes'),
('Desarrollador Full Stack'),
('Administrador de soporte tecnico'),
('Control de Calidad y ciberseguridad'),
('Otro');
GO

-- Tabla de objetivo profesional
CREATE TABLE objetivo_profesional(
    id_objetivo INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_puesto INT NOT NULL,
    salario_mensual DECIMAL(10,2),
    texto_objetivo TEXT,
    FOREIGN KEY(id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY(id_puesto) REFERENCES puestos(id_puesto)
);
GO

INSERT INTO objetivo_profesional (id_usuario, id_puesto, texto_objetivo, salario_mensual)
VALUES 
(1, 1, 'Mi objetivo personal es ganar dinero y el profesional es trabajar de la manera mas eficiente en el menor tiempo laboral.', 12000.00),
(2, 2, 'Busco seguir creciendo profesionalmente, enfrentando nuevos retos donde pueda crear soluciones completas, desde el backend solido hasta interfaces que se sientan bien al usarlas. Me gusta trabajar en equipo, compartir ideas y construir productos que realmente funcionen y se vean bien.', 15000.00),
(3, 3, 'Liderar y gestionar proyectos de manera eficiente para alcanzar los objetivos establecidos dentro del plazo, presupuesto y alcance definidos.', 18000.00),
(4, 4, 'Convertirme en un profesional altamente capacitado en ciberseguridad, especializado en la prevencion, investigacion y respuesta a delitos ciberneticos, trabajando como policia cibernetico en una institucion gubernamental o una organizacion internacional.', 20000.00),
(5, 5, 'Poder establecerme en un buen puesto de trabajo para poder seguir aprendiendo mas y fortalecer mis conocimientos para despues encontrar un mejor trabajo y tener una estabilidad laboral y economica', 11000.00),
(6, 5, 'Desarrollarme como profesional en el area de base de datos, ayudando a mantener organizacion y seguridad con los datos.', 13000.00),
(7, 3, 'Mi objetivo es liderar proyectos que realmente aporten valor, manteniendo a mi equipo motivado, cumpliendo tiempos y presupuestos sin perder de vista lo mas importante, que las cosas se hagan bien. Y claro tambien me gustaria poder viajar mucho.', 16000.00),
(8, 6, 'Desarrollar interfaces web modernas y funcionales, aportando mis habilidades front-end para mejorar la experiencia del usuario y crecer profesionalmente en el area tecnologica.', 14000.00),
(9, 7, 'Desarrollarme dentro de una empresa con el objetivo de aportar mis conocimientos y mi experiencia dentro del ambito de la tecnologia asi como el servicio al cliente', 10000.00),
(10, 8, 'Mi objetivo es poder lograr una estabilidad economica y desarrollar mas habilidades con el fin de seguir aprendiendo sobre las nuevas tecnologias', 9000.00),
(11, 9, 'Mi objetivo personal y profesional es convertirme en un cientifico de datos, poder trabajar en el extranjero y capacitarme dia con dia para llegar a ser un especialista en un mundo donde la informacion es poder.', 25000.00),
(12, 10, 'Mi objetivo es analizar las necesidades de la empresa y proporcionar soluciones tecnicas a los problemas que se presenten.', 17000.00),
(13, 11, 'Pues mi objetivo es lograr un buen sustento economico para mi familia, y poder vivir una vida comoda sin preocupaciones economicas, tambien es poder lograr todo esto, haciendo lo que me apasiona.', 12000.00),
(14, 12, 'Mi objetivo es lograr un buen sueldo y estabilidad economica con el fin de seguir aprender', 11000.00),
(15, 5, 'Tener una economia adecuada que me permita tener una vida de calidad y crecer como persona utilizando mis experiencias en el trabajo', 9500.00),
(16, 5, 'Mi objetivo profesional es poder desarrollar mis capacidades en base de datos y poder ampliar mis conocimientos en SQL, poder ampliar mis conocimientos en el mantenimiento de BD, y automatizar procesos dentro de las mismas.', 12500.00),
(17, 13, 'Mi objetivo profesional es formar parte de un equipo donde pueda adquirir conocimientos en instalacion, configuracion y mantenimiento de redes, mientras aprendiendo cosas nuevas cada dia.', 14500.00),
(18, 14, 'Mi objetivo profesional es ocupar el puesto de Administrador de Redes para disenar, implementar y gestionar infraestructuras de red escalables y seguras, optimizando su disponibilidad y rendimiento.', 16000.00),
(19, 15, 'Deseo ganar experiencia mientras me desarrollo profesionalmente', 8000.00),
(20, 15, 'Busco integrarme a un equipo innovador donde pueda aplicar mis conocimientos en desarrollo web front-end y back-end para crear soluciones tecnologicas eficientes. Mi objetivo es contribuir al crecimiento de la empresa mediante el diseno y la implementacion de aplicaciones, utilizando tecnologias como JavaScript, Python, y bases de datos SQL, al mismo tiempo que continuo desarrollando mis habilidades tecnicas y de liderazgo.', 18000.00),
(21, 14, 'Aplicar mis habilidades tecnicas para el rendimiento, seguridad y conectividad de la red de la empresa de manera optima, ademas de mantener un aprendizaje activo para contribuir a la empresa y a mi desarrollo profesional.', 15500.00),
(22, 9, 'Mi objetivo es aprender herramientas avanzadas como el deep learning para poderme convertir en un experto en tomar decisiones basada en datos y de igual manera convertirme en lider de proyectos', 22000.00),
(23, 15, 'Desarrollar proyectos en frontend y backend, y obtener un sueldo que cubra mis necesidades diarias.', 10000.00),
(24, 16, 'Desarrollar al maximo mis habilidades, aportar una perspectiva diferente a los proyectos de los cuales me encarge, y a su vez darle el apoyo necesario para que los colaboradores a mi cargo tengan una guia para explotar sus habilidades', 16000.00),
(25, 1, 'Liderar y junto con mi equipo hacer crecer la empresa a un nivel superior y llegar a dimensiones inimaginables.', 13000.00),
(26, 17, 'Desarrollar mi carrera profesional en el area de control de calidad y seguridad informatica', 14000.00);
GO

-- Tabla de experiencia profesional
CREATE TABLE experiencia_profesional(
    id_experiencia INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_puesto INT NOT NULL,
    empresa VARCHAR(150) NOT NULL,
    fecha_entrada DATE NOT NULL,
    fecha_salida DATE,
    actividades_logros TEXT,
    FOREIGN KEY(id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY(id_puesto) REFERENCES puestos(id_puesto)
);
GO

INSERT INTO experiencia_profesional (id_usuario, id_puesto, empresa, fecha_entrada, fecha_salida, actividades_logros) 
VALUES 
(1, 1, 'Microsoft', '2004-04-01', '2030-04-02', '-Liderazgo -Administracion -Planificacion'),
(2, 2, 'COBAQ', '2022-05-20', '2022-07-02', '-Mantenimiento a equipos de computo -Gestion y liderazgo de proyectos -Creacion de una pagina web usando html, css, js, php'),
(3, 3, 'Microsoft', '2008-08-28', '2009-09-29', '-Planificacion -Gestion del equipo -Seguimiento y control'),
(4, 4, 'UPQ', '2025-01-13', '2025-04-16', '-Mantenimiento preventivo y correctivo a equipos de computo'),
(5, 5, 'UPQ', '2024-09-01', '2024-12-05', '-Mantenimiento a equipos de computo'),
(6, 5, 'UPQ', '2024-01-01', '2024-06-30', '-Soporte tecnico a usuarios -Mantenimiento preventivo de equipos'),
(7, 3, 'CAM', '2022-04-14', '2023-01-01', '-Atencion a servicio a cliente - Administracion y gestion de pasaportes -Mantenimiento a equipos de computo'),
(8, 6, 'CECyTEQ', '2022-09-20', '2023-05-23', '-Creacion de paginas web basicas usando HTML, CSS y JavaScript -Diseno de sitios responsivos para que se vean bien en celular y computadora -Edicion de codigo con herramientas como Visual Studio Code'),
(9, 7, 'Mosersa', '2022-01-08', '2024-02-08', '-Supervision y administracion de tecnicos, asegurando el suministro eficiente de refacciones, herramientas y otros recursos necesarios -Calendarizacion y coordinacion de mantenimientos preventivos para los equipos de nuestros clientes -Seguimiento y gestion de actas de servicios correctivos'),
(10, 8, 'UPQ', '2024-09-06', '2024-12-13', '-Mantenimiento a equipos de computo -Prestamo de materiales -Creacion de cronogramas para mantenimientos preventivos futuros'),
(11, 9, 'DataTics', '2015-07-12', '2025-07-12', 'Creacion de algoritmos'),
(12, 10, 'Rectificadora Olvera', '2022-04-13', '2023-06-24', '-Mantenimiento preventivo y correctivo a los equipos de computo -Soporte Tecnico Remoto -Mantenimiento a la Red'),
(13, 11, 'TATA', '2023-08-01', '2025-06-24', '-Realice el mantenimiento preventivo y correctivo de maquinaria automotriz -Colabore en la implementacion de mejoras en los procesos de produccion -Participe activamente en la identificacion y solucion de problemas tecnicos en la planta'),
(14, 12, 'UPQ', '2023-10-16', '2024-12-10', '-Creacion de archivos -Administracion de documentos -Apoyo a estudiantes y profesores -Mantenimiento a equipos de computo -Coordinacion de materiales y equipos electronicos'),
(15, 13, 'CECyTEQ', '2023-06-15', '2023-06-15', '-Elaboracion de un programa administrador de asistencia usando c#, mySql y php, mantenimiento a equipos de computo, correccion de documentos administrativos'),
(16, 14, 'UPQ', '2024-09-01', '2024-12-01', '-Realize mantenimiento preventivo y correctivo a equipos de computo de los laboratorios de redes -Realice inventario -Seguimiento a los mantenimientos previos y realizacion de un cronograma para futuros mantenimientos en los equipos -Planeacion anual de los mantenimientos'),
(17, 15, 'UPQ', '2024-02-01', '2024-07-31', '-Configuracion de redes -Soporte tecnico a usuarios -Mantenimiento de servidores'),
(18, 16, 'UPQ', '2024-09-11', '2024-12-11', '-Mantenimiento preventivo a equipos de computo -Cambios de proyectores en las aulas'),
(19, 17, 'CECyTEQ', '2022-05-18', '2023-06-05', '-Mantenimiento Preventivo a Equipos de Computo -Soporte y Mantenimiento de Red -Gestion de Inventarios'),
(20, 1, 'UPQ', '2024-09-11', '2024-12-11', 'Mantenimiento preventivo a equipos de computo'),
(21, 2, 'UPQ', '2024-09-11', '2024-12-11', '-Mantenimiento preventivo a equipos de computo -Instalacion de proyectores'),
(22, 3, 'UPQ', '2025-01-08', '2025-04-14', '-Realice el mantenimiento preventivo y correctivo de los equipos de computo -Colabore para darle mantenimiento y reemplazar proyectores en laboratorios y aulas de toda la institucion -Realize la instalacion de sistemas operativos a todas las computadoras de un solo laboratorio'),
(23, 4, 'CECyTEQ', '2022-09-23', '2023-05-20', '-Desarrollar proyectos en equipo y programacion de sistemas embebidos'),
(24, 5, 'The fitness community', '2017-08-12', '2025-06-27', '-Consegui un conteo de 2 anos sin mantenimientos correctivos, ni paleativos por el correcto mantenimiento periodico -Consegui reducir costos por paros de emergencia por desperfectos en las maquinas'),
(25, 6, 'Huawei', '2020-11-08', '2025-06-24', '-Fundador de la marca -Creador de tienda online -Disenador de pagina web -Soporte -Inversiones'),
(26, 7, 'CECyTEQ', '2023-01-15', '2023-12-15', '-Soporte tecnico -Mantenimiento preventivo -Administracion de redes');
-- Tabla de áreas
CREATE TABLE area(
    id_area INT IDENTITY(1,1) PRIMARY KEY,
    nombre_area VARCHAR(100) NOT NULL
);
GO

INSERT INTO area (nombre_area) 
VALUES 
('Marketing'),
('TI'),
('Industrial'),
('Materiales'),
('Marketing Digital'),
('Control de Calidad'),
('Otro');
GO

-- Tabla de subáreas
CREATE TABLE subarea(
    id_subarea INT IDENTITY(1,1) PRIMARY KEY,
    id_area INT NOT NULL,
    nombre_subarea VARCHAR(100) NOT NULL,
    FOREIGN KEY(id_area) REFERENCES area(id_area)
);
GO

INSERT INTO subarea (id_area, nombre_subarea)
VALUES 
(1,'Gestion de Diseño'),
(2,'Desarollador web'),
(2,'Gestion de Alcance y Requisitos'),
(2,'Gestion de Recursos Humanos'),
(2,'Mantenimiento'),
(2,'Redes'),
(2,'Base de datos'),
(2,'Desarrollo WEB'),
(2,'Laboratorios'),
(2,'Servidores'),
(2,'Analista'),
(2,'Ciencia De Datos'),
(2,'Algoritmos'),
(3,'Soporte'),
(3,'Administracion'),
(4,'Laboratorios y talleres pesados'),
(5,'Gestion de alcance'),
(5,'Comercializacion'),
(6,'QC EHS'),
(6,'Instalacion'),
(1,'Otro'),
(2,'Otro'),
(3,'Otro'),
(4,'Otro'),
(5,'Otro'),
(6,'Otro'),
(7,'Otro');
GO

-- Tabla de área de especialidad
CREATE TABLE area_especialidad(
    id_especialidad INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_area INT NOT NULL,
    id_subarea INT,
    FOREIGN KEY(id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY(id_area) REFERENCES area(id_area),
    FOREIGN KEY(id_subarea) REFERENCES subarea(id_subarea)
);
GO

INSERT INTO area_especialidad (id_usuario, id_area, id_subarea) VALUES
(1, 2, 2),
(2, 2, 6),
(3, 1, 1),
(4, 2, 5),
(5, 3, 13),
(6, 2, 7),
(7, 2, 3),
(8, 1, 2),
(9, 6, 16),
(10, 4, 18),
(11, 2, 11),
(12, 2, NULL),
(13, 5, 15),
(14, 1, NULL),
(15, 7, 23);
GO

-- Tabla de habilidades de usuario
CREATE TABLE habilidades_usuario(
    id_habilidad_usuario INT IDENTITY(1,1) PRIMARY KEY,
    nombre_habilidad VARCHAR(100) NOT NULL
);
GO

INSERT INTO habilidades_usuario (nombre_habilidad) 
VALUES 
('Liderazgo'),
('Organizacion'),
('Confianza'),
('Seguridad'),
('Responsabilidad'),
('Trabajo en equipo'),
('Aprendo rapido'),
('Puntual'),
('Eficiente'),
('Comunicacion'),
('Negociacion'),
('Empatico'),
('Colaborativo'),
('Creativo'),
('Honestidad'),
('Respeto'),
('Lealtad'),
('Compromiso'),
('Perseverancia'),
('Actitud'),
('Tolerancia'),
('Resolucion de problemas'),
('Adaptabilidad'),
('Proactividad'),
('Pensamiento critico'),
('Innovacion'),
('Gestion de tiempo'),
('Memoria'),
('Estrategia'),
('Trabajo bajo presion'),
('Creatividad e innovacion'),
('Curiosidad y aprendizaje continuo'),
('Empatia'),
('Orientacion al negocio'),
('Intuitivo'),
('Otro');
GO

-- Tabla de habilidades de usuarios
CREATE TABLE habilidad(
    id_habilidad INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_habilidad_usuario INT NOT NULL,
    FOREIGN KEY(id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY(id_habilidad_usuario) REFERENCES habilidades_usuario(id_habilidad_usuario)
);
GO

INSERT INTO Habilidad (id_usuario, id_habilidad_usuario) 
VALUES 
(1, 5),
(1, 2),
(1, 3),
(1, 4),
(1, 1),
(2, 6),
(2, 7),
(2, 5),
(2, 9),
(2, 24),
(3, 1),
(3, 10),
(3, 5),
(3, 11),
(4, 5),
(4, 3),
(4, 12),
(4, 13),
(4, 14),
(4, 15),
(5, 6),
(5, 2),
(5, 5),
(5, 1),
(5, 15),
(5, 16),
(5, 17),
(5, 3),
(6, 5),
(6, 6),
(6, 23),
(6, 15),
(7, 5),
(7, 2),
(7, 18),
(7, 19),
(7, 13),
(7, 20),
(7, 24),
(8, 1),
(8, 6),
(8, 2),
(8, 21),
(8, 3),
(8, 10),
(8, 22),
(8, 23),
(9, 6),
(9, 10),
(9, 23),
(9, 15),
(9, 5),
(9, 14),
(10, 17),
(10, 16),
(10, 6),
(10, 2),
(10, 9),
(10, 24),
(10, 3),
(10, 5),
(11, 5),
(11, 23),
(11, 15),
(11, 6),
(12, 14),
(12, 4),
(12, 24),
(12, 5),
(12, 19),
(13, 5),
(13, 24),
(13, 6),
(13, 1),
(13, 10),
(13, 25),
(13, 22),
(13, 23),
(14, 5),
(14, 4),
(14, 10),
(14, 6),
(14, 14),
(15, 26),
(15, 19),
(15, 20),
(15, 25),
(15, 27),
(15, 28),
(15, 23),
(16, 1),
(16, 29),
(16, 23),
(16, 30),
(17, 5),
(17, 2),
(17, 26),
(17, 6),
(17, 24),
(17, 9),
(17, 14),
(17, 25),
(17, 22),
(19, 16),
(19, 5),
(19, 6),
(19, 14),
(19, 15),
(19, 23),
(20, 6),
(20, 23),
(20, 5),
(20, 16),
(20, 1),
(21, 5),
(21, 6),
(21, 14),
(21, 15),
(21, 24),
(21, 17),
(21, 2),
(21, 9),
(22, 5),
(22, 6),
(22, 14),
(22, 15),
(22, 24),
(23, 5),
(23, 10),
(23, 6),
(23, 31),
(23, 14),
(23, 2),
(23, 23),
(23, 32),
(23, 33),
(24, 5),
(24, 13),
(24, 18),
(24, 23),
(24, 9),
(24, 15),
(25, 1),
(25, 18),
(25, 5),
(25, 15),
(25, 14),
(25, 3),
(25, 34),
(26, 17),
(26, 16),
(26, 6),
(26, 2),
(26, 9),
(26, 24),
(26, 3),
(26, 5);
GO

-- Tabla de nivel de idioma
CREATE TABLE nivel_idioma(
    id_nivel_idioma INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL
);
GO

INSERT INTO nivel_idioma (descripcion) 
VALUES 
('Basico'),
('Intermedio'),
('Avanzado');
GO

-- Tabla de idiomas de usuario
CREATE TABLE idiomas_usuario(
    id_idioma_usuario INT IDENTITY(1,1) PRIMARY KEY,
    idioma VARCHAR(100) NOT NULL,
    id_nivel_idioma INT NOT NULL,
    FOREIGN KEY(id_nivel_idioma) REFERENCES nivel_idioma(id_nivel_idioma)
);
GO

INSERT INTO idiomas_usuario (idioma, id_nivel_idioma) 
VALUES
('Inglés', 3),
('Chino', 2),
('Español', 3),
('Árabe', 1),
('Francés', 2),
('Ruso', 1),
('Alemán', 2),
('Portugués', 3),
('Japonés', 1),
('Otro', 1);
GO

-- Tabla de idiomas de usuarios
CREATE TABLE idioma(
    id_idioma INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_idioma_usuario INT NOT NULL,
    FOREIGN KEY(id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY(id_idioma_usuario) REFERENCES idiomas_usuario(id_idioma_usuario)
);
GO

INSERT INTO idioma (id_usuario, id_idioma_usuario) 
VALUES 
(1, 3),
(2, 2),
(3, 3),
(4, 2),
(5, 2),
(6, 2),
(7, 2),
(8, 2),
(9, 2),
(10, 2),
(11, 2),
(12, 2),
(13, 2),
(14, 2),
(15, 2),
(16, 2),
(17, 2),
(18, 2),
(19, 2),
(20, 3),
(21, 2),
(22, 2),
(23, 2),
(24, 2),
(25, 1),
(26, 3);
GO

-- Tabla de nivel educativo
CREATE TABLE nivel_educativo(
    id_nivel_educativo INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL
);
GO

INSERT INTO nivel_educativo (descripcion) 
VALUES 
('Preparatoria'),
('Secundaria'),
('Carrera Tecnica'),
('Universidad - Titulado'),
('Universitario - En curso'),
('Universidad'),
('Universidad- En curso'),
('Universidad - No titulado'),
('Universitario - no titulado'),
('Otro');
GO

-- Tabla de títulos
CREATE TABLE titulo(
    id_titulo INT IDENTITY(1,1) PRIMARY KEY,
    nombre_titulo VARCHAR(150) NOT NULL
);
GO

INSERT INTO titulo (nombre_titulo) VALUES
('Ingeniería en Sistemas Computacionales'),
('Licenciatura en Administración de Empresas'),
('Ingeniería en Tecnologías de la Información'),
('Licenciatura en Contaduría Pública'),
('Ingeniería Industrial'),
('Licenciatura en Marketing'),
('Maestría en Ciencias de la Computación'),
('Doctorado en Inteligencia Artificial');
GO

-- Tabla de carreras
CREATE TABLE carrera(
    id_carrera INT IDENTITY(1,1) PRIMARY KEY,
    nombre_carrera VARCHAR(150) NOT NULL
);
GO

INSERT INTO Carrera(nombre_carrera)
VALUES
('Ingenieria Mecatronica'),
('Ingenieria en Sistemas Computacionales'),
('Ingenieria en Tecnologia Automotriz'),
('Ingenieria en Tecnologias de Manufactura'),
('Ingenieria en Redes y Telecomunicaciones'),
('Ingenieria en Datos'),
('Licenciatura en Administracion y Gestion Empresarial'),
('Licenciatura en Negocios Internacionales');
GO

-- Tabla de educación
CREATE TABLE educacion(
    id_educacion INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_nivel_educativo INT NOT NULL,
    id_titulo INT,
    id_carrera INT,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    sigue_estudiando BIT DEFAULT 0,
    FOREIGN KEY(id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY(id_nivel_educativo) REFERENCES nivel_educativo(id_nivel_educativo),
    FOREIGN KEY(id_titulo) REFERENCES titulo(id_titulo),
    FOREIGN KEY(id_carrera) REFERENCES carrera(id_carrera)
);
GO

INSERT INTO educacion (id_usuario, id_nivel_educativo, id_titulo, id_carrera, fecha_inicio, fecha_fin) 
VALUES 
(1, 1, 1, 1, '2023-09-04', '2026-12-04'),
(2, 2, 1, 1, '2023-01-01', '2026-12-31'),
(3, 3, 1, 1, '2015-04-04', '2018-07-07'),
(4, 4, 1, 1, '2023-09-04', '2026-12-31'),
(5, 5, 1, 1, '2023-09-05', '2026-12-31'),
(6, 2, 1, 1, '2023-01-01', '2026-12-31'),
(7, 2, 1, 1, '2023-01-01', '2026-12-31'),
(8, 4, 1, 1, '2023-01-01', '2026-12-31'),
(9, 5, 1, 1, '2023-01-01', '2026-12-31'),
(10, 5, 1, 1, '2023-01-01', '2026-12-31'),
(11, 4, 1, 1, '2023-09-04', '2026-12-04'),
(12, 4, 1, 1, '2023-01-01', '2026-12-31'),
(13, 2, 1, 1, '2023-01-01', '2026-12-31'),
(14, 5, 1, 1, '2023-01-01', '2026-12-31'),
(15, 5, 1, 1, '2023-09-04', '2026-08-01'),
(16, 5, 1, 1, '2023-01-01', '2026-12-31'),
(17, 5, 1, 1, '2023-01-01', '2026-12-31'),
(18, 5, 1, 1, '2023-01-01', '2026-12-31'),
(19, 5, 1, 1, '2023-01-01', '2026-12-31'),
(20, 4, 1, 1, '2023-01-01', '2026-12-31'),
(21, 5, 1, 1, '2023-01-01', '2026-12-31'),
(22, 4, 1, 1, '2023-01-01', '2026-12-31'),
(23, 4, 1, 1, '2023-01-01', '2026-12-31'),
(24, 5, 1, 1, '2023-01-01', '2026-12-31'),
(25, 5, 1, 1, '2023-01-01', '2026-12-31'),
(26, 5, 1, 1, '2023-01-01', '2026-12-31');
GO

-- Tabla de cursos y certificaciones
CREATE TABLE curso_certificacion(
    id_curso INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    nombre_curso VARCHAR(200) NOT NULL,
    enlace_certificado VARCHAR(255),
    descripcion TEXT,
    FOREIGN KEY(id_usuario) REFERENCES usuarios(id_usuario)
);
GO

INSERT INTO curso_certificacion (id_usuario, nombre_curso, enlace_certificado, descripcion) 
VALUES 
(1, 'Conceptos basicos de redes', 'https://www.netacad.com/certificates?issuanceId=7d0e4abe-35d0-445c-9616-e4281c1df0ff', 'Conceptos basicos en redes, donde se enfocan las conexiones entre dispositivos y los tipos de redes'),
(2, 'Curso basico de html, css y js', 'https://platzi.com/cursos/html-practico/', 'Aprendes las cosas basicas de programacion en html, css y js'),
(3, 'Certificado profesional de Gestor de proyectos de IBM', 'https://www.coursera.org/professional-certificates/ibm-project-manager', 'Conceptos, herramientas y tecnicas esenciales de gestion de proyectos para hacer un seguimiento del progreso, gestionar las relaciones con los clientes y realizar ajustes a lo largo del ciclo de vida.'),
(5, 'Certificacion de Gestion de proyectos y Fundamentos de metodologia Agile.', 'https://lms.santanderopenacademy.com/courses/171/pages/solicita-tu-certificado', 'Con este curso aprenderas las nociones basicas sobre el project management y la metodologia Agile, imprescindibles para garantizar el exito de un proyecto basado en el entendimiento de las diferentes partes involucradas en el proyecto y la consecucion del objetivo final.'),
(6, 'Introduccion al diseno de la experiencia del usuario', 'https://www.coursera.org/learn/user-experience-design', 'El objetivo es disenar artefactos que permitan a los usuarios satisfacer sus necesidades de la manera mas eficaz, eficiente y satisfactoria.'),
(7, 'Carrera Profesional de Tecnico en Redes', 'https://www.credly.com/badges/36d95085-9fb1-461e-a4f0-19418876af11', 'Conceptos de redes, aprendizaje de como funcionan las redes y adquisicion de habilidades laborales para comenzar una carrera tecnologica'),
(8, 'Introduccion al diseno de la experiencia del usuario', 'https://www.coursera.org/learn/user-experience-design', 'Este curso ensena de forma sencilla como crear paginas y aplicaciones faciles de usar, aprendemos a entender al usuario, disenar mejores interfaces para mejorar la experiencia de usuario'),
(9, 'Introduccion a la ingenieria de datos en Google Cloud', 'https://www.coursera.org/learn/introduction-to-data-engineering-on-google-cloud-es', 'En este curso, aprenderas sobre la ingenieria de datos en Google Cloud, los roles y las responsabilidades de los ingenieros de datos y como estos se corresponden con las ofertas de Google Cloud. Tambien aprenderas sobre los metodos para enfrentar los desafios de la ingenieria de datos.'),
(10, 'curso redes empresariales', 'https://www.netacad.com/es/courses/ccna-enterprise-networking-security-automation', 'Este curso cubre las arquitecturas y consideraciones involucradas en el diseno, seguridad, operacion y resolucion de problemas de redes empresariales.'),
(11, 'Redes Neuronales', 'https://www.deeplearning.ai/courses/neural-networks-deep-learning/', 'Domina el poder de la inteligencia artificial con expertos del sector. Aprende en comunidad junto a profesionales destacados de todo el mundo y a tu propio ritmo. Cursos 100% Online.'),
(12, 'Tecnico en redes IP', 'https://capacitateparaelempleo.org/verifica/11297fbf-755c-4c9a-bb03-a5e7faab8be1/05b88531-3657-4616-81f0-eefafe08110a', 'En esta capacitacion obtendras las habilidades basicas que te permitiran desempenarte como Tecnico en redes IP. Aprenderas a configurar los distintos protocolos que permiten la comunicacion entre los dispositivos de una organizacion y el acceso a internet.'),
(13, 'Fundamentos de Redes', 'https://www.netacad.com/es/courses/networking-essentials', 'Las redes mantienen conectado el mundo digital. Aprenda como funcionan las redes y adquiera habilidades laborales para comenzar su carrera tecnologica'),
(14, 'Fundamentos de ChatGpt', 'https://lms.santanderopenacademy.com/courses/892', 'Comprender como funciona ChatGPT y descubrir como esta herramienta puede transformar la comunicacion.'),
(15, 'Preparar datos para la exploracion', 'https://www.coursera.org/learn/preparar-datos-para-la-exploracion', 'Curso de bases de datos'),
(16, 'Fundamentos de ChatGpt', 'https://lms.santanderopenacademy.com/courses/892', 'Fundamentos basicos del uso correcto de ChatGpt e integracion eficiente y etica del uso del mismo para automatizar tareas y procesos.'),
(19, 'Conceptos basicos de redes', 'https://www.netacad.com/certificates?issuanceId=93ccea63-c63b-4437-ae45-39fbec7b94d8', 'Fundamentos de Redes y Telecomunicaciones'),
(20, 'Fundamentos de Redes', 'https://www.netacad.com/courses/networking-essentials', 'Aprendera como funcionan las redes, incluidos los dispositivos, los medios y los protocolos que permiten la comunicacion en la red. Desarrolla habilidades clave para que puedas realizar la resolucion de problemas basicos, utilizando metodologias efectivas y las mejores practicas del soporte tecnico.'),
(23, 'Conceptos basicos de redes', 'https://www.netacad.com/es/certificates?issuanceId=6d38f4c1-f826-4a5c-91e6-d30cd2b693cf', 'Fundamentos de Redes y Telecomunicaciones'),
(25, 'Fundamentos de Hardware y Software de Redes', 'https://www.netacad.com/courses/networking-essentials', 'Networking Essentials esta disenado para adquirir los conocimientos y las habilidades que se necesitan para trabajar en tecnologias de la informacion (TI) y redes.'),
(26, 'Uso y aplicaciones de la IA', 'https://www.deeplearning.ai/courses/ai-for-everyone/', 'Domina el poder de la inteligencia artificial Cursos 100% Online.'),
(1, 'Introduccion a la programacion', 'https://www.coursera.org/learn/intro-programacion', 'Fundamentos basicos de programacion para principiantes'),
(3, 'Gestion de proyectos agiles', 'https://www.coursera.org/learn/agile-project-management', 'Metodologias agiles para la gestion eficiente de proyectos'),
(5, 'Desarrollo Full Stack con JavaScript', 'https://www.coursera.org/learn/full-stack-js', 'Curso completo de desarrollo web full stack con JavaScript'),
(7, 'Liderazgo tecnologico', 'https://www.coursera.org/learn/tech-leadership', 'Habilidades de liderazgo para directivos tecnologicos'),
(9, 'Redes Avanzadas', 'https://example.com/redes-avanzadas', 'Configuracion y administracion de redes empresariales'),
(11, 'Ciberseguridad Basica', 'https://example.com/ciberseguridad', 'Fundamentos de proteccion de sistemas informaticos'),
(13, 'Administracion de Servidores', 'https://example.com/servidores', 'Gestion de infraestructura de servidores'),
(15, 'Cloud Computing', 'https://example.com/cloud', 'Implementacion de soluciones en la nube'),
(17, 'Gestion de Proyectos TI', 'https://example.com/gestion-proyectos', 'Metodologias agiles para proyectos tecnologicos'),
(19, 'Bases de Datos NoSQL', 'https://example.com/nosql', 'Manejo de bases de datos no relacionales');
GO

-- Tabla de tipos de archivo
CREATE TABLE tipo_archivo(
    id_tipo_archivo INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL
);
GO

INSERT INTO tipo_archivo (descripcion) VALUES
('PDF'),
('Word'),
('Excel'),
('Imagen'),
('Video'),
('Presentación'),
('Texto plano'),
('Otro');
GO

-- Tabla de archivos adjuntos
CREATE TABLE archivo_adjunto(
    id_archivo INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_tipo_archivo INT NOT NULL,
    ruta_archivo VARCHAR(255) NOT NULL,
    FOREIGN KEY(id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY(id_tipo_archivo) REFERENCES tipo_archivo(id_tipo_archivo)
);
GO

select * from empresa

INSERT INTO archivo_adjunto (id_usuario, id_tipo_archivo, ruta_archivo) VALUES
(1, 1, '/documentos/cv_roque.pdf'),
(2, 2, '/documentos/cv_erick.docx'),
(3, 3, '/documentos/cv_guillermo.xlsx'),
(4, 4, '/imagenes/perfil_emiliano.jpg'),
(5, 1, '/documentos/cv_rafael.pdf'),
(6, 2, '/documentos/cv_eduardo.docx'),
(7, 1, '/documentos/cv_fernando.pdf'),
(8, 5, '/videos/portafolio_maria.mp4'),
(9, 6, '/presentaciones/proyecto_armando.pptx'),
(10, 7, '/textos/nota_ana.txt');
GO

-- Tabla de sitios de referencia
CREATE TABLE sitio_referencia(
    id_referencia INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    url_sitio VARCHAR(255) NOT NULL,
    FOREIGN KEY(id_usuario) REFERENCES usuarios(id_usuario)
);
GO

INSERT INTO sitio_referencia (id_usuario, url_sitio) VALUES
(1, 'https://linkedin.com/in/roqueaguirre'),
(2, 'https://github.com/erickalvarez'),
(3, 'https://portfolio.guillermo.com'),
(4, 'https://upq.edu.mx/emilianoarvizu'),
(5, 'https://researchgate.net/rafaelbonifacio'),
(6, 'https://mendoza.edu/eduardobarron'),
(7, 'https://fernandobello.dev'),
(8, 'https://mariacruzcamargo.com'),
(9, 'https://armandobejarano.tech'),
(10, 'https://anafrancisco.me');
GO

-- Tabla de estados
CREATE TABLE estados(
    id_estado INT IDENTITY(1,1) PRIMARY KEY,
    nombre_estado VARCHAR(100) NOT NULL
);
GO

INSERT INTO Estados (nombre_estado) 
VALUES
('Aguascalientes'),
('Baja California'),
('Baja California Sur'),
('Campeche'),
('Chiapas'),
('Chihuahua'),
('Ciudad de Mexico'),
('Coahuila'),
('Colima'),
('Durango'),
('Estado de Mexico'),
('Guanajuato'),
('Guerrero'),
('Hidalgo'),
('Jalisco'),
('Michoacan'),
('Morelos'),
('Nayarit'),
('Nuevo Leon'),
('Oaxaca'),
('Puebla'),
('Queretaro'),
('Quintana Roo'),
('San Luis Potosi'),
('Sinaloa'),
('Sonora'),
('Tabasco'),
('Tamaulipas'),
('Tlaxcala'),
('Veracruz'),
('Yucatan'),
('Zacatecas');
GO

-- Tabla de municipios
CREATE TABLE municipio(
    id_municipio INT IDENTITY(1,1) PRIMARY KEY,
    id_estado INT NOT NULL,
    nombre_municipio VARCHAR(100) NOT NULL,
    FOREIGN KEY(id_estado) REFERENCES estados(id_estado)
);
GO

INSERT INTO Municipio (nombre_municipio, ID_Estado) 
VALUES
('Queretaro', 22),
('Amealco de Bonfil', 22),
('Arroyo Seco', 22),
('Cadereyta de Montes', 22),
('Colon', 22),
('Corregidora', 22),
('Ezequiel Montes', 22),
('Huimilpan', 22),
('Jalpan de Serra', 22),
('Landa de Matamoros', 22);
GO

-- Tabla de colonias
CREATE TABLE colonia(
    id_colonia INT IDENTITY(1,1) PRIMARY KEY,
    id_municipio INT NOT NULL,
    nombre_colonia VARCHAR(100) NOT NULL,
    codigo_postal VARCHAR(10),
    FOREIGN KEY(id_municipio) REFERENCES municipio(id_municipio)
);
GO

INSERT INTO Colonia (nombre_colonia, codigo_postal, id_Municipio) 
VALUES
('Centro Historico', '76000', 1),
('Casa Blanca', '76160', 1),
('Santa Maria Magdalena', '76144', 1),
('Jardines de la Hacienda', '76010', 1),
('El Pueblito', '76230', 1),
('Cerrito Colorado', '76156', 1),
('Residencial El Refugio', '76246', 1),
('Areas Turisticas', '76010', 1),
('Prados del Sur', '76137', 1),
('Residencial Campestre', '76160', 1);
GO

-- Tabla de calles
CREATE TABLE calle(
    id_calle INT IDENTITY(1,1) PRIMARY KEY,
    nombre_calle VARCHAR(150) NOT NULL
);
GO

INSERT INTO Calle (nombre_calle) 
VALUES
('5 de Febrero'),
('Avenida Universidad'),
('Avenida Pasteur'),
('Avenida Constituyentes'),
('Avenida Corregidora'),
('Avenida Zaragoza'),
('Calle Madero'),
('Calle Hidalgo'),
('Calle Juarez'),
('Camino Real de Carretas');
GO

-- Tabla de direcciones
CREATE TABLE direccion(
    id_direccion INT IDENTITY(1,1) PRIMARY KEY,
    numero_exterior VARCHAR(20),
    id_calle INT NOT NULL,
    id_colonia INT NOT NULL,
    FOREIGN KEY(id_calle) REFERENCES calle(id_calle),
    FOREIGN KEY(id_colonia) REFERENCES colonia(id_colonia)
);
GO

INSERT INTO Direccion (ID_Calle, numero_exterior, id_Colonia) 
VALUES
(1, '101', 1),
(2, '102', 2),
(3, '103', 3),
(4, '104', 4),
(5, '105', 5),
(6, '106', 6),
(7, '107', 7),
(8, '108', 8),
(9, '109', 9),
(10, '110', 10),
(1, '111', 1),
(2, '112', 2),
(3, '113', 3),
(4, '114', 4),
(5, '115', 5),
(6, '116', 6),
(7, '117', 7),
(8, '118', 8),
(9, '119', 9),
(10, '120', 10),
(1, '121', 1),
(2, '122', 2),
(3, '123', 3),
(4, '124', 4),
(5, '125', 5),
(6, '126', 6),
(7, '127', 7);
GO

-- Tabla de empresas
CREATE TABLE empresa(
    id_empresa INT IDENTITY(1,1) PRIMARY KEY,
    nombre_empresa VARCHAR(150) NOT NULL,
    institucion VARCHAR(150),
    id_estatus INT NOT NULL,
    logo VARCHAR(255),
    descripcion TEXT,
    sitio_web VARCHAR(255),
    id_direccion INT NULL,
	correo_electronico VARCHAR(150) NOT NULL UNIQUE,
	contrasena VARCHAR(255) NOT NULL,
    FOREIGN KEY(id_estatus) REFERENCES estatus_usuario(id_estatus),
    FOREIGN KEY(id_direccion) REFERENCES direccion(id_direccion)
);
GO

SELECT * FROM usuarios
SELECT * FROM empresa

INSERT INTO empresa (
    nombre_empresa, institucion, id_estatus, logo, descripcion, sitio_web, id_direccion, correo_electronico, contrasena
) 
VALUES 
('Microsoft', NULL, 1, NULL, NULL, 'https://www.microsoft.com', 1, 'contacto@microsoft.com', 'Micr0soft2025!'),
('COBAQ', 'COBAQ', 1, NULL, NULL, 'https://www.cobaq.edu.mx', 1, 'info@cobaq.edu.mx', 'Cobaq2025*'),
('UPQ', 'Universidad Politécnica de Querétaro', 1, NULL, NULL, 'https://www.upq.mx', 1, 'contacto@upq.mx', 'Upq2025#'),
('CAM', NULL, 1, NULL, NULL, NULL, 1, 'contacto@cam.org', 'Cam2025!'),
('CECyTEQ', 'CECyTE Querétaro', 1, NULL, NULL, 'https://www.cecyteq.edu.mx', 1, 'info@cecyteq.edu.mx', 'Cecyteq2025@'),
('Mosersa', NULL, 1, NULL, NULL, NULL, 1, 'ventas@mosersa.com', 'Mosersa2025$'),
('DataTics', NULL, 1, NULL, NULL, 'https://www.datatics.mx', 1, 'info@datatics.mx', 'Datatics2025#'),
('Rectificadora Olvera', NULL, 1, NULL, NULL, NULL, 1, 'contacto@rectificadoraolvera.com', 'Rect2025!'),
('TATA', 'Tata Consultancy Services', 1, NULL, NULL, 'https://www.tcs.com', 1, 'info@tcs.com', 'Tata2025@'),
('The fitness community', NULL, 1, NULL, 'Comunidad enfocada al fitness y bienestar', 'https://www.fitnesscommunity.com', 1, 'info@fitnesscommunity.com', 'Fitness2025!'),
('Huawei', NULL, 1, NULL, NULL, 'https://www.huawei.com', 1, 'contacto@huawei.com', 'Huawei2025@'),
('Otro', NULL, 2, NULL, 'Otra empresa no listada', NULL, 1, 'otro@empresa.com', 'Otro2025#');
GO


-- Tabla de categorías
CREATE TABLE categoria(
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL
);
GO

INSERT INTO categoria (nombre_categoria)
VALUES
('Administración'),
('Tecnología'),
('Ingeniería'),
('Ventas'),
('Atención al cliente'),
('Recursos humanos'),
('Marketing'),
('Finanzas'),
('Educación'),
('Salud');
GO

-- Tabla de subcategorías
CREATE TABLE subcategoria(
    id_subcategoria INT IDENTITY(1,1) PRIMARY KEY,
    id_categoria INT NOT NULL,
    nombre_subcategoria VARCHAR(100) NOT NULL,
    FOREIGN KEY(id_categoria) REFERENCES categoria(id_categoria)
);
GO

INSERT INTO subcategoria (id_categoria, nombre_subcategoria)
VALUES
(1, 'Administración general'),
(1, 'Asistencia administrativa'),
(2, 'Desarrollo de software'),
(2, 'Soporte técnico'),
(2, 'Redes y telecomunicaciones'),
(3, 'Ingeniería civil'),
(3, 'Ingeniería mecánica'),
(4, 'Ventas al mayoreo'),
(4, 'Ventas al menudeo'),
(5, 'Servicio al cliente'),
(5, 'Call center'),
(6, 'Reclutamiento'),
(6, 'Capacitación'),
(7, 'Publicidad'),
(7, 'Redes sociales'),
(8, 'Contabilidad'),
(8, 'Auditoría'),
(9, 'Docencia'),
(9, 'Investigación'),
(10, 'Enfermería'),
(10, 'Medicina general');
GO

-- Tabla de tipos de contratación
CREATE TABLE tipo_contratacion(
    id_tipo_contratacion INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL
);
GO

INSERT INTO Tipo_Contratacion (descripcion)
VALUES 
('Tiempo completo'),
('Medio tiempo'),
('Por proyecto');
GO

-- Tabla de modalidades
CREATE TABLE modalidad(
    id_modalidad INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL
);
GO

INSERT INTO Modalidad (descripcion) 
VALUES 
('Presencial'),
('Remoto'),
('Hibrido');
GO



-- 1. Tabla vacante
CREATE TABLE vacante(
    id_vacante INT IDENTITY(1,1) PRIMARY KEY,
    id_titulo INT NOT NULL,
    fecha_publicacion DATE NOT NULL,
    salario_minimo DECIMAL(12,2),
    salario_maximo DECIMAL(12,2),
    id_modalidad INT NOT NULL,
    id_tipo_contratacion INT NOT NULL,
    descripcion TEXT,
    id_empresa INT NOT NULL,
    id_categoria INT NOT NULL,
    id_subcategoria INT,
    id_direccion INT NOT NULL,
    oferta_laboral TEXT,
    requisitos_texto TEXT,
    FOREIGN KEY(id_titulo) REFERENCES titulo(id_titulo),
    FOREIGN KEY(id_modalidad) REFERENCES modalidad(id_modalidad),
    FOREIGN KEY(id_tipo_contratacion) REFERENCES tipo_contratacion(id_tipo_contratacion),
    FOREIGN KEY(id_empresa) REFERENCES empresa(id_empresa),
    FOREIGN KEY(id_categoria) REFERENCES categoria(id_categoria),
    FOREIGN KEY(id_subcategoria) REFERENCES subcategoria(id_subcategoria),
    FOREIGN KEY(id_direccion) REFERENCES direccion(id_direccion)
);
GO

-- 2. Insertar datos en vacante (los id_vacante se generan automáticamente con IDENTITY)
INSERT INTO vacante (id_titulo, fecha_publicacion, salario_minimo, salario_maximo, id_modalidad, id_tipo_contratacion, descripcion, id_empresa, id_categoria, id_subcategoria, id_direccion, oferta_laboral, requisitos_texto)
VALUES
(1, '2023-01-01', 8000.00, 12000.00, 1, 1, 'Vacante para puesto de nivel inicial en area administrativa.', 1, 1, 1, 1, 'Oferta para personas con experiencia minima.', 'Requisitos: titulo profesional, manejo basico de office.'),
(2, '2023-02-01', 10000.00, 15000.00, 2, 2, 'Puesto para desarrollador web frontend.', 2, 2, 3, 2, 'Trabajo remoto con flexibilidad horaria.', 'Requisitos: conocimientos en HTML, CSS y JavaScript.'),
(3, '2023-03-01', 15000.00, 20000.00, 3, 3, 'Puesto para administrador de redes y sistemas.', 3, 2, 5, 3, 'Se busca profesional para gestion de redes corporativas.', 'Requisitos: experiencia en redes y certificacion CCNA.'),
(4, '2023-04-01', 9000.00, 13000.00, 1, 1, 'Atencion al cliente y soporte tecnico.', 4, 5, 10, 4, 'Trabajo presencial en oficinas centrales.', 'Requisitos: buena comunicacion, experiencia en soporte tecnico.'),
(5, '2023-05-01', 12000.00, 17000.00, 2, 2, 'Analista de datos con enfoque en BI.', 5, 2, 3, 5, 'Proyecto dinamico con equipo interdisciplinario.', 'Requisitos: conocimientos en SQL y herramientas de BI.'),
(6, '2023-06-01', 14000.00, 19000.00, 3, 1, 'Desarrollador backend especializado en Python.', 6, 2, 3, 6, 'Trabajo remoto con posibilidad de oficina.', 'Requisitos: experiencia en desarrollo backend y bases de datos.'),
(7, '2023-07-01', 11000.00, 16000.00, 1, 3, 'Coordinador de proyectos tecnologicos.', 7, 1, 1, 7, 'Se requiere liderazgo y gestion de equipos.', 'Requisitos: certificacion PMP o similar.'),
(8, '2023-08-01', 13000.00, 18000.00, 2, 1, 'Especialista en marketing digital.', 8, 7, 14, 8, 'Campañas en redes sociales y SEO.', 'Requisitos: experiencia en marketing digital y analitica.'),
(1, '2023-09-01', 10000.00, 15000.00, 3, 2, 'Tecnico en mantenimiento de hardware.', 9, 2, 4, 9, 'Trabajo en campo y taller.', 'Requisitos: conocimiento en mantenimiento y reparacion.'),
(2, '2023-10-01', 9000.00, 13000.00, 1, 1, 'Asistente administrativo.', 10, 1, 2, 10, 'Gestion de documentos y apoyo en procesos.', 'Requisitos: organizacion y manejo de sistemas administrativos.'),
(3, '2023-11-01', 15000.00, 20000.00, 2, 3, 'Ingeniero de software full stack.', 11, 2, 3, 11, 'Desarrollo de aplicaciones web.', 'Requisitos: manejo de JavaScript, Python y bases de datos.'),
(4, '2023-12-01', 14000.00, 19000.00, 3, 1, 'Administrador de base de datos.', 12, 2, 3, 12, 'Mantenimiento y optimizacion de BD.', 'Requisitos: experiencia en SQL Server y MySQL.'),
(5, '2024-01-01', 11000.00, 16000.00, 1, 2, 'Analista financiero.', 1, 8, 15, 1, 'Analisis y reportes financieros.', 'Requisitos: conocimientos contables y financieros.'),
(6, '2024-02-01', 12000.00, 17000.00, 2, 1, 'Especialista en recursos humanos.', 2, 6, 12, 2, 'Gestion del talento y reclutamiento.', 'Requisitos: experiencia en RH y relaciones laborales.'),
(7, '2024-03-01', 13000.00, 18000.00, 3, 3, 'Consultor en transformacion digital.', 3, 2, 3, 3, 'Apoyo en proyectos de digitalizacion.', 'Requisitos: conocimiento en tecnologias digitales y metodologias agiles.');
GO



-- 3. Crear tabla requisito (depende de vacante)
CREATE TABLE requisito(
    id_requisito INT IDENTITY(1,1) PRIMARY KEY,
    id_vacante INT NOT NULL,
    texto_requisito TEXT NOT NULL,
    FOREIGN KEY(id_vacante) REFERENCES vacante(id_vacante)
);
GO

-- 4. Insertar requisitos con id_vacante válidos (1 a 15)
INSERT INTO requisito (id_vacante, texto_requisito) 
VALUES
(1, 'Titulo profesional relacionado.'),
(1, 'Manejo basico de Microsoft Office.'),
(2, 'Conocimientos en HTML, CSS y JavaScript.'),
(3, 'Experiencia comprobable en redes.'),
(3, 'Certificacion CCNA vigente.'),
(4, 'Buena comunicacion y trato al cliente.'),
(4, 'Experiencia en soporte tecnico.'),
(5, 'Conocimientos en SQL.'),
(5, 'Experiencia con herramientas de BI.'),
(6, 'Experiencia en desarrollo backend con Python.'),
(6, 'Conocimiento en bases de datos relacionales.'),
(7, 'Certificacion PMP o equivalente.'),
(7, 'Habilidades de liderazgo y gestion de equipos.'),
(8, 'Experiencia en marketing digital y analitica.'),
(9, 'Conocimiento en mantenimiento de hardware.'),
(9, 'Capacidad para trabajo en campo y taller.'),
(10, 'Organizacion y manejo de sistemas administrativos.'),
(11, 'Manejo avanzado de JavaScript y Python.'),
(11, 'Experiencia con bases de datos relacionales y NoSQL.'),
(12, 'Experiencia en administracion de bases de datos SQL Server y MySQL.'),
(13, 'Conocimientos contables y financieros.'),
(14, 'Experiencia en gestion de recursos humanos.'),
(15, 'Conocimiento en tecnologias digitales y metodologias agiles.');
GO

-- 5. Crear tabla beneficio (depende de vacante)
CREATE TABLE beneficio(
    id_beneficio INT IDENTITY(1,1) PRIMARY KEY,
    id_vacante INT NOT NULL,
    descripcion_beneficio TEXT NOT NULL,
    FOREIGN KEY(id_vacante) REFERENCES vacante(id_vacante)
);
GO

-- 6. Insertar beneficios con id_vacante válidos (1 a 15)
INSERT INTO beneficio (id_vacante, descripcion_beneficio) 
VALUES
(1, 'Seguro medico privado.'),
(1, 'Capacitacion continua.'),
(2, 'Trabajo remoto y horario flexible.'),
(3, 'Bono por certificaciones.'),
(4, 'Estabilidad laboral y prestaciones superiores.'),
(5, 'Bonos por desempeño.'),
(6, 'Posibilidad de trabajo remoto ocasional.'),
(7, 'Plan de carrera y desarrollo profesional.'),
(8, 'Acceso a herramientas avanzadas de marketing.'),
(9, 'Uniforme y herramientas de trabajo proporcionadas.'),
(10, 'Ambiente laboral amigable y colaborativo.'),
(11, 'Participacion en proyectos internacionales.'),
(12, 'Cursos de actualizacion en tecnologias.'),
(13, 'Prestaciones superiores a la ley.'),
(14, 'Programas de bienestar y salud.'),
(15, 'Trabajo en equipo multidisciplinario.');
GO

-- 7. Crear tabla estado_postulacion
CREATE TABLE estado_postulacion(
    id_estado_postulacion INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL
);
GO

-- 8. Insertar estados
INSERT INTO estado_postulacion (descripcion) 
VALUES 
('enviado'),
('en proceso'),
('rechazado'),
('aceptado'),
('cancelado'),
('finalizado');
GO

-- 9. Crear tabla postulacion (depende de usuarios, vacante y estado_postulacion)
CREATE TABLE postulacion(
    id_postulacion INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_vacante INT NOT NULL,
    fecha_postulacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_estado_postulacion INT NOT NULL,
    FOREIGN KEY(id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY(id_vacante) REFERENCES vacante(id_vacante),
    FOREIGN KEY(id_estado_postulacion) REFERENCES estado_postulacion(id_estado_postulacion)
);
GO

select * from empresa
select * from usuarios

-- 10. Insertar postulaciones (asegurando que id_vacante existe)
INSERT INTO postulacion (id_vacante, id_usuario, id_estado_postulacion)
VALUES
(1, 1, 1), 
(1, 2, 1), 
(1, 3, 1),
(2, 4, 1), 
(2, 5, 1), 
(2, 6, 1),
(3, 7, 1), 
(3, 8, 1), 
(3, 9, 1),
(4, 10, 1),
(4, 11, 1),
(5, 12, 1),
(5, 13, 1),
(6, 14, 1),
(6, 15, 1),
(7, 16, 1),
(7, 17, 1),
(8, 18, 1),
(8, 19, 1),
(9, 20, 1),
(10, 21, 1),
(10, 22, 1),
(11, 23, 1),
(11, 24, 1),
(12, 25, 1),
(12, 26, 1),
(13, 1, 1),
(13, 3, 1),
(13, 5, 1),
(14, 7, 1),
(14, 9, 1),
(15, 11, 1),
(15, 13, 1);
GO


SELECT name, type_desc FROM sys.sql_logins;
select * from usuarios