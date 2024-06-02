<%@	include	file="../basedados/basedados.h"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%!
    boolean usernameValido(String username, Connection conn) throws SQLException {
        String sql = "SELECT * FROM utilizador WHERE username = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, username);
        ResultSet rs = pstmt.executeQuery();

        //retorna se a consulta !(encontrou utilizador)
        return !rs.next(); 
    }
%>

<%
    String nivel = (String) session.getAttribute("nivel");
    if (nivel == null || !nivel.equals("admin")) {
        response.sendRedirect("logout.jsp");
    }

    boolean userCreated = false;        //TODOOOOOOOOOOOO REVER VARIAVEIS
    boolean errorOccurred = false;      //TODOOOOOOOOOOOO REVER VARIAVEIS
    boolean usernameExists = false;     //TODOOOOOOOOOOOO REVER VARIAVEIS
    boolean passwordsMismatch = false;  //TODOOOOOOOOOOOO REVER VARIAVEIS

    if (request.getParameter("submit") != null) {
        String data_nasc = request.getParameter("data_nasc");
        String nome = request.getParameter("nome");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String p_confirmar = request.getParameter("confirmar_senha");
        String userNivel = request.getParameter("nivel");

        if (p_confirmar.equals(password)) {
            
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                if (usernameValido(username, conn)) {
                    String sql = "INSERT INTO utilizador (username, palavra_passe, nome, data_nasc, nivel) VALUES (?, MD5(?), ?, ?, ?)";
                    pstmt = conn.prepareStatement(sql);

                    //Para evitar desformatação de caracteres especiais para dentro da BD
                    username = new String(username.getBytes("ISO-8859-1"), "UTF-8");
                    password = new String(password.getBytes("ISO-8859-1"), "UTF-8");
                    nome = new String(nome.getBytes("ISO-8859-1"), "UTF-8");
                    userNivel = new String(userNivel.getBytes("ISO-8859-1"), "UTF-8");

                    pstmt.setString(1, username);
                    pstmt.setString(2, password);
                    pstmt.setString(3, nome);
                    pstmt.setString(4, data_nasc);
                    pstmt.setString(5, userNivel);
                    int rowsAffected = pstmt.executeUpdate();

                    if (rowsAffected == 1) {
                        userCreated = true;
                    } else {
                        errorOccurred = true;
                    }
                } else {
                    usernameExists = true;
                }
            } catch (Exception e) {
                e.printStackTrace();
                errorOccurred = true;
            }
        } else {
            passwordsMismatch = true;
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
                <a class="navbar-brand" href="pagina_inicial_adm.jsp">Formação Total</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <a class="nav-link" aria-current="page" href="logout.jsp">Terminar Sessão</a>
                        </li>
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
                        <h1>Novo Utilizador</h1>
                    </div>
                </div>

                <div style="min-height: 500px;display: flex;">
                    <div id="esquerda" style="width:50%; padding-top: 60px;padding-bottom: 60px;text-align: center;">
                        <img src="user.png" style="width: 200px; height:200px;margin-bottom: 24px;" alt="">
                    </div>

                    <div id="direita" style="width:50%; padding-top: 60px;padding-bottom: 60px; padding-left: 50px;text-align: left;">
                        <form method="post" action="adiciona_utilizador.jsp">
                            Nome: <input type="text" name="nome" style="margin-left: 140px;" required><br><br>
                            Nome de Utilizador: <input type="text" style="margin-left: 48px;" name="username" required><br><br>
                            Palavra-Passe: <input type="password" name="password" style="margin-left: 75px;" required minlength="8"><br><br>
                            Confirmar Palavra-Passe: <input type="password" name="confirmar_senha" style="margin-left: 5px;" required><br><br>
                            Data de Nascimento: <input type="date" name="data_nasc" style="margin-left: 35px;" required><br><br>
                            Nivel: <input type="text" name="nivel" style="margin-left: 149px;" required><br><br>
                            <br><br><br><br>
                            <div style="margin-left: 100px;"><button class="botao" name="submit" type="submit">Criar</button></div>
                        </form>
                        <% if (userCreated) { %>
                            <script>
                                if (confirm('Conta criada com sucesso!')) {
                                    window.location.href = 'adiciona_utilizador.jsp';
                                }
                            </script>
                        <% } else if (errorOccurred) { %>
                            <script>alert('Algo correu mal! :(');</script>
                        <% } else if (usernameExists) { %>
                            <script>alert('Esse nome de utilizador já existe! :(');</script>
                        <% } else if (passwordsMismatch) { %>
                            <script>alert('As palavras-passes não coincidem! :(');</script>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS e dependências -->
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
    </body>
</html>
