<%@	include	file="../basedados/basedados.h"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String nome = "";
    String data_nasc = "";

    String nivel = (String) session.getAttribute("nivel");
    if (nivel == null || !(nivel.equals("docente") || nivel.equals("admin"))) {
        response.sendRedirect("logout.jsp");
        return;
    }

    String curso = request.getParameter("curso");
    String username = (String) request.getParameter("utilizador");

    try {
        String sql = "SELECT * FROM utilizador WHERE username = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            nome = rs.getString("nome");
            data_nasc = rs.getString("data_nasc");
        } 
        else {
            out.println("<script>alert('Nenhum utilizador encontrado!');</script>");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
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
        <% 
            if ("aluno".equals(session.getAttribute("nivel"))) {
        %>
            <a class="navbar-brand" href="pagina_inicial.jsp">Formação Total</a>
        <% } 
            else { %>
            <a class="navbar-brand" href="pagina_inicial_adm.jsp">Formação Total</a>
        <% } %>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <% 
                    if (session.getAttribute("username") != null) {
                %>
                <!-- Mostra a opção de terminar sessão -->
                <li class="nav-item">
                    <a class="nav-link" aria-current="page" href="logout.jsp">Terminar Sessão</a>
                </li>
                <% 
                    } 
                    else {
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
    <div class="caixa" style="min-width: 60%;">
        <div id="cabecalho" style="display: flex;justify-content: center;align-items: center;">
            <div class="caixa" style="width: 100%; text-align: center;border: none;margin-top:20px;margin-bottom:20px;">
                <h1>Fazer Inscrição em <%= curso %></h1>
            </div>
        </div>

        <div style="min-height: 500px;display: flex;">

            <div id="esquerda" style="width:50%; padding-top: 60px;padding-bottom: 60px;text-align: center;" >
                <img src="user.png" style="width: 200px; height:200px;margin-bottom: 24px;" alt="">
            </div>

            <div id="direita" style="width:50%; padding-top: 60px;padding-bottom: 60px; padding-left: 50px;text-align: left;">
                
                <form method="post" action="editar_inscricao.jsp?utilizador=<%= username %>&acao=inscrever&curso=<%= curso %>">
                    Nome de Utilizador: <th><%= username %><br><br>
                    Nome: <%= nome %><br><br>
                    Data de Nascimento: <%= data_nasc %><br><br>

                    <select id="opcoes" name="horario" style="margin-left: 5px;" required>
                        <option value="Diurno">Diurno</option>
                        <option value="Noturno">Noturno</option>
                    </select>
                    <br><br><br>
                    
                    <div style="margin-left: 100px;"><button class="botao" name="submit" type="submit">Inscrever</button></div>    
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS e dependências -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
</body>
</html>
