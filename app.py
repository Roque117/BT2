import os
from flask import Flask, render_template, request, redirect, url_for, flash, session, jsonify, send_from_directory
import pyodbc
from werkzeug.security import generate_password_hash, check_password_hash
from email_validator import validate_email, EmailNotValidError
import re
from functools import wraps

app = Flask(__name__,
            template_folder=os.path.abspath('.'),
            static_folder=os.path.abspath('.'))

app.secret_key = 'albertolunarufino'

@app.errorhandler(404)
def not_found(e):
    return jsonify({'success': False, 'message': 'Ruta no encontrada'}), 404

@app.errorhandler(500)
def internal_error(e):
    return jsonify({'success': False, 'message': 'Error interno del servidor'}), 500

# Cadena de conexión
connection_string = (
    "DRIVER={ODBC Driver 17 for SQL Server};"
    'SERVER=localhost;'
    "DATABASE=BDD_BT;"
    "Trusted_Connection=yes;"
    "TrustServerCertificate=yes;"
)

UPLOAD_FOLDER = 'multimedia'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

def get_db_connection():
    try:
        conn = pyodbc.connect(connection_string)
        print("Conexión a la base de datos establecida con éxito.")
        return conn
    except pyodbc.Error as ex:
        print(f"Error al conectar a la base de datos: {ex}")
        raise

