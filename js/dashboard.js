document.addEventListener('DOMContentLoaded', function() {
    // Elementos del DOM
    const menuToggle = document.getElementById('menuToggle');
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('overlay');
    const menuLinks = document.querySelectorAll('.menu-link');
    const contentSections = document.querySelectorAll('.content-section');
    const createJobBtn = document.getElementById('createJobBtn');

    const candidateNameElement = document.getElementById('candidateName');
    const userFullNameElement = document.getElementById('userFullName');
    const userAvatarElement = document.getElementById('userAvatar');

    // Inicializar datos del candidato
    let candidatoData = { nombre_candidato: "Invitado" };  // valor por defecto

    // Función para actualizar el DOM
    function actualizarCandidatoUI() {
        const nombre = candidatoData?.nombre_candidato || "Invitado";
        candidateNameElement.textContent = nombre;
        userFullNameElement.textContent = nombre;
        userAvatarElement.textContent = nombre.charAt(0).toUpperCase();
    }

   // Estado global
let vacantes = [];
let candidatos = [];

// Elementos UI
const welcomeNameEl = document.getElementById('welcomeName');
const userFullNameEl = document.getElementById('userFullName');
const profileNameEl = document.getElementById('profileName');
const profileLastNameEl = document.getElementById('profileLastName');
const profileEmailEl = document.getElementById('profileEmail');

// Inicializar aplicación
initApp();

function initApp() {
    fetch('/api/candidato/datos', { credentials: 'include' })
        .then(response => {
            if (response.status === 401) {
                window.location.href = '/login_candidato';
                return;
            }
            return response.json();
        })
        .then(data => {
            if (data.error) {
                console.error('Error:', data.error);
                return;
            }

            if (data?.candidato) {
                candidatoData = data.candidato;

                // Nombre en encabezados
                welcomeNameEl.textContent = candidatoData.nombre_candidato || '';
                userFullNameEl.textContent = `${candidatoData.nombre_candidato || ''} ${candidatoData.apellido_candidato || ''}`.trim();

                // Formulario perfil
                profileNameEl.value = candidatoData.nombre_candidato || '';
                profileLastNameEl.value = candidatoData.apellido_candidato || '';
                profileEmailEl.value = candidatoData.correo_candidato || '';

                // Habilidades
                const skillsContainer = document.getElementById('skillsContainer');
                skillsContainer.innerHTML = '';
                if (Array.isArray(candidatoData.habilidades)) {
                    candidatoData.habilidades.forEach(skill => {
                        const skillElement = document.createElement('span');
                        skillElement.className = 'skill-badge';
                        skillElement.textContent = skill;
                        skillsContainer.appendChild(skillElement);
                    });
                }

                // Estadísticas si existen
                if (data.estadisticas) {
                    document.getElementById('activeJobsCount').textContent = data.estadisticas.vacantes_activas ?? 0;
                    document.getElementById('candidatesCount').textContent = data.estadisticas.total_candidatos ?? 0;
                    document.getElementById('viewsCount').textContent = '0';
                    document.getElementById('completionRate').textContent = '100%';
                }

                // Vacantes recientes
                if (Array.isArray(data.vacantes_recientes)) {
                    renderJobs(data.vacantes_recientes, '#recentJobsList');
                }

                // Cargar todas las vacantes
                loadVacantes();
            }
        })
        .catch(error => console.error('Error al obtener datos del candidato:', error));
}

    // Toggle sidebar en móviles
    menuToggle.addEventListener('click', function() {
        sidebar.classList.toggle('active');
        overlay.classList.toggle('active');
    });

    overlay.addEventListener('click', function() {
        sidebar.classList.remove('active');
        overlay.classList.remove('active');
    });

    menuLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            menuLinks.forEach(item => item.classList.remove('active'));
            this.classList.add('active');
            contentSections.forEach(section => section.classList.remove('active'));
            const targetSection = this.getAttribute('data-section');
            document.getElementById(`${targetSection}-section`).classList.add('active');

            if (targetSection === 'candidato') {
                loadVacantes();
            }

            if (window.innerWidth < 768) {
                sidebar.classList.remove('active');
                overlay.classList.remove('active');
            }
        });
    });

    createJobBtn.addEventListener('click', function() {
        const createJobModal = new bootstrap.Modal(document.getElementById('createJobModal'));
        createJobModal.show();
    });

    submitJobBtn.addEventListener('click', function() {
        const jobData = {
            titulo: document.getElementById('jobTitle').value,
            ubicacion: document.getElementById('jobLocation').value,
            descripcion: document.getElementById('jobDescription').value,
            salario_minimo: document.getElementById('jobSalaryMin').value,
            salario_maximo: document.getElementById('jobSalaryMax').value,
            tipo_contrato: document.getElementById('jobType').value,
            categoria: document.getElementById('jobCategory').value,
            requisitos: document.getElementById('jobRequirements').value,
            beneficios: document.getElementById('jobBenefits').value,
            habilidades: document.getElementById('jobSkills').value,
            remoto: document.getElementById('jobRemote').checked
        };
        
        if (!jobData.titulo || !jobData.descripcion || !jobData.requisitos) {
            alert('Por favor complete los campos obligatorios');
            return;
        }
        
        createVacante(jobData);
    });
    
    logoutBtn.addEventListener('click', function() {
        if (confirm('¿Estás seguro de que deseas cerrar sesión?')) {
            fetch('/logout')
                .then(() => window.location.href = '/login_candidato')
                .catch(error => console.error('Error al cerrar sesión:', error));
        }
    });
    
    function loadVacantes() {
        fetch('/api/candidato/vacantes')
            .then(response => response.json())
            .then(data => {
                if (data.error) {
                    console.error('Error:', data.error);
                    return;
                }
                vacantes = data;
                renderJobs(vacantes, '#candidateJobsList');
            })
            .catch(error => console.error('Error al cargar vacantes:', error));
    }

    
    // Renderizar trabajos en un contenedor
    function renderJobs(jobs, containerSelector) {
        const container = document.querySelector(containerSelector);
        container.innerHTML = '';
        
        if (!jobs || jobs.length === 0) {
            container.innerHTML = '<p class="text-center py-4">No se encontraron vacantes</p>';
            return;
        }
        
        jobs.forEach(job => {
            const listItem = document.createElement('li');
            listItem.className = 'job-list-item';
            listItem.dataset.jobId = job.id_vacante;
            
            let statusClass = 'status-active';
            let statusText = 'Activa';
            let pauseIcon = 'bi-pause';
            let pauseText = 'Pausar';
            
            if (job.estado === 'paused') {
                statusClass = 'status-paused';
                statusText = 'Pausada';
                pauseIcon = 'bi-play';
                pauseText = 'Reanudar';
            } else if (job.estado === 'closed') {
                statusClass = 'status-closed';
                statusText = 'Cerrada';
                pauseIcon = 'bi-play';
                pauseText = 'Reabrir';
            }
            
            const salary = job.salario_minimo && job.salario_maximo 
                ? `$${job.salario_minimo} - $${job.salario_maximo}` 
                : 'Salario no especificado';
            
            listItem.innerHTML = `
                <div class="d-flex justify-content-between">
                    <div>
                        <h5 class="mb-1">${job.titulo}</h5>
                        <p class="mb-1 text-muted">${job.ubicacion}</p>
                    </div>
                    <span class="${statusClass} job-status">${statusText}</span>
                </div>
                <p class="mb-2">${job.descripcion.substring(0, 150)}...</p>
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="badge bg-light text-dark">${job.nombre_categoria}</span>
                        <span class="badge bg-light text-dark">${job.tipo_contratacion}</span>
                        <span class="badge bg-light text-dark">${salary}</span>
                    </div>
                    <div class="job-actions">
                        <button class="action-btn btn-edit" data-job-id="${job.id_vacante}" onclick="viewJobDetails(${job.id_vacante})">
                            <i class="bi bi-eye"></i> Ver
                        </button>
                        <button class="action-btn btn-edit" data-job-id="${job.id_vacante}" onclick="editJob(${job.id_vacante})">
                            <i class="bi bi-pencil"></i> Editar
                        </button>
                        <button class="action-btn btn-pause" data-job-id="${job.id_vacante}" 
                                onclick="toggleJobStatus(${job.id_vacante}, '${job.estado === 'active' ? 'paused' : 'active'}')">
                            <i class="bi ${pauseIcon}"></i> ${pauseText}
                        </button>
                        <button class="action-btn btn-delete" data-job-id="${job.id_vacante}" onclick="deleteJob(${job.id_vacante})">
                            <i class="bi bi-trash"></i> Eliminar
                        </button>
                    </div>
                </div>
            `;
            
            container.appendChild(listItem);
        });
    }
    
    // Crear nueva vacante
    function createVacante(jobData) {
        fetch('/api/empresa/crear_vacante', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                titulo: jobData.titulo,
                descripcion: jobData.descripcion,
                salario_minimo: jobData.salario_minimo,
                salario_maximo: jobData.salario_maximo,
                modalidad: jobData.remoto ? 'Remoto' : 'Presencial',
                tipo_contratacion: jobData.tipo_contrato,
                categoria: jobData.categoria,
                subcategoria: jobData.subcategoria,
                id_direccion: 1, // Esto debería venir del formulario
                oferta_laboral: jobData.descripcion,
                requisitos: jobData.requisitos,
                beneficios: jobData.beneficios ? jobData.beneficios.split('\n') : []
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.error) {
                alert(`Error: ${data.error}`);
                return;
            }
            
            alert(`Vacante "${jobData.titulo}" creada exitosamente`);
            const createJobModal = bootstrap.Modal.getInstance(document.getElementById('createJobModal'));
            createJobModal.hide();
            document.getElementById('createJobForm').reset();
            
            // Recargar las vacantes
            loadVacantes();
        })
        .catch(error => {
            console.error('Error creando vacante:', error);
            alert('Ocurrió un error al crear la vacante');
        });
    }
    
    // Función para ver detalles de la vacante
    window.viewJobDetails = function(jobId) {
        const job = vacantes.find(j => j.id_vacante === jobId);
        if (!job) return;
        
        const modalContent = document.getElementById('jobDetailsContent');
        modalContent.innerHTML = `
            <h5>${job.titulo}</h5>
            <p><strong>Ubicación:</strong> ${job.ubicacion}</p>
            <p><strong>Tipo de contrato:</strong> ${job.tipo_contratacion}</p>
            <p><strong>Modalidad:</strong> ${job.modalidad}</p>
            <p><strong>Salario:</strong> ${job.salario_minimo ? `$${job.salario_minimo} - $${job.salario_maximo}` : 'No especificado'}</p>
            <p><strong>Publicada:</strong> ${new Date(job.fecha_publicacion).toLocaleDateString()}</p>
            
            <h6 class="mt-4">Descripción</h6>
            <p>${job.descripcion}</p>
            
            <h6 class="mt-4">Requisitos</h6>
            <p>${job.requisitos_texto}</p>
            
            ${job.oferta_laboral ? `
            <h6 class="mt-4">Oferta Laboral</h6>
            <p>${job.oferta_laboral}</p>
            ` : ''}
            
            <div class="mt-4">
                <h6>Estado: <span class="${job.estado === 'active' ? 'text-success' : job.estado === 'paused' ? 'text-warning' : 'text-danger'}">
                    ${job.estado === 'active' ? 'Activa' : job.estado === 'paused' ? 'Pausada' : 'Cerrada'}
                </span></h6>
            </div>
        `;
        
        const jobDetailsModal = new bootstrap.Modal(document.getElementById('jobDetailsModal'));
        jobDetailsModal.show();
    };
    
    // Función para editar vacante
    window.editJob = function(jobId) {
        const job = vacantes.find(j => j.id_vacante === jobId);
        if (!job) return;
        
        // Rellenar el formulario con los datos de la vacante
        document.getElementById('jobTitle').value = job.titulo;
        document.getElementById('jobLocation').value = job.ubicacion;
        document.getElementById('jobDescription').value = job.descripcion;
        document.getElementById('jobType').value = job.tipo_contratacion;
        document.getElementById('jobCategory').value = job.nombre_categoria;
        document.getElementById('jobRequirements').value = job.requisitos_texto;
        document.getElementById('jobBenefits').value = job.beneficios ? job.beneficios.join('\n') : '';
        
        // Extraer valores de salario
        if (job.salario_minimo && job.salario_maximo) {
            document.getElementById('jobSalaryMin').value = job.salario_minimo;
            document.getElementById('jobSalaryMax').value = job.salario_maximo;
        }
        
        // Mostrar el modal
        const createJobModal = new bootstrap.Modal(document.getElementById('createJobModal'));
        createJobModal.show();
        
        // Cambiar el texto del botón de envío
        document.getElementById('createJobModalLabel').textContent = 'Editar Vacante';
        document.getElementById('submitJobBtn').textContent = 'Actualizar Vacante';
        document.getElementById('submitJobBtn').dataset.jobId = jobId;
    };
    
    // Función para cambiar estado de la vacante
    window.toggleJobStatus = function(jobId, newStatus) {
        fetch(`/api/empresa/cambiar_estado_vacante/${jobId}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ estado: newStatus })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                const statusText = newStatus === 'active' ? 'reanudada' : 'pausada';
                alert(`Vacante ${statusText} exitosamente`);
                loadVacantes();
            } else {
                alert(data.error || 'Error al cambiar estado de la vacante');
            }
        })
        .catch(error => {
            console.error('Error cambiando estado de vacante:', error);
            alert('Ocurrió un error al cambiar el estado de la vacante');
        });
    };
    
    // Función para eliminar vacante
    window.deleteJob = function(jobId) {
        if (confirm('¿Estás seguro de que deseas eliminar esta vacante?')) {
            fetch(`/api/empresa/eliminar_vacante/${jobId}`, {
                method: 'DELETE'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Vacante eliminada exitosamente');
                    loadVacantes();
                } else {
                    alert(data.error || 'Error al eliminar la vacante');
                }
            })
            .catch(error => {
                console.error('Error eliminando vacante:', error);
                alert('Ocurrió un error al eliminar la vacante');
            });
        }
    };
    
    // Función para mostrar candidatos
    window.showCandidates = function() {
        fetch('/api/empresa/candidatos')
            .then(response => response.json())
            .then(data => {
                if (data.error) {
                    console.error('Error:', data.error);
                    return;
                }
                candidatos = data;
                renderCandidates();
            })
            .catch(error => console.error('Error al cargar candidatos:', error));
    };
    
    // Renderizar candidatos
    function renderCandidates() {
        const candidatesList = document.getElementById('candidatesList');
        candidatesList.innerHTML = '';
        
        if (!candidatos || candidatos.length === 0) {
            candidatesList.innerHTML = '<p class="text-center py-4">No se encontraron candidatos</p>';
            return;
        }
        
        candidatos.forEach(candidato => {
            const candidateCard = document.createElement('div');
            candidateCard.className = 'card mb-3';
            candidateCard.innerHTML = `
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h5 class="card-title">${candidato.nombre_completo}</h5>
                            <p class="card-text"><strong>Vacante:</strong> ${candidato.puesto}</p>
                        </div>
                        <span class="badge ${candidato.estado_postulacion === 'Contratado' ? 'bg-success' : 
                                            candidato.estado_postulacion === 'Entrevista programada' ? 'bg-primary' : 
                                            candidato.estado_postulacion === 'En revisión' ? 'bg-info' : 'bg-warning'}">
                            ${candidato.estado_postulacion}
                        </span>
                    </div>
                    <p class="card-text"><strong>Email:</strong> ${candidato.correo_electronico}</p>
                    <p class="card-text"><small class="text-muted">Postulado el: ${new Date(candidato.fecha_postulacion).toLocaleDateString()}</small></p>
                    <div class="mt-3">
                        <button class="btn btn-sm btn-outline-primary me-2" onclick="contactCandidate(${candidato.id_usuario})">
                            <i class="bi bi-envelope me-1"></i> Contactar
                        </button>
                        <button class="btn btn-sm btn-outline-success" onclick="viewCandidateProfile(${candidato.id_usuario})">
                            <i class="bi bi-person-circle me-1"></i> Ver perfil
                        </button>
                    </div>
                </div>
            `;
            
            candidatesList.appendChild(candidateCard);
        });
    }
    
    // Función para mostrar estadísticas
    window.showStats = function() {
        fetch('/api/empresa/estadisticas')
            .then(response => response.json())
            .then(data => {
                if (data.error) {
                    console.error('Error:', data.error);
                    return;
                }
                renderStats(data);
            })
            .catch(error => console.error('Error al cargar estadísticas:', error));
    };
    
    // Renderizar estadísticas
    function renderStats(statsData) {
        const statsContent = document.getElementById('statsContent');
        statsContent.innerHTML = '';
        
        // Estadísticas de vacantes
        statsContent.innerHTML += `
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title">${statsData.vacantes.activas}</h5>
                            <p class="card-text">Vacantes activas</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title">${statsData.vacantes.pausadas}</h5>
                            <p class="card-text">Vacantes pausadas</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title">${statsData.vacantes.cerradas}</h5>
                            <p class="card-text">Vacantes cerradas</p>
                        </div>
                    </div>
                </div>
            </div>
        `;
        
        // Candidatos por vacante
        statsContent.innerHTML += `<h5 class="mb-3">Candidatos por vacante</h5>`;
        
        statsData.candidatos_por_vacante.forEach(vacante => {
            const percentage = Math.min(100, Math.round((vacante.num_candidatos / 10) * 100)); // Suponiendo 10 como máximo
            statsContent.innerHTML += `
                <div class="progress-container mb-3">
                    <div class="progress-title">
                        <span>${vacante.titulo}</span>
                        <span>${vacante.num_candidatos} candidatos</span>
                    </div>
                    <div class="progress">
                        <div class="progress-bar bg-primary" role="progressbar" style="width: ${percentage}%" 
                             aria-valuenow="${percentage}" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                </div>
            `;
        });
        
        // Actividad reciente
        statsContent.innerHTML += `<h5 class="mt-4 mb-3">Actividad Reciente</h5>`;
        
        statsData.actividad_reciente.forEach(actividad => {
            const fecha = new Date(actividad.fecha_postulacion).toLocaleDateString();
            statsContent.innerHTML += `
                <div class="alert alert-light mb-2">
                    <i class="bi bi-person-circle me-2"></i> ${actividad.nombre_candidato} aplicó a ${actividad.puesto}
                    <div class="text-muted small mt-1">${fecha}</div>
                </div>
            `;
        });
    }
    
    // Funciones de candidatos
    window.contactCandidate = function(candidateId) {
        const candidate = candidatos.find(c => c.id_usuario === candidateId);
        if (candidate) {
            alert(`Contactando a ${candidate.nombre_completo} (${candidate.correo_electronico})`);
        }
    };
    
    window.viewCandidateProfile = function(candidateId) {
        alert(`Mostrando perfil del candidato ID: ${candidateId}`);
        // En una implementación real, esto abriría una página con el perfil completo
    };
});