<%@	include	file="../basedados/basedados.h"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page language="java" import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.security.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.sql.PreparedStatement" %>

<%
    String username = request.getParameter("username");
    String password = request.getParameter("palavra_passe");
    
    if (request.getParameter("submit") != null) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = null;
        
        try {
            sql = "SELECT nivel FROM utilizador WHERE username = '"+username+"' AND palavra_passe = md5('"+password+"')";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                String nivel = rs.getString("nivel");

                session.setAttribute( "nivel", nivel );
                session.setAttribute( "username", username );

                if (nivel.equals("aluno")) {
                    response.sendRedirect("pagina_inicial.jsp");
                } else if (nivel.equals("admin") || nivel.equals("docente")) {
                    response.sendRedirect("pagina_inicial_adm.jsp");
                } else if (nivel.equals("pendente")) {
                    out.println("<script>");
                    out.println("if(confirm('A sua conta ainda não foi validada. Tente mais tarde!')) {");
                    out.println("window.location.href = 'logout.jsp';");
                    out.println("}");
                    out.println("</script>");
                } else if (nivel.equals("apagado")) {
                    out.println("<script>");
                    out.println("if(confirm('A sua conta foi apagada!')) {");
                    out.println("window.location.href = 'logout.jsp';");
                    out.println("}");
                    out.println("</script>");
                } else {
                    out.println("<script>");
                    out.println("if(confirm('Este acesso não foi autorizado!')) {");
                    out.println("window.location.href = 'logout.jsp';");
                    out.println("}");
                    out.println("</script>");
                }
            } else {
                out.println("<script>alert('Credenciais incorretas! :(');</script>");
            }
        } catch (SQLException e) {
            out.println("<script>alert('Erro ao obter os dados do utilizador! :(');</script>");
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formação Total - Iniciar Sessão</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Estilos personalizados -->
    <link rel="stylesheet" href="folha_css.css">
</head>
<body>
    <!-- Cabeçalho -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <div class="container">
            <a class="navbar-brand" href="pagina_inicial.jsp">Formação Total</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" aria-current="page" href="#">Iniciar Sessão</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" aria-current="page" href="criar_conta.jsp">Criar Conta</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="sobre.jsp">Sobre</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Conteúdo da página-->
    <br><br><br><br><br><br><br>
    <div class="container">
        <div class="row justify-content-center mt-5">
            <div class="col-md-6">
                <div class="card" style="border: 2px solid #5a5959;">
                    <div class="card-header">
                        <h3 class="text-center">Iniciar Sessão</h3>
                    </div>
                    <div class="card-body">
                        <form action="iniciar_sessao.jsp" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label">Nome de Utilizador</label>
                                <input required type="text" name="username" class="form-control" id="username">
                            </div>
                            <div class="mb-3">
                                <label for="palavra_passe" class="form-label">Palavra Passe</label>
                                <input required type="password" name="palavra_passe" class="form-control" id="senha">
                            </div>
                            <button type="submit" name="submit" class="btn btn-primary btn-block">Iniciar Sessão</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS e dependências -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
</body>
</html>
