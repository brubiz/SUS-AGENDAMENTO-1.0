<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="theme-color" content="#0ea5e9">
    <title>Agendamento SUS Guarulhos</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://api.mapbox.com/mapbox-gl-js/v2.9.1/mapbox-gl.css" rel="stylesheet">
    <script src="https://api.mapbox.com/mapbox-gl-js/v2.9.1/mapbox-gl.js"></script>
    <link rel="stylesheet" href="styles.css">
</head>
<body class="bg-blue-50 min-h-screen">
    <!-- Header -->
    <header class="bg-blue-600 text-white shadow-md">
        <div class="container mx-auto px-4 py-4 flex justify-between items-center">
            <div class="flex items-center space-x-2">
                <i class="fas fa-hospital text-2xl"></i>
                <h1 class="text-xl md:text-2xl font-bold">Agendamento SUS Guarulhos</h1>
            </div>
            <div id="auth-section">
                <button id="login-btn" class="bg-white text-blue-600 px-4 py-2 rounded-md font-medium hover:bg-blue-50 transition">
                    <i class="fas fa-sign-in-alt mr-1"></i> Entrar
                </button>
            </div>
        </div>
    </header>

    <!-- Login Modal -->
    <div id="login-modal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
        <div class="bg-white rounded-lg p-6 w-full max-w-md mx-4">
            <div class="flex justify-between items-center mb-4">
                <h2 class="text-xl font-bold text-blue-600">Acesse com seu Cartão SUS</h2>
                <button id="close-login" class="text-gray-500 hover:text-gray-700">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <form id="login-form" class="space-y-4">
                <div>
                    <label for="cpf" class="block text-sm font-medium text-gray-700">CPF</label>
                    <input type="text" id="cpf" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500" placeholder="000.000.000-00" required>
                    <p class="mt-1 text-sm text-gray-500">Digite apenas números</p>
                </div>
                <div>
                    <label for="sus-number" class="block text-sm font-medium text-gray-700">Nº do Cartão SUS</label>
                    <input type="text" id="sus-number" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500" placeholder="000 0000 0000 0000" required>
                </div>
                <div>
                    <button type="submit" class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                        <i class="fas fa-sign-in-alt mr-2"></i> Entrar
                    </button>
                </div>
            </form>
            <div class="mt-4 text-center">
                <p class="text-sm text-gray-600">Problemas para acessar? <a href="#" class="font-medium text-blue-600 hover:text-blue-500">Clique aqui</a></p>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <main class="container mx-auto px-4 py-8">
        <!-- Step Indicator -->
        <div class="mb-8">
            <div class="flex justify-between">
                <div class="step flex flex-col items-center w-1/4" data-step="1">
                    <div class="w-10 h-10 rounded-full bg-blue-600 text-white flex items-center justify-center font-bold mb-2">1</div>
                    <span class="text-sm text-center font-medium text-blue-600">Login</span>
                </div>
                <div class="step flex flex-col items-center w-1/4" data-step="2">
                    <div class="w-10 h-10 rounded-full bg-gray-300 text-gray-600 flex items-center justify-center font-bold mb-2">2</div>
                    <span class="text-sm text-center font-medium text-gray-600">Especialidade</span>
                </div>
                <div class="step flex flex-col items-center w-1/4" data-step="3">
                    <div class="w-10 h-10 rounded-full bg-gray-300 text-gray-600 flex items-center justify-center font-bold mb-2">3</div>
                    <span class="text-sm text-center font-medium text-gray-600">Data/Horário</span>
                </div>
                <div class="step flex flex-col items-center w-1/4" data-step="4">
                    <div class="w-10 h-10 rounded-full bg-gray-300 text-gray-600 flex items-center justify-center font-bold mb-2">4</div>
                    <span class="text-sm text-center font-medium text-gray-600">Confirmação</span>
                </div>
            </div>
            <div class="w-full bg-gray-200 rounded-full h-2.5 mt-4">
                <div class="bg-blue-600 h-2.5 rounded-full" style="width: 25%" id="progress-bar"></div>
            </div>
        </div>

        <!-- Step 1: Welcome -->
        <div id="step-1" class="bg-white rounded-lg shadow-md p-6 mb-8">
            <div class="text-center">
                <i class="fas fa-heartbeat text-6xl text-blue-600 mb-4"></i>
                <h2 class="text-2xl font-bold text-gray-800 mb-2">Bem-vindo ao Agendamento SUS Guarulhos</h2>
                <p class="text-gray-600 mb-6">Agende sua consulta de forma rápida e fácil. Para começar, faça login com seu CPF e Cartão SUS.</p>
                <button id="start-login" class="bg-blue-600 text-white px-6 py-3 rounded-md font-medium hover:bg-blue-700 transition">
                    <i class="fas fa-sign-in-alt mr-2"></i> Fazer Login
                </button>
            </div>
        </div>

        <!-- Step 2: Specialty Selection (Hidden Initially) -->
        <div id="step-2" class="bg-white rounded-lg shadow-md p-6 mb-8 hidden">
            <h2 class="text-xl font-bold text-gray-800 mb-6">Selecione a especialidade médica</h2>
            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                <div class="specialty-card bg-white border border-gray-200 rounded-lg p-4 flex flex-col items-center cursor-pointer">
                    <i class="fas fa-heart text-3xl text-blue-600 mb-2"></i>
                    <h3 class="font-medium text-center">Cardiologia</h3>
                </div>
                <div class="specialty-card bg-white border border-gray-200 rounded-lg p-4 flex flex-col items-center cursor-pointer">
                    <i class="fas fa-lungs text-3xl text-blue-600 mb-2"></i>
                    <h3 class="font-medium text-center">Pneumologia</h3>
                </div>
                <div class="specialty-card bg-white border border-gray-200 rounded-lg p-4 flex flex-col items-center cursor-pointer">
                    <i class="fas fa-brain text-3xl text-blue-600 mb-2"></i>
                    <h3 class="font-medium text-center">Neurologia</h3>
                </div>
                <div class="specialty-card bg-white border border-gray-200 rounded-lg p-4 flex flex-col items-center cursor-pointer">
                    <i class="fas fa-bone text-3xl text-blue-600 mb-2"></i>
                    <h3 class="font-medium text-center">Ortopedia</h3>
                </div>
                <div class="specialty-card bg-white border border-gray-200 rounded-lg p-4 flex flex-col items-center cursor-pointer">
                    <i class="fas fa-eye text-3xl text-blue-600 mb-2"></i>
                    <h3 class="font-medium text-center">Oftalmologia</h3>
                </div>
                <div class="specialty-card bg-white border border-gray-200 rounded-lg p-4 flex flex-col items-center cursor-pointer">
                    <i class="fas fa-ear text-3xl text-blue-600 mb-2"></i>
                    <h3 class="font-medium text-center">Otorrinolaringologia</h3>
                </div>
                <div class="specialty-card bg-white border border-gray-200 rounded-lg p-4 flex flex-col items-center cursor-pointer">
                    <i class="fas fa-child text-3xl text-blue-600 mb-2"></i>
                    <h3 class="font-medium text-center">Pediatria</h3>
                </div>
                <div class="specialty-card bg-white border border-gray-200 rounded-lg p-4 flex flex-col items-center cursor-pointer">
                    <i class="fas fa-female text-3xl text-blue-600 mb-2"></i>
                    <h3 class="font-medium text-center">Ginecologia</h3>
                </div>
            </div>
            <div class="mt-6 flex justify-end">
                <button class="next-step bg-blue-600 text-white px-6 py-2 rounded-md font-medium hover:bg-blue-700 transition" data-next="3">
                    Próximo <i class="fas fa-arrow-right ml-1"></i>
                </button>
            </div>
        </div>

        <!-- Step 3: Date and Time Selection (Hidden Initially) -->
        <div id="step-3" class="bg-white rounded-lg shadow-md p-6 mb-8 hidden">
            <h2 class="text-xl font-bold text-gray-800 mb-6">Selecione a data e horário</h2>
            
            <div class="mobile-stack flex flex-wrap gap-6">
                <!-- Calendar -->
                <div class="flex-1 min-w-[300px]">
                    <div class="mb-4 flex justify-between items-center">
                        <h3 class="font-medium">Calendário</h3>
                        <div class="flex space-x-2">
                            <button id="prev-month" class="p-2 rounded-full hover:bg-gray-100">
                                <i class="fas fa-chevron-left"></i>
                            </button>
                            <button id="next-month" class="p-2 rounded-full hover:bg-gray-100">
                                <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                    <div id="calendar" class="grid grid-cols-7 gap-1 mb-4">
                        <!-- Calendar will be generated by JavaScript -->
                    </div>
                </div>
                
                <!-- Time Slots -->
                <div class="flex-1 min-w-[300px]">
                    <h3 class="font-medium mb-4">Horários disponíveis</h3>
                    <div id="time-slots" class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-2">
                        <!-- Time slots will be loaded by JavaScript -->
                    </div>
                </div>
            </div>
            
            <div class="mt-6 flex justify-between">
                <button class="prev-step bg-gray-200 text-gray-700 px-6 py-2 rounded-md font-medium hover:bg-gray-300 transition" data-prev="2">
                    <i class="fas fa-arrow-left mr-1"></i> Voltar
                </button>
                <button class="next-step bg-blue-600 text-white px-6 py-2 rounded-md font-medium hover:bg-blue-700 transition" data-next="4">
                    Próximo <i class="fas fa-arrow-right ml-1"></i>
                </button>
            </div>
        </div>

        <!-- Step 4: Location and Confirmation (Hidden Initially) -->
        <div id="step-4" class="bg-white rounded-lg shadow-md p-6 mb-8 hidden">
            <h2 class="text-xl font-bold text-gray-800 mb-6">Confirme seu agendamento</h2>
            
            <div class="mobile-stack flex flex-wrap gap-6">
                <!-- Appointment Summary -->
                <div class="flex-1 min-w-[300px]">
                    <div class="bg-blue-50 rounded-lg p-4 mb-4">
                        <h3 class="font-medium text-blue-800 mb-2">Resumo da Consulta</h3>
                        <div class="space-y-2">
                            <p><span class="font-medium">Especialidade:</span> <span id="summary-specialty">Cardiologia</span></p>
                            <p><span class="font-medium">Data:</span> <span id="summary-date">15/06/2023</span></p>
                            <p><span class="font-medium">Horário:</span> <span id="summary-time">14:30</span></p>
                            <p><span class="font-medium">Local:</span> <span id="summary-location">UBS Vila Galvão</span></p>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label for="notes" class="block text-sm font-medium text-gray-700 mb-1">Observações (opcional)</label>
                        <textarea id="notes" rows="3" class="w-full border border-gray-300 rounded-md p-2 focus:ring-blue-500 focus:border-blue-500" placeholder="Informações adicionais sobre sua consulta..."></textarea>
                    </div>
                    
                    <div class="flex items-center mb-4">
                        <input type="checkbox" id="confirm-terms" class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                        <label for="confirm-terms" class="ml-2 block text-sm text-gray-700">Confirmo que li e aceito os <a href="#" class="text-blue-600 hover:underline">termos de uso</a></label>
                    </div>
                    
                    <button id="confirm-appointment" class="w-full bg-green-600 text-white px-6 py-3 rounded-md font-medium hover:bg-green-700 transition">
                        <i class="fas fa-calendar-check mr-2"></i> Confirmar Agendamento
                    </button>
                </div>
                
                <!-- Map -->
                <div class="flex-1 min-w-[300px]">
                    <h3 class="font-medium mb-2">Unidade de Saúde</h3>
                    <p class="text-sm text-gray-600 mb-4">UBS Vila Galvão - Rua São Paulo, 100 - Vila Galvão, Guarulhos - SP</p>
                    
                    <div id="map" class="map-container relative">
                        <div class="absolute top-2 left-2 bg-white p-2 rounded-md shadow-md z-10">
                            <button class="flex items-center text-sm px-2 py-1">
                                <i class="fas fa-location-arrow mr-1 text-blue-600"></i> Minha localização
                            </button>
                        </div>
                    </div>
                    
                    <div class="mt-4">
                        <h4 class="font-medium mb-2">Como chegar</h4>
                        <div class="flex flex-wrap gap-2">
                            <button class="flex items-center text-sm bg-gray-100 px-3 py-1 rounded-md hover:bg-gray-200">
                                <i class="fas fa-bus mr-1"></i> Ônibus
                            </button>
                            <button class="flex items-center text-sm bg-gray-100 px-3 py-1 rounded-md hover:bg-gray-200">
                                <i class="fas fa-subway mr-1"></i> Metrô
                            </button>
                            <button class="flex items-center text-sm bg-gray-100 px-3 py-1 rounded-md hover:bg-gray-200">
                                <i class="fas fa-car mr-1"></i> Carro
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="mt-6">
                <button class="prev-step bg-gray-200 text-gray-700 px-6 py-2 rounded-md font-medium hover:bg-gray-300 transition" data-prev="3">
                    <i class="fas fa-arrow-left mr-1"></i> Voltar
                </button>
            </div>
        </div>

        <!-- Success Modal (Hidden Initially) -->
        <div id="success-modal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
            <div class="bg-white rounded-lg p-6 w-full max-w-md text-center">
                <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                    <i class="fas fa-check text-3xl text-green-600"></i>
                </div>
                <h2 class="text-xl font-bold text-gray-800 mb-2">Agendamento Confirmado!</h2>
                <p class="text-gray-600 mb-6">Sua consulta foi agendada com sucesso. Você receberá um e-mail com os detalhes.</p>
                <div class="bg-blue-50 rounded-lg p-4 mb-4 text-left">
                    <p class="font-medium">Número do protocolo: <span class="font-normal">SUS-GRU-20230615-1425</span></p>
                    <p class="font-medium">Data da consulta: <span class="font-normal">15/06/2023 às 14:30</span></p>
                    <p class="font-medium">Local: <span class="font-normal">UBS Vila Galvão</span></p>
                </div>
                <button id="close-success" class="bg-blue-600 text-white px-6 py-2 rounded-md font-medium hover:bg-blue-700 transition">
                    <i class="fas fa-check mr-1"></i> Fechar
                </button>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-blue-800 text-white py-8">
        <div class="container mx-auto px-4">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                <div>
                    <h3 class="text-lg font-bold mb-4">Agendamento SUS Guarulhos</h3>
                    <p class="text-blue-200">Agende suas consultas do SUS de forma rápida e fácil.</p>
                </div>
                <div>
                    <h3 class="text-lg font-bold mb-4">Links Úteis</h3>
                    <ul class="space-y-2">
                        <li><a href="#" class="text-blue-200 hover:text-white">Central de Atendimento</a></li>
                        <li><a href="#" class="text-blue-200 hover:text-white">Unidades de Saúde</a></li>
                        <li><a href="#" class="text-blue-200 hover:text-white">Dúvidas Frequentes</a></li>
                    </ul>
                </div>
                <div>
                    <h3 class="text-lg font-bold mb-4">Contato</h3>
                    <ul class="space-y-2">
                        <li class="flex items-center"><i class="fas fa-phone-alt mr-2"></i> (11) 2464-0000</li>
                        <li class="flex items-center"><i class="fas fa-envelope mr-2"></i> sus@guarulhos.sp.gov.br</li>
                        <li class="flex items-center"><i class="fas fa-map-marker-alt mr-2"></i> Prefeitura de Guarulhos</li>
                    </ul>
                </div>
            </div>
            <div class="border-t border-blue-700 mt-8 pt-6 text-center text-blue-200">
                <p>© 2023 Secretaria Municipal de Saúde de Guarulhos. Todos os direitos reservados.</p>
            </div>
        </div>
    </footer>

    <script src="script.js"></script>
</body>
</html>