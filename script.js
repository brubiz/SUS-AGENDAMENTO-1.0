// Initialize Mapbox
mapboxgl.accessToken = 'pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw';

// DOM Elements
const loginBtn = document.getElementById('login-btn');
const startLoginBtn = document.getElementById('start-login');
const loginModal = document.getElementById('login-modal');
const closeLoginBtn = document.getElementById('close-login');
const loginForm = document.getElementById('login-form');
const closeSuccessBtn = document.getElementById('close-success');
const successModal = document.getElementById('success-modal');
const confirmAppointmentBtn = document.getElementById('confirm-appointment');
const steps = document.querySelectorAll('.step');
const stepContainers = {
    1: document.getElementById('step-1'),
    2: document.getElementById('step-2'),
    3: document.getElementById('step-3'),
    4: document.getElementById('step-4')
};
const progressBar = document.getElementById('progress-bar');
const nextStepBtns = document.querySelectorAll('.next-step');
const prevStepBtns = document.querySelectorAll('.prev-step');
const specialtyCards = document.querySelectorAll('.specialty-card');
const calendar = document.getElementById('calendar');
const prevMonthBtn = document.getElementById('prev-month');
const nextMonthBtn = document.getElementById('next-month');
const timeSlots = document.getElementById('time-slots');
const summarySpecialty = document.getElementById('summary-specialty');
const summaryDate = document.getElementById('summary-date');
const summaryTime = document.getElementById('summary-time');
const summaryLocation = document.getElementById('summary-location');

// State
let currentStep = 1;
let selectedSpecialty = 'Cardiologia';
let selectedDate = null;
let selectedTime = '';
let selectedLocation = 'UBS Vila Galvão';
let currentMonth = new Date();

// Event Listeners
loginBtn.addEventListener('click', () => loginModal.classList.remove('hidden'));
startLoginBtn.addEventListener('click', () => loginModal.classList.remove('hidden'));
closeLoginBtn.addEventListener('click', () => loginModal.classList.add('hidden'));
closeSuccessBtn.addEventListener('click', () => successModal.classList.add('hidden'));

loginForm.addEventListener('submit', (e) => {
    e.preventDefault();
    
    const cpf = document.getElementById('cpf').value;
    const susNumber = document.getElementById('sus-number').value;
    
    // Simple validation
    if (!/^\d{3}\.?\d{3}\.?\d{3}-?\d{2}$/.test(cpf)) {
        alert('Por favor, insira um CPF válido');
        return;
    }
    
    if (susNumber.trim().length < 15) {
        alert('Por favor, insira um número de Cartão SUS válido');
        return;
    }
    
    // Simulate successful login
    loginModal.classList.add('hidden');
    
    // Update header with user info
    document.getElementById('auth-section').innerHTML = `
        <div class="flex items-center space-x-2">
            <span class="font-medium">Bem-vindo(a)</span>
            <button class="text-white hover:text-blue-100">
                <i class="fas fa-user-circle text-xl"></i>
            </button>
        </div>
    `;
    
    updateStep(2);
});

nextStepBtns.forEach(btn => {
    btn.addEventListener('click', () => {
        const nextStep = parseInt(btn.dataset.next);
        
        // Validate before proceeding
        if (nextStep === 3 && !selectedSpecialty) {
            alert('Por favor, selecione uma especialidade');
            return;
        }
        
        if (nextStep === 4 && (!selectedDate || !selectedTime)) {
            alert('Por favor, selecione uma data e horário');
            return;
        }
        
        updateStep(nextStep);
    });
});

prevStepBtns.forEach(btn => {
    btn.addEventListener('click', () => {
        const prevStep = parseInt(btn.dataset.prev);
        updateStep(prevStep);
    });
});

specialtyCards.forEach(card => {
    card.addEventListener('click', () => {
        // Remove selection from all cards
        specialtyCards.forEach(c => {
            c.classList.remove('border-blue-500', 'bg-blue-50');
        });
        
        // Add selection to clicked card
        card.classList.add('border-blue-500', 'bg-blue-50');
        
        // Update selected specialty
        selectedSpecialty = card.querySelector('h3').textContent;
        summarySpecialty.textContent = selectedSpecialty;
    });
});

