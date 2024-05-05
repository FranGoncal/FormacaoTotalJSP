<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formação Total</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Estilos personalizados -->
    <link rel="stylesheet" href="folha_css.css">
</head>
<body>
<!-- Cabeçalho -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container">
        <a class="navbar-brand" href="#">Formação Total</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <% 
                    if(session.getAttribute("username") != null) { // No caso de ter sessao iniciada
                %>
                <!-- Mostra a opcao de terminar sessao -->
                <li class="nav-item">
                    <a class="nav-link" aria-current="page" href="logout.jsp">Terminar Sessão</a>
                </li>
                <% 
                    } else { // No caso de nao ter iniciado sessao
                %>
                <!-- Mostra as opcoes da navbar iniciar sessao e criar conta -->
                <li class="nav-item">
                    <a class="nav-link" aria-current="page" href="iniciar_sessao.jsp">Iniciar Sessão</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" aria-current="page" href="criar_conta.jsp">Criar Conta</a>
                </li>
                <% 
                    } 
                %>
                <li class="nav-item">
                    <a class="nav-link" href="sobre.jsp">Sobre</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Conteúdo da página-->
<div class="contorno">
    <div class="caixa">
        <br>
        <center>
            <h1>Bem-vindo à Formação Total</h1>
        </center>
        <br>
        <div class="linha">
            <div class="conteudo1">
                <img src="forma.png" alt="" style="max-width: 85%; height: auto;">
            </div>
            <div class="conteudo2">
                <p>Aqui você pode encontrar cursos incríveis para desenvolver as suas habilidades.
                    <br>Selecione entre uma variedade de cursos em diferentes áreas, incluindo tecnologia, negócios, arte e muito mais e inscreva-se já!</p>
                <p>Estamos comprometidos em fornecer a melhor experiência, validando todos os docentes para garantir um ensino de qualidade!</p>
                <p>De que está à espera? </p>
            </div>
        </div>
        <div class="linha">
            <div class="conteudo2">
                <p>Sabia que a inscrição em cursos online leva a 70% do sucesso dos jovens de hoje em dia?
                    <br>Sim, isso mesmo! E isso é devido ao facto dos cursos estarem em constante melhoria! 
                    Daí o sucesso dos estudantes que usam este tipo de método de aprendizagem. </p>
            </div>
            <div class="conteudo1">
                <img src="curso.jpg" alt="" style="max-width: 85%; height: auto;">
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS e dependências -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
</body>
</html>