# Funciones de validación
def is_valid_email(email):
    try:
        validate_email(email, check_deliverability=False)
        email_regex = re.compile(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        return bool(email_regex.match(email))
    except EmailNotValidError:
        return False

def is_valid_password(password):
    min_length = 8
    has_upper_case = any(c.isupper() for c in password)
    has_number = any(c.isdigit() for c in password)
    has_special_char = any(c in "!@#$%^&*(),.?\":{}|<>" for c in password)

    if len(password) < min_length:
        return 'La contraseña debe tener al menos 8 caracteres.'
    if not has_upper_case:
        return 'La contraseña debe contener al menos una letra mayúscula.'
    if not has_number:
        return 'La contraseña debe contener al menos un número.'
    if not has_special_char:
        return 'La contraseña debe contener al menos un carácter especial (!@#$%^&*(),.?:{}|<>).'
    return ''

def is_valid_person_name_field(name, is_apellido=False):
    letters_spaces_accents_regex = re.compile(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$")
    if not bool(letters_spaces_accents_regex.match(name)):
        return False
    if is_apellido and len(name.split()) > 1:
        return False
    return True

def is_valid_url(url):
    regex = re.compile(
        r'^(https?://)?'  # http:// or https://
        r'([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}'  # dominio
        r'(/[a-zA-Z0-9-._~:/?#[\]@!$&\'()*+,;=]*)?$'  # ruta
    )
    return bool(regex.match(url)) if url else True

# Rutas principales
@app.route('/')
def index():
    return redirect(url_for('mostrar_pagina_estatica', filename='index.html'))

@app.route('/registro')
def mostrar_formulario_registro():
    return render_template('registro.html')

@app.route('/registrar_usuario', methods=['POST'])
def registrar_usuario():
    nombre = request.form.get('firstName', '').strip()
    apellido_paterno = request.form.get('lastNameP', '').strip()
    apellido_materno = request.form.get('lastNameM', '').strip()
    correo = request.form.get('email', '').strip()
    contrasena = request.form.get('password', '').strip()
    confirm_contrasena = request.form.get('confirmPassword', '').strip()

    if contrasena != confirm_contrasena:
        return jsonify({'success': False, 'message': 'Las contraseñas no coinciden.'}), 400

    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Verificar si el correo ya existe
        cursor.execute("SELECT id_usuario FROM usuarios WHERE correo_electronico = ?", (correo,))
        if cursor.fetchone():
            return jsonify({'success': False, 'message': 'Este correo ya está registrado.'}), 409

        # Hashear contraseña
        contrasena_hasheada = generate_password_hash(contrasena)

        # Insertar nuevo usuario
        cursor.execute("""
            INSERT INTO usuarios (
                nombre, apellido_paterno, apellido_materno, correo_electronico, contraseña,id_estatus, id_estado_cv
            )
            VALUES (?, ?, ?, ?, ?, ?, ? )
        """, (nombre, apellido_paterno, apellido_materno, correo, contrasena_hasheada,1, 1))
        conn.commit()

        # Redirigir a la página de login
        return redirect(url_for('login_page'))  # 'login_page' es la ruta GET que muestra el login

    except pyodbc.Error as ex:
        return jsonify({'success': False, 'message': f"Error de base de datos: {ex}"}), 500
    except Exception as e:
        return jsonify({'success': False, 'message': f"Error inesperado: {e}"}), 500
    finally:
        if conn:
            conn.close()

@app.route('/registrar_empresa', methods=['POST'])
def registrar_empresa():
    data = request.get_json()
    errors = {}

    # Mapear campos del frontend
    nombre_empresa = data.get('companyName')
    institucion = data.get('institution')
    descripcion = data.get('description')
    sitio_web = data.get('website')
    logo = data.get('logoUrl')
    correo = data.get('email')
    password = data.get('password')
    confirm_password = data.get('confirmPassword')
    estado = data.get('state')
    municipio = data.get('municipality')
    colonia = data.get('neighborhood')
    codigo_postal = data.get('postalCode')
    calle = data.get('street')
    numero_exterior = data.get('exteriorNumber')

    # Validaciones básicas
    if not nombre_empresa:
        errors['companyName'] = 'El nombre de la empresa es obligatorio.'
    if not correo:
        errors['email'] = 'El correo electrónico es obligatorio.'
    elif not is_valid_email(correo):
        errors['email'] = 'Introduce un correo electrónico válido.'
    if not password:
        errors['password'] = 'La contraseña es obligatoria.'
    elif len(password) < 8:
        errors['password'] = 'La contraseña debe tener al menos 8 caracteres.'
    if password != confirm_password:
        errors['confirmPassword'] = 'Las contraseñas no coinciden.'
    if not numero_exterior:
        errors['exteriorNumber'] = 'El número exterior es obligatorio.'

    if errors:
        return jsonify({'success': False, 'errors': errors}), 400

    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        # Verificar si el correo ya existe
        cursor.execute("SELECT id_empresa FROM empresa WHERE correo_electronico = ?", (correo,))
        if cursor.fetchone():
            errors['email'] = 'Este correo electrónico ya está registrado.'
            return jsonify({'success': False, 'errors': errors}), 400

        # Insertar dirección (con valores fijos para id_calle e id_colonia)
        cursor.execute("""
            INSERT INTO direccion (numero_exterior, id_calle, id_colonia)
            OUTPUT INSERTED.id_direccion
            VALUES (?, 1, 1)
        """, (numero_exterior,))
        direccion_id = cursor.fetchone()[0]

        # Insertar empresa
        hashed_pw = generate_password_hash(password)
        cursor.execute("""
            INSERT INTO empresa (
                nombre_empresa, institucion, id_estatus, logo, descripcion,
                sitio_web, id_direccion, correo_electronico, contrasena
            )
            OUTPUT INSERTED.id_empresa
            VALUES (?, ?, 1, ?, ?, ?, ?, ?, ?)
        """, (
            nombre_empresa,
            institucion,
            logo,
            descripcion,
            sitio_web,
            direccion_id,
            correo,
            hashed_pw,
        ))
        empresa_id = cursor.fetchone()[0]
        conn.commit()

        return jsonify({
            'success': True, 
            'redirect': '/', 
            'message': 'Registro exitoso'
        })

    except pyodbc.Error as ex:
        if conn: 
            conn.rollback()
        return jsonify({'success': False, 'message': f'Error de base de datos: {ex}'}), 500
    except Exception as e:
        if conn: 
            conn.rollback()
        return jsonify({'success': False, 'message': f'Error inesperado: {e}'}), 500
    finally:
        if conn: 
            conn.close()

@app.route('/iniciar_sesion')
def mostrar_formulario_inicio_sesion():
    return render_template('login.html')

@app.route('/login', methods=['POST'])
def login_usuario():
    if request.method == 'POST':
        correo = request.form.get('email', '').strip()
        contrasena_ingresada = request.form.get('password', '').strip()

        if not correo or not contrasena_ingresada:
            return jsonify({'success': False, 'message': 'Por favor, ingresa tu correo y contraseña.'}), 400

        conn = None
        try:
            conn = get_db_connection()
            cursor = conn.cursor()

            cursor.execute("""
                SELECT 
                    id_usuario, 
                    contraseña,
                    nombre,
                    apellido_paterno,
                    apellido_materno,
                    correo_electronico
                FROM usuarios 
                WHERE correo_electronico = ?
            """, (correo,))
            resultado = cursor.fetchone()
            
            if resultado:
                user_id = resultado[0]
                contrasena_hasheada_db = resultado[1]
                nombre = resultado[2]
                apellido_paterno = resultado[3]
                apellido_materno = resultado[4]
                correo_usuario = resultado[5]

                if check_password_hash(contrasena_hasheada_db, contrasena_ingresada):
                    # Actualizar última sesión
                    try:
                        cursor.execute("UPDATE usuarios SET ultima_sesion = GETDATE() WHERE id_usuario = ?", (user_id,))
                        conn.commit()
                    except:
                        pass  # Si no existe la columna, continuar

                    # Configurar sesión
                    session['usuario_autenticado'] = True
                    session['user_id'] = user_id
                    session['correo'] = correo_usuario
                    session['nombre'] = nombre
                    session['apellido_paterno'] = apellido_paterno
                    session['apellido_materno'] = apellido_materno
                    
                    return jsonify({
                        'success': True, 
                        'message': '¡Bienvenido! has iniciado sesión exitosamente.'
                    }), 200
                else:
                    return jsonify({
                        'success': False, 
                        'message': 'Contraseña incorrecta. por favor, inténtalo de nuevo.'
                    }), 401
            else:
                return jsonify({
                    'success': False, 
                    'message': 'Correo electrónico no registrado.'
                }), 404
            
        except pyodbc.Error as ex:
            sqlstate = ex.args[0]
            print(f"Error de base de datos en login (sqlstate: {sqlstate}): {ex}")
            return jsonify({'success': False, 'message': f"Ocurrió un error en la base de datos: {ex}"}), 500
        except Exception as e:
            print(f"Error inesperado en el servidor durante el login: {e}")
            return jsonify({'success': False, 'message': f"Ocurrió un error inesperado en el servidor: {e}"}), 500
        finally:
            if conn:
                conn.close()

@app.route('/login', methods=['GET'])
def login_page():
    return render_template('login.html')

@app.route('/buscar_empleos', methods=['GET'])
def buscar_empleos():
    titulo = request.args.get('titulo', '')
    ubicacion = request.args.get('ubicacion', '')
    
    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Consulta básica para obtener empleos
        query = """
        SELECT 
            titulo, 
            descripcion, 
            ubicacion, 
            nombre_empresa AS empresa,
            (
                SELECT STRING_AGG(hu.nombre_habilidad, ', ')
                FROM empleo_habilidades eh
                JOIN habilidades_usuario hu ON eh.id_habilidad_usuario = hu.id_habilidad_usuario
                WHERE eh.id_empleo = e.id_empleo
            ) AS habilidades
        FROM empleos e
        WHERE 1=1
        """
        
        params = []
        
        if titulo:
            query += " AND titulo LIKE ?"
            params.append(f'%{titulo}%')
            
        if ubicacion:
            query += " AND ubicacion LIKE ?"
            params.append(f'%{ubicacion}%')
            
        query += " ORDER BY fecha_publicacion DESC"
        
        cursor.execute(query, params)
        empleos = []
        
        for row in cursor.fetchall():
            empleo = {
                'titulo': row.titulo,
                'descripcion': row.descripcion,
                'ubicacion': row.ubicacion,
                'empresa': row.empresa,
                'habilidades': row.habilidades.split(', ') if row.habilidades else []
            }
            empleos.append(empleo)
        
        return jsonify(empleos), 200
        
    except pyodbc.Error as ex:
        sqlstate = ex.args[0]
        print(f"Error de base de datos al buscar empleos (sqlstate: {sqlstate}): {ex}")
        return jsonify({'message': f"Error de base de datos: {ex}"}), 500
    except Exception as e:
        print(f"Error inesperado al buscar empleos: {e}")
        return jsonify({'message': f"Error inesperado: {e}"}), 500
    finally:
        if conn:
            conn.close()

@app.route('/terminos_y_condiciones')
def terminos_y_condiciones():
    return render_template('terminos_y_condiciones.html')

@app.route('/logout')
def logout():
    # Limpiar todas las sesiones posibles
    session.pop('usuario_autenticado', None)
    session.pop('user_id', None)
    session.pop('correo', None)
    session.pop('nombre', None)
    session.pop('apellido_paterno', None)
    session.pop('apellido_materno', None)
    session.pop('empresa_autenticada', None)
    session.pop('empresa_id', None)
    session.pop('nombre_empresa', None)
    
    flash('Has cerrado sesión exitosamente.', 'info')
    return redirect(url_for('index'))

@app.route('/<path:filename>')
def mostrar_pagina_estatica(filename):
    return send_from_directory(app.root_path, filename)

# ==================== DASHBOARD UNIFICADO ====================

# Decorador para verificar sesión de empresa
def login_empresa_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'empresa_id' not in session:
            return redirect(url_for('login_empresa'))
        return f(*args, **kwargs)
    return decorated_function

# Login unificado para empresas
@app.route('/login_empresa', methods=['POST'])
def login_empresa():
    try:
        data = request.get_json()
        correo = data.get('correo')
        contraseña = data.get('password')

        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            SELECT id_empresa, nombre_empresa, contrasena 
            FROM empresa 
            WHERE correo_electronico = ?
        """, (correo,))
        empresa = cursor.fetchone()

        if empresa and check_password_hash(empresa.contrasena, contraseña):
            session['empresa_id'] = empresa.id_empresa
            session['nombre_empresa'] = empresa.nombre_empresa
            return jsonify(success=True, redirect=url_for('dashboard_empresa'))
        else:
            return jsonify(success=False, message='Credenciales incorrectas')

    except Exception as e:
        print(f"Error en login: {str(e)}")
        return jsonify(success=False, message='Error en el servidor')
    
    finally:
        try:
            cursor.close()
            conn.close()
        except:
            pass

from functools import wraps
from flask import session, redirect

def login_empresa(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'empresa_autenticada' not in session:
            return redirect('/login_empresa')
        return f(*args, **kwargs)
    return decorated_function
@app.route('/dashboard_empresa')
def dashboard_empresa():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Datos del usuario (ejemplo)
    cursor.execute("""
        SELECT nombre, apellido_paterno, apellido_materno, correo_electronico
        FROM usuarios
        WHERE id_usuario = ?
    """, (1,))
    row = cursor.fetchone()

    user_data = {
        "nombres": row[0] if row else "",
        "apellidos": f"{row[1]} {row[2]}" if row else "",
        "correo": row[3] if row else "",
        "telefono": "",
        "ubicacion": "",
        "resumen": "",
        "habilidades": [],
        "jobMatches": 0,
        "profileCompletion": 0,
        "applications": 0,
        "profileViews": 0
    }

    # Traer habilidades del usuario
    if row:
        cursor.execute("""
            SELECT hu.nombre_habilidad
            FROM habilidad h
            JOIN habilidades_usuario hu ON h.id_habilidad_usuario = hu.id_habilidad_usuario
            WHERE h.id_usuario = ?
        """, (1,))
        habilidades = cursor.fetchall()
        user_data['habilidades'] = [h[0] for h in habilidades]

    # Datos de ejemplo de estadísticas (o puedes hacer queries a la DB)
    estadisticas = {
        "vacantes_activas": 5,
        "postulaciones_recibidas": 12,
        "posiciones_cubiertas": 3,
        "visitas_perfil": 45
    }

    conn.close()

    # Datos de la empresa (ejemplo)
    empresa = {
        "nombre": "Empresa",
        "abreviatura": "E"
    }

    return render_template(
        'dashboard_empresa.html',
        user_data=user_data,
        empresa=empresa,
        estadisticas=estadisticas
    )



# API: Obtener datos generales de la empresa
@app.route('/api/empresa/datos')
@login_empresa_required
def obtener_datos_empresa():
    empresa_id = session['empresa_id']
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Obtener datos básicos de la empresa
        cursor.execute("""
            SELECT nombre_empresa, logo, descripcion, sitio_web 
            FROM empresa 
            WHERE id_empresa = ?
        """, (empresa_id,))
        empresa = cursor.fetchone()
        
        # Obtener estadísticas
        cursor.execute("""
            SELECT 
                COUNT(id_vacante) AS total_vacantes,
                SUM(CASE WHEN fecha_cierre IS NULL THEN 1 ELSE 0 END) AS vacantes_activas
            FROM vacante 
            WHERE id_empresa = ?
        """, (empresa_id,))
        stats = cursor.fetchone()
        
        cursor.execute("""
            SELECT COUNT(id_postulacion) AS total_candidatos
            FROM postulacion p
            JOIN vacante v ON p.id_vacante = v.id_vacante
            WHERE v.id_empresa = ?
        """, (empresa_id,))
        candidatos = cursor.fetchone()
        
        # Obtener vacantes recientes
        cursor.execute("""
            SELECT TOP 5 
                v.id_vacante, 
                t.nombre_titulo AS titulo, 
                v.fecha_publicacion, 
                v.salario_minimo, 
                v.salario_maximo, 
                CASE 
                    WHEN v.fecha_cierre IS NOT NULL THEN 'closed'
                    WHEN v.pausada = 1 THEN 'paused'
                    ELSE 'active'
                END AS estado
            FROM vacante v
            JOIN titulo t ON v.id_titulo = t.id_titulo
            WHERE v.id_empresa = ?
            ORDER BY v.fecha_publicacion DESC
        """, (empresa_id,))
        
        vacantes = []
        columns = [column[0] for column in cursor.description]
        for row in cursor.fetchall():
            vacantes.append(dict(zip(columns, row)))
        
        # Calcular tasa de finalización
        cursor.execute("""
            SELECT 
                COUNT(*) AS total_postulaciones,
                SUM(CASE WHEN ep.descripcion = 'Contratado' THEN 1 ELSE 0 END) AS contratados
            FROM postulacion p
            JOIN vacante v ON p.id_vacante = v.id_vacante
            JOIN estado_postulacion ep ON p.id_estado_postulacion = ep.id_estado_postulacion
            WHERE v.id_empresa = ?
        """, (empresa_id,))
        postulaciones = cursor.fetchone()
        
        tasa_finalizacion = (
            (postulaciones.contratados / postulaciones.total_postulaciones * 100) 
            if postulaciones and postulaciones.total_postulaciones > 0 
            else 0
        )
        
        return jsonify({
            'nombre_empresa': empresa.nombre_empresa,
            'logo': empresa.logo,
            'descripcion': empresa.descripcion,
            'sitio_web': empresa.sitio_web,
            'vacantes_activas': stats.vacantes_activas,
            'total_vacantes': stats.total_vacantes,
            'total_candidatos': candidatos.total_candidatos,
            'tasa_finalizacion': round(tasa_finalizacion, 2),
            'vacantes': vacantes
        })
        
    except Exception as e:
        print(f"Error obteniendo datos empresa: {str(e)}")
        return jsonify({'error': str(e)}), 500
    finally:
        try:
            cursor.close()
            conn.close()
        except:
            pass

# API: Obtener vacantes de la empresa
@app.route('/api/empresa/vacantes')
@login_empresa_required
def obtener_vacantes_empresa():
    empresa_id = session['empresa_id']
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT 
                v.id_vacante, 
                t.nombre_titulo AS titulo,
                v.descripcion,
                v.salario_minimo,
                v.salario_maximo,
                m.descripcion AS modalidad,
                tc.descripcion AS tipo_contratacion,
                v.fecha_publicacion,
                v.fecha_cierre,
                v.pausada,
                c.nombre_categoria,
                sc.nombre_subcategoria,
                d.numero_exterior,
                cal.nombre_calle,
                col.nombre_colonia,
                mun.nombre_municipio,
                e.nombre_estado,
                col.codigo_postal,
                CASE 
                    WHEN v.fecha_cierre IS NOT NULL THEN 'closed'
                    WHEN v.pausada = 1 THEN 'paused'
                    ELSE 'active'
                END AS estado
            FROM vacante v
            JOIN titulo t ON v.id_titulo = t.id_titulo
            JOIN modalidad m ON v.id_modalidad = m.id_modalidad
            JOIN tipo_contratacion tc ON v.id_tipo_contratacion = tc.id_tipo_contratacion
            JOIN categoria c ON v.id_categoria = c.id_categoria
            LEFT JOIN subcategoria sc ON v.id_subcategoria = sc.id_subcategoria
            JOIN direccion d ON v.id_direccion = d.id_direccion
            JOIN calle cal ON d.id_calle = cal.id_calle
            JOIN colonia col ON d.id_colonia = col.id_colonia
            JOIN municipio mun ON col.id_municipio = mun.id_municipio
            JOIN estados e ON mun.id_estado = e.id_estado
            WHERE v.id_empresa = ?
        """, (empresa_id,))
        
        vacantes = []
        columns = [column[0] for column in cursor.description]
        for row in cursor.fetchall():
            vacante = dict(zip(columns, row))
            vacante['ubicacion'] = (
                f"{vacante['nombre_calle']} {vacante['numero_exterior']}, "
                f"{vacante['nombre_colonia']}, {vacante['nombre_municipio']}, "
                f"{vacante['nombre_estado']} C.P. {vacante['codigo_postal']}"
            )
            vacantes.append(vacante)
        
        return jsonify(vacantes)
    except Exception as e:
        print(f"Error obteniendo vacantes: {str(e)}")
        return jsonify({'error': str(e)}), 500
    finally:
        try:
            cursor.close()
            conn.close()
        except:
            pass

# API: Obtener candidatos de la empresa
@app.route('/api/empresa/candidatos')
@login_empresa_required
def obtener_candidatos_empresa():
    empresa_id = session['empresa_id']
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT 
                p.id_postulacion,
                u.id_usuario,
                u.nombre + ' ' + u.apellido_paterno AS nombre_completo,
                u.correo_electronico,
                v.id_vacante,
                t.nombre_titulo AS puesto,
                p.fecha_postulacion,
                ep.descripcion AS estado_postulacion
            FROM postulacion p
            JOIN usuarios u ON p.id_usuario = u.id_usuario
            JOIN vacante v ON p.id_vacante = v.id_vacante
            JOIN titulo t ON v.id_titulo = t.id_titulo
            JOIN estado_postulacion ep ON p.id_estado_postulacion = ep.id_estado_postulacion
            WHERE v.id_empresa = ?
            ORDER BY p.fecha_postulacion DESC
        """, (empresa_id,))
        
        candidatos = []
        columns = [column[0] for column in cursor.description]
        for row in cursor.fetchall():
            candidatos.append(dict(zip(columns, row)))
            
        return jsonify(candidatos)
    except Exception as e:
        print(f"Error obteniendo candidatos: {str(e)}")
        return jsonify({'error': str(e)}), 500
    finally:
        try:
            cursor.close()
            conn.close()
        except:
            pass

# API: Obtener estadísticas avanzadas
@app.route('/api/empresa/estadisticas')
@login_empresa_required
def obtener_estadisticas_empresa():
    empresa_id = session['empresa_id']
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Estadísticas de vacantes
        cursor.execute("""
            SELECT 
                SUM(CASE WHEN fecha_cierre IS NULL AND pausada = 0 THEN 1 ELSE 0 END) AS activas,
                SUM(CASE WHEN pausada = 1 THEN 1 ELSE 0 END) AS pausadas,
                SUM(CASE WHEN fecha_cierre IS NOT NULL THEN 1 ELSE 0 END) AS cerradas
            FROM vacante
            WHERE id_empresa = ?
        """, (empresa_id,))
        stats_vacantes = cursor.fetchone()
        
        # Candidatos por vacante
        cursor.execute("""
            SELECT 
                v.id_vacante,
                t.nombre_titulo AS titulo,
                COUNT(p.id_postulacion) AS num_candidatos
            FROM vacante v
            JOIN titulo t ON v.id_titulo = t.id_titulo
            LEFT JOIN postulacion p ON v.id_vacante = p.id_vacante
            WHERE v.id_empresa = ?
            GROUP BY v.id_vacante, t.nombre_titulo
        """, (empresa_id,))
        
        candidatos_por_vacante = []
        columns = [column[0] for column in cursor.description]
        for row in cursor.fetchall():
            candidatos_por_vacante.append(dict(zip(columns, row)))
        
        # Actividad reciente
        cursor.execute("""
            SELECT TOP 5
                u.nombre + ' ' + u.apellido_paterno AS nombre_candidato,
                t.nombre_titulo AS puesto,
                p.fecha_postulacion
            FROM postulacion p
            JOIN usuarios u ON p.id_usuario = u.id_usuario
            JOIN vacante v ON p.id_vacante = v.id_vacante
            JOIN titulo t ON v.id_titulo = t.id_titulo
            WHERE v.id_empresa = ?
            ORDER BY p.fecha_postulacion DESC
        """, (empresa_id,))
        
        actividad_reciente = []
        columns = [column[0] for column in cursor.description]
        for row in cursor.fetchall():
            actividad_reciente.append(dict(zip(columns, row)))
        
        return jsonify({
            'vacantes': {
                'activas': stats_vacantes.activas,
                'pausadas': stats_vacantes.pausadas,
                'cerradas': stats_vacantes.cerradas
            },
            'candidatos_por_vacante': candidatos_por_vacante,
            'actividad_reciente': actividad_reciente
        })
    except Exception as e:
        print(f"Error obteniendo estadísticas: {str(e)}")
        return jsonify({'error': str(e)}), 500
    finally:
        try:
            cursor.close()
            conn.close()
        except:
            pass

@app.route('/api/empresa/crear_vacante', methods=['POST'])
@login_empresa_required
def crear_vacante():
    empresa_id = session['empresa_id']
    data = request.json

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Buscar o crear título
        cursor.execute("SELECT id_titulo FROM titulo WHERE nombre_titulo = ?", (data['titulo'],))
        titulo_row = cursor.fetchone()
        if titulo_row:
            id_titulo = titulo_row.id_titulo
        else:
            cursor.execute("INSERT INTO titulo (nombre_titulo) VALUES (?)", (data['titulo'],))
            id_titulo = cursor.lastrowid  # Compatible con MySQL

        # Validar modalidad
        cursor.execute("SELECT id_modalidad FROM modalidad WHERE descripcion = ?", (data['modalidad'],))
        mod_row = cursor.fetchone()
        if not mod_row:
            raise Exception("Modalidad no encontrada")
        id_modalidad = mod_row.id_modalidad

        # Validar tipo de contratación
        cursor.execute("SELECT id_tipo_contratacion FROM tipo_contratacion WHERE descripcion = ?", (data['tipo_contratacion'],))
        tipo_row = cursor.fetchone()
        if not tipo_row:
            raise Exception("Tipo de contratación no encontrado")
        id_tipo_contratacion = tipo_row.id_tipo_contratacion

        # Validar categoría
        cursor.execute("SELECT id_categoria FROM categoria WHERE nombre_categoria = ?", (data['categoria'],))
        cat_row = cursor.fetchone()
        if not cat_row:
            raise Exception("Categoría no encontrada")
        id_categoria = cat_row.id_categoria

        # Subcategoría opcional
        id_subcategoria = None
        if data.get('subcategoria'):
            cursor.execute("SELECT id_subcategoria FROM subcategoria WHERE nombre_subcategoria = ?", (data['subcategoria'],))
            subcat_row = cursor.fetchone()
            if subcat_row:
                id_subcategoria = subcat_row.id_subcategoria

        # Insertar vacante
        cursor.execute("""
            INSERT INTO vacante (
                id_titulo, fecha_publicacion, salario_minimo, salario_maximo, 
                id_modalidad, id_tipo_contratacion, descripcion, id_empresa, 
                id_categoria, id_subcategoria, id_direccion, oferta_laboral, requisitos_texto
            )
            VALUES (?, GETDATE(), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            id_titulo, 
            data['salario_minimo'], 
            data['salario_maximo'], 
            id_modalidad, 
            id_tipo_contratacion, 
            data['descripcion'], 
            empresa_id,
            id_categoria, 
            id_subcategoria, 
            data.get('id_direccion', 1),  
            data['oferta_laboral'], 
            data['requisitos']
        ))

        id_vacante = cursor.lastrowid

        # Insertar beneficios
        for beneficio in data['beneficios']:
            cursor.execute("""
                INSERT INTO beneficio (id_vacante, descripcion_beneficio)
                VALUES (?, ?)
            """, (id_vacante, beneficio))

        conn.commit()
        return jsonify({'success': True, 'id_vacante': id_vacante})

    except Exception as e:
        conn.rollback()
        print(f"Error creando vacante: {str(e)}")
        return jsonify({'error': str(e)}), 500

    finally:
        cursor.close()
        conn.close()



    
    
    
    
    
    
