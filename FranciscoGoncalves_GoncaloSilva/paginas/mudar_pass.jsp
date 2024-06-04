<%@ include file="../basedados/basedados.h" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%

    // Confirmação de nível
    String nivel = (String) session.getAttribute("nivel");
    if (nivel == null || !nivel.equals("admin")) {
        response.sendRedirect("logout.jsp");
        return;
    }

    String utilizador = request.getParameter("utilizador");

    if (request.getParameter("submit") != null) {
        String password = request.getParameter("pass");
        String confirmacao = request.getParameter("confirmacao");

        if (password.equals(confirmacao)) {
            PreparedStatement ps = null;

            try {
                String sql = "UPDATE utilizador SET palavra_passe = md5(?) WHERE username = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, password);
                ps.setString(2, utilizador);

                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    out.println("<script>alert('Atualizado com sucesso!');</script>");
                } else {
                    out.println("<script>alert('Atualizado sem sucesso :(!');</script>");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } 
        } else {
            out.println("<script>");
            out.println("if (confirm('As palavras-passe não coincidem!')) {");
            out.println("    window.location.href = 'mudar_pass.jsp?utilizador=" + utilizador + "';");
            out.println("}");
            out.println("</script>");
        }
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
                    out.print("<a class='navbar-brand' href='pagina_inicial.jsp'>Formação Total</a>");
                } else {
                    out.print("<a class='navbar-brand' href='pagina_inicial_adm.jsp'>Formação Total</a>");
                }
            %>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <%
                        if (session.getAttribute("username") != null) {
                            out.print("<li class='nav-item'><a class='nav-link' aria-current='page' href='logout.jsp'>Terminar Sessão</a></li>");
                        } else {
                            out.print("<li class='nav-item'><a class='nav-link' aria-current='page' href='iniciar_sessao.jsp'>Iniciar Sessão</a></li>");
                            out.print("<li class='nav-item'><a class='nav-link' aria-current='page' href='criar_conta.jsp'>Criar Conta</a></li>");
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
        <div class="caixa" style="min-width: 30%;">
            <div id="cabecalho" style="display: flex;justify-content: center;align-items: center;">
                <div class="caixa" style="width: 100%; text-align: center;border: none;margin-top:20px;margin-bottom:20px;">
                    <h1>Alterar Palavra-Passe</h1>
                </div>
            </div>

            <form action="mudar_pass.jsp?utilizador=<%= utilizador %>" method="post" style="text-align: center; padding: 100px;">
                    Nova palavra-passe:
                    <input type="password" name="pass" required minlength="8">
                    <br><br>
                    Confirmar palavra-passe:
                    <input type="password" name="confirmacao" required minlength="8">
                    <br><br><br><br>
                    <div><button class="botao" name="submit" type="submit">Atualizar</button></div>
                </form>   
            </div>
        </div>
        
        <!-- Bootstrap JS e dependências -->
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
    </body>
</html>
