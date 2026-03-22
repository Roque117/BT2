/*********** lógica de la aplicación ***********/
document.addEventListener('DOMContentLoaded', function() {


document.addEventListener('DOMContentLoaded', () => {
    const userTypeSelector = document.getElementById('userType');
    const candidateFields = document.getElementById('candidateFields');
    const companyFields = document.getElementById('companyFields');

    function toggleFields() {
        if (userTypeSelector.value === 'candidato') {
            candidateFields.style.display = 'block';
            companyFields.style.display = 'none';
        } else {
            candidateFields.style.display = 'none';
            companyFields.style.display = 'block';
        }
    }

    if (userTypeSelector) {
        userTypeSelector.addEventListener('change', toggleFields);
        toggleFields();
    }
});

    /*********** elementos del dom ***********/
    const loader = document.getElementById('loader');
    const registerForm = document.getElementById('registerForm');
    const candidateFields = document.getElementById('candidateFields');
    const companyFields = document.getElementById('companyFields'); // Nuevo: contenedor para campos de empresa
    const userTypeSelector = document.getElementById('userTypeSelector');
// Nuevo: selector de tipo de usuario

    // campos comunes
    const emailInput = document.getElementById('emailInput');
    const passwordInput = document.getElementById('passwordInput');
    const confirmPasswordInput = document.getElementById('confirmPasswordInput');
    const termsCheck = document.getElementById('termsCheck');

    const emailError = document.getElementById('emailError');
    const passwordError = document.getElementById('passwordError');
    const confirmPasswordError = document.getElementById('confirmPasswordError');
    const termsError = document.getElementById('termsError');

    // elementos para mostrar/ocultar contraseña
    const togglePassword = document.getElementById('togglePassword');
    const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');

    // campos específicos de candidato
    const firstNameInput = document.getElementById('firstNameInput');
    const lastNamePInput = document.getElementById('lastNamePInput');
    const lastNameMInput = document.getElementById('lastNameMInput');
    const candidatePhoneInput = document.getElementById('candidatePhoneInput');

    const firstNameError = document.getElementById('firstNameError');
    const lastNamePError = document.getElementById('lastNamePError');
    const lastNameMError = document.getElementById('lastNameMError');
    const candidatePhoneError = document.getElementById('candidatePhoneError');

    // campos específicos de empresa (nuevos)
    const companyNameInput = document.getElementById('companyNameInput');
    const contactNameInput = document.getElementById('contactNameInput');
    const rfcInput = document.getElementById('rfcInput');
    const companyPhoneInput = document.getElementById('companyPhoneInput');
    const companyDescriptionInput = document.getElementById('companyDescriptionInput');

    const companyNameError = document.getElementById('companyNameError');
    const contactNameError = document.getElementById('contactNameError');
    const rfcError = document.getElementById('rfcError');
    const companyPhoneError = document.getElementById('companyPhoneError');

    // elementos de la alerta personalizada
    const customAlert = document.getElementById('customAlert');
    const customAlertMessage = document.getElementById('customAlertMessage');
    const customAlertClose = document.getElementById('customAlertClose');

    /*********** lógica del loader ***********/
    window.addEventListener('load', () => {
        loader.style.opacity = '0';
        setTimeout(() => {
            loader.style.display = 'none';
        }, 500);
    });

    function showLoader(message) {
        loader.querySelector('p').textContent = message;
        loader.style.display = 'flex';
        loader.style.opacity = '1';
    }

    function hideLoader() {
        loader.style.opacity = '0';
        setTimeout(() => {
            loader.style.display = 'none';
        }, 500);
    }

    /*********** funciones de utilidad para la alerta personalizada ***********/
    function showCustomAlert(message) {
        customAlertMessage.textContent = message;
        customAlert.classList.add('show');
    }

    function hideCustomAlert() {
        customAlert.classList.remove('show');
    }

    customAlertClose.addEventListener('click', hideCustomAlert);

    /*********** funciones de utilidad ***********/
    function toggleFields() {
        const userType = userTypeSelector.value;
        candidateFields.style.display = userType === 'candidato' ? 'block' : 'none';
        companyFields.style.display = userType === 'empresa' ? 'block' : 'none';
        
        // Resetear errores
        document.querySelectorAll('.error-message').forEach(el => hideError(el));
        document.querySelectorAll('.form-control, .form-check-input').forEach(el => el.classList.remove('is-invalid'));
    }

    function resetValidation(container) {
        const inputs = container.querySelectorAll('input');
        inputs.forEach(input => {
            input.classList.remove('is-invalid');
            const errorElement = input.closest('.mb-3')?.querySelector('.error-message');
            if (errorElement) {
                errorElement.textContent = '';
                errorElement.style.display = 'none';
            }
        });
    }

    function showError(element, message) {
        element.textContent = message;
        element.style.display = 'block';
        const parentDiv = element.closest('.mb-3');
        if (parentDiv) {
            const input = parentDiv.querySelector('input');
            const inputGroup = parentDiv.querySelector('.input-group');
            const checkbox = parentDiv.querySelector('input[type="checkbox"]');

            if (inputGroup) {
                inputGroup.querySelector('input').classList.add('is-invalid');
            } else if (input) {
                input.classList.add('is-invalid');
            } else if (checkbox) {
                checkbox.classList.add('is-invalid');
            }
        }
    }

    function hideError(element) {
        element.textContent = '';
        element.style.display = 'none';
        const parentDiv = element.closest('.mb-3');
        if (parentDiv) {
            const input = parentDiv.querySelector('input');
            const inputGroup = parentDiv.querySelector('.input-group');
            const checkbox = parentDiv.querySelector('input[type="checkbox"]');

            if (inputGroup) {
                inputGroup.querySelector('input').classList.remove('is-invalid');
            } else if (input) {
                input.classList.remove('is-invalid');
            } else if (checkbox) {
                checkbox.classList.remove('is-invalid');
            }
        }
    }

    function isValidEmail(email) {
        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        return emailRegex.test(email);
    }

    function capitalizeFirstLetter(string) {
        if (!string) return '';
        return string.split(' ').map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()).join(' ');
    }

    function isValidPersonNameField(inputElement, errorElement, fieldName) {
        let value = inputElement.value.trim();
        const lettersSpacesAccentsRegex = /^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/;

        if (value === '') {
            showError(errorElement, `${fieldName} es obligatorio.`);
            return false;
        } else if (!lettersSpacesAccentsRegex.test(value)) {
            showError(errorElement, `Solo se permiten letras, espacios y acentos en ${fieldName.toLowerCase()}.`);
            return false;
        } else if (value.split(' ').filter(word => word !== '').length > 1 && (fieldName === 'apellido paterno' || fieldName === 'apellido materno')) {
            showError(errorElement, `Solo se permite un apellido en el campo de ${fieldName.toLowerCase()}.`);
            return false;
        } else {
            hideError(errorElement);
            return true;
        }
    }

    // Nueva función para validar campos de empresa
    function isValidCompanyField(inputElement, errorElement, fieldName, minLength = 2) {
        let value = inputElement.value.trim();
        
        if (value === '') {
            showError(errorElement, `${fieldName} es obligatorio.`);
            return false;
        } else if (value.length < minLength) {
            showError(errorElement, `${fieldName} debe tener al menos ${minLength} caracteres.`);
            return false;
        } else {
            hideError(errorElement);
            return true;
        }
    }

    function isValidPhoneNumber(inputElement, errorElement, fieldName) {
        let value = inputElement.value;
        const digitsOnlyRegex = /^[0-9]+$/;
        if (value !== '' && !digitsOnlyRegex.test(value)) {
            showError(errorElement, `Solo se permiten números en ${fieldName.toLowerCase()}.`);
            return false;
        } else {
            hideError(errorElement);
            return true;
        }
    }

    // Nueva función para validar RFC
    function isValidRFC(rfc) {
        const rfcRegex = /^[A-ZÑ&]{3,4}\d{6}[A-Z0-9]{2}[0-9A]$/;
        return rfcRegex.test(rfc.toUpperCase());
    }

    function isValidPassword(password) {
        const minLength = 8;
        const hasUpperCase = /[A-Z]/.test(password);
        const hasNumber = /[0-9]/.test(password);
        const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(password);

        if (password.length < minLength) {
            return 'La contraseña debe tener al menos 8 caracteres.';
        }
        if (!hasUpperCase) {
            return 'La contraseña debe contener al menos una letra mayúscula.';
        }
        if (!hasNumber) {
            return 'La contraseña debe contener al menos un número.';
        }
        if (!hasSpecialChar) {
            return 'La contraseña debe contener al menos un carácter especial (!@#$%^&*(),.?:{}|<>).';
        }
        return '';
    }

    function setupPasswordToggle(inputElement, toggleButton) {
        toggleButton.addEventListener('click', function() {
            const icon = this.querySelector('i');
            if (inputElement.type === 'password') {
                inputElement.type = 'text';
                icon.classList.remove('bi-eye-fill');
                icon.classList.add('bi-eye-slash-fill');
            } else {
                inputElement.type = 'password';
                icon.classList.remove('bi-eye-slash-fill');
                icon.classList.add('bi-eye-fill');
            }
        });
    }

    /*********** inicialización y eventos ***********/
    // Configurar evento para selector de tipo de usuario
    userTypeSelector.addEventListener('change', toggleFields);
    toggleFields(); // Mostrar campos iniciales según selección

    // Configurar toggles para contraseñas
    setupPasswordToggle(passwordInput, togglePassword);
    setupPasswordToggle(confirmPasswordInput, toggleConfirmPassword);

    /*********** validación en tiempo real ***********/
    function addValidationOnBlurAndInput(inputElement, validationFunction, errorElement, fieldName) {
        inputElement.addEventListener('blur', () => {
            validationFunction(inputElement, errorElement, fieldName);
        });
        inputElement.addEventListener('input', () => {
            validationFunction(inputElement, errorElement, fieldName);
        });
    }

    // Campos de candidato
    addValidationOnBlurAndInput(firstNameInput, isValidPersonNameField, firstNameError, 'Nombre(s)');
    addValidationOnBlurAndInput(lastNamePInput, isValidPersonNameField, lastNamePError, 'Apellido paterno');
    addValidationOnBlurAndInput(lastNameMInput, isValidPersonNameField, lastNameMError, 'Apellido materno');
    addValidationOnBlurAndInput(candidatePhoneInput, isValidPhoneNumber, candidatePhoneError, 'Número de teléfono');

    // Campos de empresa (nuevos)
    addValidationOnBlurAndInput(companyNameInput, (input, error, field) => 
        isValidCompanyField(input, error, field, 3), companyNameError, 'Nombre de la empresa');
    
    addValidationOnBlurAndInput(contactNameInput, isValidPersonNameField, contactNameError, 'Nombre del contacto');
    
    rfcInput.addEventListener('blur', () => {
        const value = rfcInput.value.trim();
        if (value === '') {
            showError(rfcError, 'El RFC es obligatorio.');
        } else if (!isValidRFC(value)) {
            showError(rfcError, 'Introduce un RFC válido.');
        } else {
            hideError(rfcError);
        }
    });
    
    addValidationOnBlurAndInput(companyPhoneInput, isValidPhoneNumber, companyPhoneError, 'Teléfono de la empresa');

    // Campos comunes
    emailInput.addEventListener('input', () => {
        if (emailInput.value === '') {
            hideError(emailError);
        } else if (!isValidEmail(emailInput.value)) {
            showError(emailError, 'Introduce un correo electrónico válido (ej. usuario@dominio.com).');
        } else {
            hideError(emailError);
        }
    });
    
    emailInput.addEventListener('blur', () => {
        if (emailInput.value === '') {
            showError(emailError, 'El correo electrónico es obligatorio.');
        } else if (!isValidEmail(emailInput.value)) {
            showError(emailError, 'Introduce un correo electrónico válido (ej. usuario@dominio.com).');
        } else {
            hideError(emailError);
        }
    });

    passwordInput.addEventListener('input', () => {
        const validationMessage = isValidPassword(passwordInput.value);
        if (validationMessage) {
            showError(passwordError, validationMessage);
        } else {
            hideError(passwordError);
        }
        if (confirmPasswordInput.value !== '') {
            if (confirmPasswordInput.value !== passwordInput.value) {
                showError(confirmPasswordError, 'Las contraseñas no coinciden.');
            } else {
                hideError(confirmPasswordError);
            }
        }
    });

    passwordInput.addEventListener('blur', () => {
        const validationMessage = isValidPassword(passwordInput.value);
        if (validationMessage) {
            showError(passwordError, validationMessage);
        } else {
            hideError(passwordError);
        }
    });

    confirmPasswordInput.addEventListener('input', () => {
        if (confirmPasswordInput.value === '') {
            hideError(confirmPasswordError);
        } else if (confirmPasswordInput.value !== passwordInput.value) {
            showError(confirmPasswordError, 'Las contraseñas no coinciden.');
        } else {
            hideError(confirmPasswordError);
        }
    });
    
    confirmPasswordInput.addEventListener('blur', () => {
        if (confirmPasswordInput.value === '') {
            showError(confirmPasswordError, 'Confirma tu contraseña.');
        } else if (confirmPasswordInput.value !== passwordInput.value) {
            showError(confirmPasswordError, 'Las contraseñas no coinciden.');
        } else {
            hideError(confirmPasswordError);
        }
    });

    termsCheck.addEventListener('change', () => {
        if (termsCheck.checked) hideError(termsError);
    });

    /*********** envío del formulario ***********/
    registerForm.addEventListener('submit', async function(event) {
        event.preventDefault();

        // Limpiar errores previos
        document.querySelectorAll('.error-message').forEach(el => hideError(el));
        document.querySelectorAll('.form-control, .form-check-input').forEach(el => el.classList.remove('is-invalid'));

        let isValid = true;
        const userType = userTypeSelector.value;

        // Recopilar y limpiar datos
        const formData = new FormData(registerForm);
        const data = {};
        formData.forEach((value, key) => {
            data[key] = typeof value === 'string' ? value.trim() : value;
        });
        
        data['userType'] = userType;

        // Validaciones comunes
        if (data['email'] === '') {
            showError(emailError, 'El correo electrónico es obligatorio.');
            isValid = false;
        } else if (!isValidEmail(data['email'])) {
            showError(emailError, 'Introduce un correo electrónico válido (ej. usuario@dominio.com).');
            isValid = false;
        }

        const passwordValidationResult = isValidPassword(data['password']);
        if (passwordValidationResult) {
            showError(passwordError, passwordValidationResult);
            isValid = false;
        }

        if (data['confirmPassword'] === '') {
            showError(confirmPasswordError, 'Confirma tu contraseña.');
            isValid = false;
        } else if (data['confirmPassword'] !== data['password']) {
            showError(confirmPasswordError, 'Las contraseñas no coinciden.');
            isValid = false;
        }

        if (!termsCheck.checked) {
            showError(termsError, 'Aceptar los términos y condiciones.');
            isValid = false;
        }

        // Validaciones específicas según tipo de usuario
        if (userType === 'candidato') {
            if (!isValidPersonNameField(firstNameInput, firstNameError, 'Nombre(s)')) isValid = false;
            if (!isValidPersonNameField(lastNamePInput, lastNamePError, 'Apellido paterno')) isValid = false;
            if (!isValidPersonNameField(lastNameMInput, lastNameMError, 'Apellido materno')) isValid = false;
            if (data['candidatePhone'] !== '' && !isValidPhoneNumber(candidatePhoneInput, candidatePhoneError, 'Número de teléfono')) isValid = false;
            
            // Capitalizar nombres
            data['firstName'] = capitalizeFirstLetter(data['firstName']);
            data['lastNameP'] = capitalizeFirstLetter(data['lastNameP']);
            data['lastNameM'] = capitalizeFirstLetter(data['lastNameM']);
            
        } else if (userType === 'empresa') {
            if (!isValidCompanyField(companyNameInput, companyNameError, 'Nombre de la empresa', 3)) isValid = false;
            if (!isValidPersonNameField(contactNameInput, contactNameError, 'Nombre del contacto')) isValid = false;
            
            // Validar RFC
            if (data['rfc'] === '') {
                showError(rfcError, 'El RFC es obligatorio.');
                isValid = false;
            } else if (!isValidRFC(data['rfc'])) {
                showError(rfcError, 'Introduce un RFC válido.');
                isValid = false;
            }
            
            if (data['companyPhone'] !== '' && !isValidPhoneNumber(companyPhoneInput, companyPhoneError, 'Teléfono de la empresa')) isValid = false;
            
            // Capitalizar campos
            data['companyName'] = capitalizeFirstLetter(data['companyName']);
            data['contactName'] = capitalizeFirstLetter(data['contactName']);
        }

        if (!isValid) {
            showCustomAlert('Por favor, corrige los errores en el formulario antes de continuar.');
            return;
        }

        // Determinar la URL de envío según el tipo de usuario
        const endpoint = userType === 'candidato' ? '/registrar_usuario_web' : '/registrar_empresa';
        const loaderMessage = userType === 'candidato' ? 'Registrando candidato...' : 'Registrando empresa...';
        
        showLoader(loaderMessage);

        try {
            const response = await fetch(endpoint, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });

            const result = await response.json();

            if (response.ok) {
                showCustomAlert('Registro exitoso');
                
                // Redirigir después de 2 segundos
                setTimeout(() => {
                    window.location.href = result.redirect || 'login.html';
                }, 2000);
                
            } else {
                hideLoader();
                
                // Mostrar errores del backend
                if (result.errors) {
                    for (const [field, message] of Object.entries(result.errors)) {
                        const errorElement = document.getElementById(`${field}Error`);
                        if (errorElement) {
                            showError(errorElement, message);
                        }
                    }
                    showCustomAlert('Por favor, corrige los errores indicados.');
                } else {
                    showCustomAlert(result.message || 'Ocurrió un error durante el registro');
                }
            }
        } catch (error) {
            hideLoader();
            console.error('Error al enviar el formulario:', error);
            showCustomAlert('Error de conexión. Por favor, inténtalo de nuevo más tarde.');
        }
    });
});