@app.route('/api/usuario/datos')
def usuario_datos():
    usuario_id = session.get('usuario_id')  # Id guardado al iniciar sesión
    if not usuario_id:
        return jsonify({'error': 'No autenticado'}), 401

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        SELECT nombre, apellido_paterno
        FROM usuarios
        WHERE id_usuario = ?
    """, (usuario_id,))
    usuario = cursor.fetchone()

    cursor.close()
    conn.close()

    return jsonify({
        'nombre': usuario.nombre,
        'apellido_paterno': usuario.apellido_paterno
    })



@app.route('/api/empresa/datos', methods=['GET'])
def empresa_datos():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Obtener datos de la primera empresa (puedes filtrar según login)
    cursor.execute("""
        SELECT TOP 1 id_empresa, nombre_empresa
        FROM empresa
    """)
    row = cursor.fetchone()
    if not row:
        return jsonify({"error": "No se encontró empresa"}), 404

    id_empresa, nombre_empresa = row

    # Contar vacantes activas
    cursor.execute("""
        SELECT COUNT(*) FROM vacante
        WHERE id_empresa = ? AND estado = 'active'
    """, (id_empresa,))
    vacantes_activas = cursor.fetchone()[0]

    # Total de candidatos en esas vacantes
    cursor.execute("""
        SELECT COUNT(*)
        FROM postulaciones p
        INNER JOIN vacante v ON p.id_vacante = v.id_vacante
        WHERE v.id_empresa = ?
    """, (id_empresa,))
    total_candidatos = cursor.fetchone()[0]

    # Calcular tasa de finalización (ejemplo: porcentaje de vacantes cubiertas)
    cursor.execute("""
        SELECT COUNT(*) FROM vacante
        WHERE id_empresa = ? AND estado = 'filled'
    """, (id_empresa,))
    vacantes_cubiertas = cursor.fetchone()[0]

    tasa_finalizacion = 0
    if vacantes_activas + vacantes_cubiertas > 0:
        tasa_finalizacion = round((vacantes_cubiertas / (vacantes_activas + vacantes_cubiertas)) * 100, 2)

    # Lista de vacantes
    cursor.execute("""
        SELECT v.id_vacante, v.titulo, v.ubicacion, v.descripcion, c.nombre_categoria,
               v.tipo_contratacion, v.salario_minimo, v.salario_maximo, v.estado
        FROM vacante v
        LEFT JOIN categoria c ON v.id_categoria = c.id_categoria
        WHERE v.id_empresa = ?
    """, (id_empresa,))
    vacantes = []
    for vac in cursor.fetchall():
        vacantes.append({
            "id_vacante": vac.id_vacante,
            "titulo": vac.titulo,
            "ubicacion": vac.ubicacion,
            "descripcion": vac.descripcion,
            "nombre_categoria": vac.nombre_categoria,
            "tipo_contratacion": vac.tipo_contratacion,
            "salario_minimo": vac.salario_minimo,
            "salario_maximo": vac.salario_maximo,
            "estado": vac.estado
        })

    conn.close()

    return jsonify({
        "nombre_empresa": nombre_empresa,
        "vacantes_activas": vacantes_activas,
        "total_candidatos": total_candidatos,
        "tasa_finalizacion": tasa_finalizacion,
        "vacantes": vacantes
    })

# --------------------
# /api/empresa/usuarios
# --------------------
@app.route('/api/empresa/usuarios', methods=['GET'])
def empresa_usuarios():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        SELECT u.id_usuario, u.nombre, u.apellido
        FROM usuarios u
        INNER JOIN empresa e ON u.id_empresa = e.id_empresa
    """)
    usuarios = []
    for u in cursor.fetchall():
        usuarios.append({
            "id_usuario": u.id_usuario,
            "nombre": f"{u.nombre} {u.apellido}"
        })

    conn.close()
    return jsonify(usuarios)

