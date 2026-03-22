document.addEventListener('DOMContentLoaded', function() {
    // ---- Verificación de sesión de empresa ----
    const empresaActiva = sessionStorage.getItem('empresa');
    if (!empresaActiva) {
        window.location.href = '/login-empresa';
        return;
    }

    fetch('/api/login-empresa', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password })
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            // Aquí es donde guardas los datos en sessionStorage
            sessionStorage.setItem('empresa', data.nombre_empresa);
            sessionStorage.setItem('usuario_id', data.id_usuario);

            // Luego rediriges al dashboard
            window.location.href = '/dashboard_empresa';
        } else {
            alert('Usuario o contraseña incorrectos');
        }
    })
    .catch(err => console.error(err));


    // Element references
    const menuToggle = document.getElementById('menuToggle');
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('overlay');
    const menuLinks = document.querySelectorAll('.menu-link');
    const contentSections = document.querySelectorAll('.content-section');
    const createJobBtn = document.getElementById('createJobBtn');
    const submitJobBtn = document.getElementById('submitJobBtn');
    const logoutBtn = document.getElementById('logoutBtn');
    const companyTabs = document.querySelectorAll('.nav-link');
    const tabPanes = document.querySelectorAll('.tab-pane');

    // Actualizar nombre de la empresa (versión mejorada)
    const companyName = document.getElementById('companyName');
    const userFullName = document.getElementById('userFullName');
    const userAvatar = document.getElementById('userAvatar');
    const nombreEmpresa = sessionStorage.getItem('empresa') || "Empresa";
    
    companyName.textContent = nombreEmpresa;
    userFullName.textContent = nombreEmpresa;
    userAvatar.textContent = nombreEmpresa.charAt(0);

        fetch('/api/empresa/datos') // endpoint que devuelve datos reales
    .then(res => res.json())
    .then(data => {
        userFullName.textContent = data.nombre_completo;
        companyName.textContent = data.nombre_empresa;
        userAvatar.textContent = data.nombre_completo.charAt(0);
    })
    .catch(err => console.error('No se pudieron cargar los datos personales', err));

    // Toggle sidebar on mobile
    menuToggle.addEventListener('click', function() {
        sidebar.classList.toggle('active');
        overlay.classList.toggle('active');
    });

    // Close sidebar when clicking on overlay
    overlay.addEventListener('click', function() {
        sidebar.classList.remove('active');
        overlay.classList.remove('active');
    });

    // Toggle sidebar on mobile
    menuToggle.addEventListener('click', function() {
        sidebar.classList.toggle('active');
        overlay.classList.toggle('active');
    });

    // Close sidebar when clicking on overlay
    overlay.addEventListener('click', function() {
        sidebar.classList.remove('active');
        overlay.classList.remove('active');
    });

    // Switch between sections
    menuLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            menuLinks.forEach(item => item.classList.remove('active'));
            this.classList.add('active');
            contentSections.forEach(section => section.classList.remove('active'));
            const targetSection = this.getAttribute('data-section');
            document.getElementById(`${targetSection}-section`).classList.add('active');

            if (window.innerWidth < 768) {
                sidebar.classList.remove('active');
                overlay.classList.remove('active');
            }
        });
    });

    // Switch between tabs
    companyTabs.forEach(tab => {
        tab.addEventListener('click', function(e) {
            e.preventDefault();
            const targetTab = this.getAttribute('data-bs-target');
            
            companyTabs.forEach(t => t.classList.remove('active'));
            tabPanes.forEach(p => p.classList.remove('show', 'active'));
            
            this.classList.add('active');
            document.querySelector(targetTab).classList.add('show', 'active');
        });
    });

    // Load company data
    function loadCompanyData() {
 fetch('/api/empresa/estadisticas')
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        if (!data.activeJobsCount) {
            console.warn('Datos de estadísticas incompletos:', data);
        }

        document.getElementById('activeJobsCount').textContent = data.activeJobsCount ?? 0;
        document.getElementById('candidatesCount').textContent = data.candidatesCount ?? 0;
        document.getElementById('viewsCount').textContent = data.viewsCount ?? 0;
        document.getElementById('completionRate').textContent = `${data.completionRate ?? 0}%`;
    })
    .catch(error => console.error('Error al cargar estadísticas:', error));


        // Cargar vacantes recientes
        fetch('/api/empresa/vacantes')
            .then(response => response.json())
            .then(vacantes => {
                renderJobs(vacantes, '#companyJobsList');
                renderJobs(vacantes.slice(0, 2), '#recentJobsList');
            })
            .catch(error => console.error('Error al cargar vacantes:', error));
    }

    // Render jobs in a container
    function renderJobs(jobs, containerSelector) {
        const container = document.querySelector(containerSelector);
        container.innerHTML = '';

        if (jobs.length === 0) {
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

            listItem.innerHTML = `
                <div class="d-flex justify-content-between">
                    <div>
                        <h5 class="mb-1">${job.titulo}</h5>
                        <p class="mb-1 text-muted">${job.ubicacion}</p>
                    </div>
                    <span class="${statusClass} job-status">${statusText}</span>
                </div>
                <p class="mb-2">${job.descripcion.substring(0, 100)}...</p>
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="badge bg-light text-dark">${job.nombre_categoria}</span>
                        <span class="badge bg-light text-dark">${job.tipo_contrato}</span>
                        ${job.salario ? `<span class="badge bg-light text-dark">${job.salario}</span>` : ''}
                    </div>
                    <div class="job-actions">
                        <button class="action-btn btn-edit" data-job-id="${job.id_vacante}" onclick="viewJobDetails(${job.id_vacante})">
                            <i class="bi bi-eye"></i> Ver
                        </button>
                        <button class="action-btn btn-edit" data-job-id="${job.id_vacante}" onclick="editJob(${job.id_vacante})">
                            <i class="bi bi-pencil"></i> Editar
                        </button>
                        <button class="action-btn btn-pause" data-job-id="${job.id_vacante}" onclick="toggleJobStatus(${job.id_vacante}, '${job.estado === 'active' ? 'paused' : 'active'}')">
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

    // Show create job modal
    createJobBtn.addEventListener('click', function() {
        const createJobModal = new bootstrap.Modal(document.getElementById('createJobModal'));
        createJobModal.show();
    });

    // Submit job form
submitJobBtn.addEventListener('click', function() {
    const title = document.getElementById('jobTitle').value.trim();
    const location = document.getElementById('jobLocation').value.trim();
    const description = document.getElementById('jobDescription').value.trim();

    if (!title) { 
        alert('El título es obligatorio'); 
        return; 
    }

    const li = document.createElement('li');
    li.className = 'job-item';
    li.innerHTML = `
        <div class="job-header">
            <h4 class="job-title">${title}</h4>
            <span class="job-status status-active">Activa</span>
        </div>
        <div class="job-meta">
            <span class="job-meta-item"><i class="bi bi-geo-alt"></i> ${location}</span>
        </div>
        <p class="mb-0">${description}</p>
        <div class="job-actions">
            <button class="btn btn-sm btn-outline-primary">Editar</button>
            <button class="btn btn-sm btn-outline-warning">Pausar</button>
            <button class="btn btn-sm btn-outline-danger">Cerrar</button>
        </div>
    `;
    jobsList.prepend(li);

    // Cerrar modal correctamente
    const modalEl = document.getElementById('createJobModal');
    const modalInstance = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
    modalInstance.hide();

    // Eliminar cualquier backdrop residual
    const backdrops = document.querySelectorAll('.modal-backdrop');
    backdrops.forEach(b => b.remove());

    // Limpiar campos
    document.getElementById('jobTitle').value = '';
    document.getElementById('jobLocation').value = '';
    document.getElementById('jobDescription').value = '';
});

    // Create a new job
    function createJob() {
        const jobData = {
            titulo: document.getElementById('jobTitle').value,
            ubicacion: document.getElementById('jobLocation').value,
            descripcion: document.getElementById('jobDescription').value,
            salario_minimo: document.getElementById('jobSalaryMin').value,
            salario_maximo: document.getElementById('jobSalaryMax').value,
            tipo_contrato_id: document.getElementById('jobType').value === 'Tiempo completo' ? 1 : 2,
            categoria_id: document.getElementById('jobCategory').value === 'Tecnología' ? 1 : 2,
            requisitos: document.getElementById('jobRequirements').value,
            beneficios: document.getElementById('jobBenefits').value
        };

        fetch('/api/empresa/vacantes', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(jobData)
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert(`Vacante "${jobData.titulo}" creada exitosamente`);
                const createJobModal = bootstrap.Modal.getInstance(document.getElementById('createJobModal'));
                createJobModal.hide();
                document.getElementById('createJobForm').reset();
                loadCompanyData();
            } else {
                alert(`Error al crear vacante: ${data.error}`);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error al crear vacante');
        });
    }

    // Logout button
    logoutBtn.addEventListener('click', function() {
        if (confirm('¿Estás seguro de que deseas cerrar sesión?')) {
            fetch('/logout', {
                method: 'GET'
            })
            .then(() => {
                window.location.href = '/login-empresa';
            })
            .catch(error => console.error('Error al cerrar sesión:', error));
        }
    });

    // View job details
    window.viewJobDetails = function(jobId) {
        fetch(`/api/empresa/vacantes/${jobId}`)
            .then(response => response.json())
            .then(job => {
                const modalContent = document.getElementById('jobDetailsContent');
                modalContent.innerHTML = `
                    <h5>${job.titulo}</h5>
                    <p><strong>Ubicación:</strong> ${job.ubicacion}</p>
                    <p><strong>Tipo de contrato:</strong> ${job.tipo_contrato}</p>
                    <p><strong>Salario:</strong> ${job.salario || 'No especificado'}</p>
                    <p><strong>Publicada:</strong> ${new Date(job.fecha).toLocaleDateString()}</p>
                    
                    <h6 class="mt-4">Descripción</h6>
                    <p>${job.descripcion}</p>
                    
                    <h6 class="mt-4">Requisitos</h6>
                    <p>${job.requisitos || 'No especificados'}</p>
                    
                    ${job.beneficios ? `
                    <h6 class="mt-4">Beneficios</h6>
                    <p>${job.beneficios}</p>
                    ` : ''}
                    
                    <div class="mt-4">
                        <h6>Estado: <span class="${job.estado === 'active' ? 'text-success' : job.estado === 'paused' ? 'text-warning' : 'text-danger'}">${job.estado === 'active' ? 'Activa' : job.estado === 'paused' ? 'Pausada' : 'Cerrada'}</span></h6>
                    </div>
                `;
                
                const jobDetailsModal = new bootstrap.Modal(document.getElementById('jobDetailsModal'));
                jobDetailsModal.show();
            })
            .catch(error => {
                console.error('Error al obtener detalles del trabajo:', error);
                alert('Error al cargar los detalles del trabajo');
            });
    };

    // Edit job
    window.editJob = function(jobId) {
        fetch(`/api/empresa/vacantes/${jobId}`)
            .then(response => response.json())
            .then(job => {
                document.getElementById('jobTitle').value = job.titulo;
                document.getElementById('jobLocation').value = job.ubicacion;
                document.getElementById('jobDescription').value = job.descripcion;
                
                if (job.salario) {
                    const salaryMatch = job.salario.match(/\$([\d,]+) - \$([\d,]+)/);
                    if (salaryMatch && salaryMatch.length >= 3) {
                        document.getElementById('jobSalaryMin').value = salaryMatch[1].replace(',', '');
                        document.getElementById('jobSalaryMax').value = salaryMatch[2].replace(',', '');
                    }
                }
                
                document.getElementById('jobType').value = job.tipo_contrato;
                document.getElementById('jobCategory').value = job.nombre_categoria;
                document.getElementById('jobRequirements').value = job.requisitos || '';
                document.getElementById('jobBenefits').value = job.beneficios || '';
                
                const createJobModal = new bootstrap.Modal(document.getElementById('createJobModal'));
                createJobModal.show();
                
                document.getElementById('createJobModalLabel').textContent = 'Editar Vacante';
                document.getElementById('submitJobBtn').textContent = 'Actualizar Vacante';
                document.getElementById('submitJobBtn').dataset.jobId = jobId;
            })
            .catch(error => {
                console.error('Error al obtener trabajo para editar:', error);
                alert('Error al cargar trabajo para editar');
            });
    };

    // Toggle job status
    window.toggleJobStatus = function(jobId, newStatus) {
        fetch(`/api/empresa/vacantes/${jobId}/status`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ status: newStatus })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                const statusText = newStatus === 'active' ? 'reanudada' : 'pausada';
                alert(`Vacante ${statusText} exitosamente`);
                loadCompanyData();
            } else {
                alert(`Error al cambiar estado: ${data.error}`);
            }
        })
        .catch(error => {
            console.error('Error al cambiar estado:', error);
            alert('Error al cambiar estado del trabajo');
        });
    };

    // Delete job
    window.deleteJob = function(jobId) {
        if (confirm('¿Estás seguro de que deseas eliminar esta vacante?')) {
            fetch(`/api/empresa/vacantes/${jobId}`, {
                method: 'DELETE'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Vacante eliminada exitosamente');
                    loadCompanyData();
                } else {
                    alert(`Error al eliminar vacante: ${data.error}`);
                }
            })
            .catch(error => {
                console.error('Error al eliminar trabajo:', error);
                alert('Error al eliminar vacante');
            });
        }
    };

    // Render candidates
    window.renderCandidates = function(vacanteId) {
        fetch(`/api/empresa/candidatos/${vacanteId}`)
            .then(response => response.json())
            .then(candidatos => {
                const candidatesList = document.getElementById('candidatesList');
                candidatesList.innerHTML = '';
                
                if (candidatos.length === 0) {
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
                                    <h5 class="card-title">${candidato.nombre}</h5>
                                    <p class="card-text"><strong>Estado:</strong> ${candidato.estado}</p>
                                </div>
                                <span class="badge ${candidato.estado === 'Contratado' ? 'bg-success' : candidato.estado === 'Entrevista programada' ? 'bg-primary' : candidato.estado === 'En revisión' ? 'bg-info' : 'bg-warning'}">${candidato.estado}</span>
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
            })
            .catch(error => {
                console.error('Error al cargar candidatos:', error);
                alert('Error al cargar candidatos');
            });
    };

    // Funciones de candidatos
    window.contactCandidate = function(candidateId) {
        alert(`Contactando al candidato ID: ${candidateId}`);
        // En una implementación real, se abriría un modal para enviar mensaje
    };
    
    window.viewCandidateProfile = function(candidateId) {
        alert(`Mostrando perfil del candidato ID: ${candidateId}`);
        // En una implementación real, se redirigiría a la página de perfil
    };

    // Inicializar cargando datos
    loadCompanyData();


fetch('/api/empresa/vacantes')
    .then(response => response.json())
    .then(vacantes => {
        renderJobs(vacantes, '#companyJobsList');
        renderJobs(vacantes.slice(0, 2), '#recentJobsList');
    })

});