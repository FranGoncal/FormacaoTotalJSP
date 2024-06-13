<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
        <% 
            // Validação de que a sessão está iniciada, caso não esteja, damos o valor do nível vazio.
            String nivel = (String) session.getAttribute("nivel");
            if (nivel == null || nivel.equals("aluno")) {
        %>
        <!-- Se o nível for aluno, redireciona para a página inicial do aluno -->
        <a class="navbar-brand" href="pagina_inicial.jsp">Formação Total</a>
        <% 
            } 
            else {
        %>
        <!-- Caso contrário, redireciona para a página inicial do administrador -->
        <a class="navbar-brand" href="pagina_inicial_adm.jsp">Formação Total</a>
        <% 
            }
        %>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <% 
                    if (session.getAttribute("username") != null) {// No caso de ter sessao iniciada
                %>
                <!-- Mostra a opção de terminar sessão -->
                <li class="nav-item">
                    <a class="nav-link" aria-current="page" href="logout.jsp">Terminar Sessão</a>
                </li>
                <% 
                    } 
                    else {// No caso de não ter iniciado sessao
                %>
                <!-- Mostra as opções da navbar iniciar sessao e criar conta -->
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
                    <a class="nav-link" href="#">Sobre</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Conteúdo da página-->
<div class="contorno">
    <div class="caixa" style="padding-bottom: 10px; padding-right: 10px; padding-left: 10px; ">
        <br>
        <center>
            <h1>Sobre o Centro de Cursos de Formações</h1>
        </center>
        <br>
        <div class="descricao">
            <p>Bem-vindo ao Centro de Cursos de Formações, onde a aprendizagem ganha vida!</p>
            <p>Estamos comprometidos em fornecer educação excepcional e oportunidades de desenvolvimento para todos.</p>
            <p>Aqui, você encontrará uma ampla gama de cursos e treinamentos em diversas áreas, incluindo:</p>
            <ul>
                <li>Tecnologia e Desenvolvimento de Software</li>
                <li>Negócios e Empreendedorismo</li>
                <li>Saúde e Bem-Estar</li>
                <li>Artes e Criatividade</li>
            </ul>
            <p>Nossa missão é capacitar indivíduos e empresas com as habilidades necessárias para prosperar num mundo em constante mudança.</p>
            <p>Seja um estudante ávido por conhecimento ou uma empresa em busca de aprimoramento profissional para a sua equipa, temos tudo o que precisa para alcançar os seus objetivos.</p>
            <p>Junte-se a nós e embarque nesta jornada emocionante de aprendizado e crescimento!</p>
            <br>
            <p>Horario: Diurno/Noturno</p>
            <p>Preço: 9.99€/mês</p>
            <p>Morada: R. Poço do Moleiro, Castelo Branco </p>
        </div>
    </div>
</div>

<!-- Bootstrap JS e dependências -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
</body>
</html>