confirmAppointmentBtn.addEventListener('click', () => {
    if (!document.getElementById('confirm-terms').checked) {
        alert('Por favor, confirme que leu e aceitou os termos de uso.');
        return;
    }
    
    // Here you would typically send data to the server
    // For demo purposes, we'll just show the success modal
    successModal.classList.remove('hidden');
});

// Calendar navigation
prevMonthBtn.addEventListener('click', () => {
    currentMonth.setMonth(currentMonth.getMonth() - 1);
    generateCalendar(currentMonth);
});

nextMonthBtn.addEventListener('click', () => {
    currentMonth.setMonth(currentMonth.getMonth() + 1);
    generateCalendar(currentMonth);
});

// Functions
function updateStep(step) {
    // Hide all steps
    Object.values(stepContainers).forEach(container => {
        container.classList.add('hidden');
    });
    
    // Show current step
    stepContainers[step].classList.remove('hidden');
    
    // Update progress bar
    progressBar.style.width = `${(step / 4) * 100}%`;
    
    // Update step indicators
    steps.forEach(s => {
        const stepNumber = parseInt(s.dataset.step);
        const circle = s.querySelector('div');
        const text = s.querySelector('span');
        
        if (stepNumber < step) {
            circle.classList.remove('bg-gray-300', 'text-gray-600');
            circle.classList.add('bg-blue-600', 'text-white');
            text.classList.remove('text-gray-600');
            text.classList.add('text-blue-600');
        } else if (stepNumber === step) {
            circle.classList.remove('bg-gray-300', 'text-gray-600');
            circle.classList.add('bg-blue-600', 'text-white');
            text.classList.remove('text-gray-600');
            text.classList.add('text-blue-600');
        } else {
            circle.classList.remove('bg-blue-600', 'text-white');
            circle.classList.add('bg-gray-300', 'text-gray-600');
            text.classList.remove('text-blue-600');
            text.classList.add('text-gray-600');
        }
    });
    
    currentStep = step;
    
    // Initialize calendar if step 3
    if (step === 3 && !calendar.hasChildNodes()) {
        generateCalendar(currentMonth);
        generateTimeSlots();
    }
    
    // Initialize map if step 4
    if (step === 4) {
        initMap();
    }
}

function generateCalendar(date) {
    // Clear calendar
    calendar.innerHTML = '';
    
    // Add month/year header
    const monthYearHeader = document.createElement('div');
    monthYearHeader.className = 'col-span-7 text-center font-bold text-blue-800 mb-2';
    monthYearHeader.textContent = date.toLocaleDateString('pt-BR', { 
        month: 'long', 
        year: 'numeric' 
    }).replace(/^\w/, c => c.toUpperCase());
    calendar.appendChild(monthYearHeader);
    
    // Add day names
    const daysOfWeek = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    daysOfWeek.forEach(day => {
        const dayElement = document.createElement('div');
        dayElement.className = 'text-center font-medium text-sm py-1';
        dayElement.textContent = day;
        calendar.appendChild(dayElement);
    });
    
    // Get first day of month and days in month
    const firstDay = new Date(date.getFullYear(), date.getMonth(), 1).getDay();
    const daysInMonth = new Date(date.getFullYear(), date.getMonth() + 1, 0).getDate();
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    // Add empty days for first week
    for (let i = 0; i < firstDay; i++) {
        calendar.appendChild(document.createElement('div'));
    }
    
    // Add days of month
    for (let day = 1; day <= daysInMonth; day++) {
        const dayElement = document.createElement('div');
        dayElement.className = 'calendar-day text-center py-2 rounded-full';
        dayElement.textContent = day;
        
        const currentDate = new Date(date.getFullYear(), date.getMonth(), day);
        
        // Highlight today
        if (currentDate.toDateString() === today.toDateString()) {
            dayElement.classList.add('today');
        }
        
        // Disable past dates
        if (currentDate < today) {
            dayElement.classList.add('disabled');
        } else {
            dayElement.addEventListener('click', () => {
                document.querySelectorAll('.calendar-day').forEach(d => {
                    d.classList.remove('selected');
                });
                dayElement.classList.add('selected');
                selectedDate = currentDate;
                summaryDate.textContent = currentDate.toLocaleDateString('pt-BR');
                generateTimeSlots();
            });
        }
        
        calendar.appendChild(dayElement);
    }
}