@app.route('/api/candidato/datos', methods=['GET'])
def obtener_datos_candidato():
    candidato_id = 1  # Usar un ID fijo de un candidato que exista en tu base

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT 
            u.nombre,
            u.apellido_paterno,
            u.apellido_materno,
            u.correo_electronico,
            STRING_AGG(hu.nombre_habilidad, ', ') AS habilidades
        FROM usuarios u
        LEFT JOIN habilidad h ON u.id_usuario = h.id_usuario
        LEFT JOIN habilidades_usuario hu ON h.id_habilidad_usuario = hu.id_habilidad_usuario
        WHERE u.id_usuario = ?
        GROUP BY u.nombre, u.apellido_paterno, u.apellido_materno, u.correo_electronico
    """, (candidato_id,))

    row = cursor.fetchone()
    conn.close()

    if not row:
        return jsonify({"error": "Candidato no encontrado"}), 404

    return jsonify({
        "candidato": {
            "nombre_candidato": row[0],
            "apellido_paterno": row[1],
            "apellido_materno": row[2],
            "correo_electronico": row[3],
            "habilidades": row[4]
        }
    })


    row = cursor.fetchone()

    if not row:
        return jsonify({"error": "Usuario no encontrado"}), 404

    return jsonify({
        "candidato": {  # ⚠️ clave 'candidato' para que el frontend funcione
            "nombre_candidato": row.nombre,
            "apellido_paterno": row.apellido_paterno,
            "apellido_materno": row.apellido_materno,
            "correo_electronico": row.correo_electronico,
            "habilidades": row.habilidades.split(', ') if row.habilidades else []
        },
        "estadisticas": {
            "vacantes_activas": 3,
            "total_candidatos": 10
        },
        "vacantes_recientes": []
    })




# backend.py
@app.route("/api/empresa/dashboard", methods=["GET"])
def obtener_dashboard_empresa():
    empresa_id = session.get("empresa_id")  # asumiendo que guardas la sesión
    if not empresa_id:
        return jsonify({"error": "No autenticado"}), 401

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Ejemplo: obtener estadísticas
    cursor.execute("""
        SELECT COUNT(*) AS vacantes_activas FROM vacantes WHERE empresa_id=%s AND estado='activa'
    """, (empresa_id,))
    vacantes = cursor.fetchone()["vacantes_activas"]

    cursor.execute("""
        SELECT COUNT(*) AS candidatos FROM candidatos_aplicaciones ca
        JOIN vacantes v ON ca.vacante_id = v.id
        WHERE v.empresa_id=%s
    """, (empresa_id,))
    candidatos = cursor.fetchone()["candidatos"]

    cursor.execute("""
        SELECT titulo, ubicacion, tipo, salario, estado
        FROM vacantes
        WHERE empresa_id=%s
        ORDER BY fecha_publicacion DESC
        LIMIT 5
    """, (empresa_id,))
    vacantes_lista = cursor.fetchall()

    return jsonify({
        "empresa": {"nombre": "Mi Empresa"},
        "stats": {
            "vacantes_activas": vacantes,
            "candidatos": candidatos,
            "visitas": 128,  # ejemplo fijo
            "posiciones_cubiertas": "78%"  # ejemplo fijo
        },
        "vacantes": vacantes_lista
    })


if __name__ == '__main__':
    app.run(debug=True)
    
    