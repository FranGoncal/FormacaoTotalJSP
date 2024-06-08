<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String nivel = (String) session.getAttribute("nivel");
    if (nivel == null || !(nivel.equals("docente") || nivel.equals("admin"))) {
        response.sendRedirect("logout.jsp");
        return;
    }
%>

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
                    if (session.getAttribute("username") != null) {// No caso de ter sessão iniciada
                %>
                <!-- Mostra a opção de terminar sessão -->
                <li class="nav-item">
                    <a class="nav-link" aria-current="page" href="logout.jsp">Terminar Sessão</a>
                </li>
                <% 
                    } 
                    else {// No caso de não ter iniciado sessão
                %>
                <!-- Mostra as opções da navbar iniciar sessão e criar conta -->
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
    <% 
        if ("docente".equals(session.getAttribute("nivel"))) {// No caso de ser docente
    %>
    <div class="caixa">
        <div id="cabecalho" style="display: flex;justify-content: center;align-items: center;">
            <div class="caixa" style="width: 100%; text-align: center;border: none;margin-top:20px;margin-bottom:20px;">
                <h1>Área de Docente</h1>
            </div>
        </div>

        <div style="display: flex;">
            <div style="border-right: 1px solid #999999;width: 50%; padding-top: 60px;padding-bottom: 60px;text-align: center;margin-bottom: 10px;">
                <a href="dados_pessoais.jsp" style="cursor: pointer;">
                    <div><img src="dadosPessoais.png" style="width: 250px; height:250px;margin-bottom: 24px;" alt="Search Icon" class="search-icon"></div>
                    <div><button class="botao" name ="submit" type="submit">Gerir Dados Pessoais</button></div>
                </a>
            </div>

            <div style="border-left : 1px solid #999999;width: 50%; padding-top: 60px;padding-bottom: 60px;text-align: center;margin-bottom: 10px;">
                <a href="gestao_formacoes.jsp" style="cursor: pointer;">
                    <div><img src="livros.png" style="width: 250px; height:250px;margin-bottom: 24px;" alt="Search Icon" class="search-icon"></div>
                    <div><button class="botao" name ="submit" type="submit">Gerir Cursos de Formações</button></div>
                </a>
            </div>
        </div>
    </div>
    <% 
        } else if ("admin".equals(session.getAttribute("nivel"))) {// No caso de ser admin
    %>
    <div class="caixa" style="width: 1000px;">
        <div id="cabecalho" style="display: flex;justify-content: center;align-items: center;">
            <div class="caixa" style="width: 100%; text-align: center;border: none;margin-top:20px;margin-bottom:20px;">
                <h1>Área de Administrador</h1>
            </div>
        </div>

        <div style="display: flex;">
            <div style="border-right: 1px solid #999999;width: 50%; padding-top: 60px;padding-bottom: 60px;text-align: center;margin-bottom: 10px;">
                <a href="dados_pessoais.jsp" style="cursor: pointer;">
                    <div><img src="dadosPessoais.png" style="width: 250px; height:250px;margin-bottom: 24px;" alt="Search Icon" class="search-icon"></div>
                    <div><button class="botao" name ="submit" type="submit">Gerir Dados Pessoais</button></div>
                </a>
            </div>
            <div style="border-left : 1px solid #999999;width: 50%; padding-top: 60px;padding-bottom: 60px;text-align: center;margin-bottom: 10px;">
                <a href="gestao_formacoes.jsp" style="cursor: pointer;">
                    <div><img src="livros.png" style="width: 250px; height:250px;margin-bottom: 24px;" alt="Search Icon" class="search-icon"></div>
                    <div><button class="botao" name ="submit" type="submit">Gerir Cursos de Formação</button></div>
                </a>
            </div>
            <div style="border-left : 1px solid #999999;width: 50%; padding-top: 60px;padding-bottom: 60px;text-align: center;margin-bottom: 10px;">
                <a href="gerir_utilizadores.jsp" style="cursor: pointer;">
                    <div><img src="users.png" style="width: 250px; height:250px;margin-bottom: 24px;" alt="Search Icon" class="search-icon"></div>
                    <div><button class="botao" name ="submit" type="submit">Gerir Utilizadores</button></div>
                </a>
            </div>
        </div>
    </div>
    <% 
        } 
        else {
            response.sendRedirect("logout.jsp");
        }
    %>
</div>
<!-- Bootstrap JS e dependências -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
</body>
</html>