function generateTimeSlots() {
    timeSlots.innerHTML = '';
    
    if (!selectedDate) {
        timeSlots.innerHTML = '<p class="col-span-full text-center text-gray-500">Selecione uma data primeiro</p>';
        return;
    }
    
    // Generate time slots (8:00 to 17:00, every 30 minutes)
    const slots = [];
    for (let hour = 8; hour < 17; hour++) {
        slots.push(`${hour}:00`);
        slots.push(`${hour}:30`);
    }
    
    // Add time slots to the grid
    slots.forEach(slot => {
        const slotElement = document.createElement('div');
        slotElement.className = 'time-slot text-center py-2 rounded-md border border-gray-200';
        slotElement.textContent = slot;
        
        // Randomly mark some slots as booked (for demo)
        if (Math.random() < 0.3) {
            slotElement.classList.add('booked');
        } else {
            slotElement.addEventListener('click', () => {
                document.querySelectorAll('.time-slot').forEach(s => {
                    s.classList.remove('selected');
                });
                slotElement.classList.add('selected');
                selectedTime = slot;
                summaryTime.textContent = slot;
            });
        }
        
        timeSlots.appendChild(slotElement);
    });
}

function initMap() {
    const map = new mapboxgl.Map({
        container: 'map',
        style: 'mapbox://styles/mapbox/streets-v11',
        center: [-46.5333, -23.4625], // Guarulhos coordinates
        zoom: 13
    });
    
    // Add navigation controls
    map.addControl(new mapboxgl.NavigationControl());
    
    // Add UBS locations (sample data)
    const ubsLocations = [
        { name: 'UBS Vila Galvão', coordinates: [-46.5333, -23.4625], address: 'Rua São Paulo, 100' },
        { name: 'UBS Centro', coordinates: [-46.5250, -23.4560], address: 'Av. Tiradentes, 1000' },
        { name: 'UBS Pimentas', coordinates: [-46.5400, -23.4700], address: 'Rua das Flores, 500' }
    ];
    
    // Add markers for each UBS
    ubsLocations.forEach(ubs => {
        const marker = new mapboxgl.Marker({ color: '#0ea5e9' })
            .setLngLat(ubs.coordinates)
            .setPopup(new mapboxgl.Popup().setHTML(`
                <h3 class="font-bold">${ubs.name}</h3>
                <p class="text-sm">${ubs.address}</p>
                <button class="mt-2 text-sm text-blue-600 hover:underline select-ubs" data-name="${ubs.name}">
                    Selecionar esta UBS
                </button>
            `))
            .addTo(map);
        
        // Open popup for the default selected UBS
        if (ubs.name === selectedLocation) {
            marker.togglePopup();
        }
    });
    
    // Handle UBS selection from popup
    document.addEventListener('click', (e) => {
        if (e.target.classList.contains('select-ubs')) {
            const ubsName = e.target.dataset.name;
            selectedLocation = ubsName;
            summaryLocation.textContent = ubsName;
        }
    });
    
    // Center map on user's location
    document.querySelector('.fa-location-arrow').closest('button').addEventListener('click', () => {
        navigator.geolocation.getCurrentPosition(position => {
            map.flyTo({
                center: [position.coords.longitude, position.coords.latitude],
                zoom: 14
            });
        }, () => {
            alert('Não foi possível obter sua localização');
        });
    });
}

// Initialize default specialty selection
specialtyCards[0].classList.add('border-blue-500', 'bg-blue-50');

// Set default date to today if not in the past
const today = new Date();
today.setHours(0, 0, 0, 0);
selectedDate = today;
summaryDate.textContent = today.toLocaleDateString('pt-BR');
