<%@	include	file="../basedados/basedados.h"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    
    String nivel = (String) session.getAttribute("nivel");
    if (nivel == null || !nivel.equals("admin")) {
        response.sendRedirect("logout.jsp");
    }

    String utilizador = request.getParameter("utilizador");
    if (utilizador == null) {
        response.getWriter().println("Nenhum utilizador especificado!");
        return;
    }

    PreparedStatement ps = null;
    ResultSet rs = null;

    String nome = null;
    String data_nasc = null;
    String userNivel = null;

    try {
        String sql = "SELECT * FROM utilizador WHERE username = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, utilizador);
        rs = ps.executeQuery();

        if (rs.next()) {
            nome = rs.getString("nome");
            data_nasc = rs.getString("data_nasc");
            userNivel = rs.getString("nivel");
        } else {
            response.getWriter().println("Nenhum utilizador encontrado!");
            return;
        }

    } catch (Exception e) {
        e.printStackTrace();
    } 

    if (request.getParameter("submit") != null) {
        nome = request.getParameter("nome");
        data_nasc = request.getParameter("data_nasc");
        userNivel = request.getParameter("nivel");
        
        try {
            String sql = "UPDATE utilizador SET nome = ?, data_nasc = ?, nivel = ? WHERE username = ?";
            ps = conn.prepareStatement(sql);

            //Para evitar desformatação de caracteres especiais para dentro da BD
            nome = new String(nome.getBytes("ISO-8859-1"), "UTF-8");
            userNivel = new String(userNivel.getBytes("ISO-8859-1"), "UTF-8");
            //utilizador = new String(utilizador.getBytes("ISO-8859-1"), "UTF-8");
            
            ps.setString(1, nome);
            ps.setString(2, data_nasc);
            ps.setString(3, userNivel);
            ps.setString(4, utilizador);
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                out.println("<script>alert('Atualizado com sucesso!');</script>");
            } else {
                out.println("<script>alert('Atualizado sem sucesso :(!');</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
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

    <!-- Conteúdo da página -->
    <div class="contorno">
        <div class="caixa" style="min-width: 60%;">
            <div id="cabecalho" style="display: flex;justify-content: center;align-items: center;">
                <div class="caixa" style="width: 100%; text-align: center;border: none;margin-top:20px;margin-bottom:20px;">
                    <h1>Edição do Utilizador</h1>
                </div>
            </div>

            <div style="min-height: 500px;display: flex;">
                <div id="direita" style="width:100%; padding-top: 60px;padding-bottom: 60px; padding-left: 50px;text-align: left;margin-left: 33%;">
                    <form method="post" action="editar_utilizadores.jsp?utilizador=<%= utilizador %>">
                        Nome de Utilizador: <%= utilizador %><br><br>
                        Nome: <input type="text" style="margin-left: 95px;" name="nome" value="<%= nome %>"><br><br>
                        Data de Nascimento: <input type="date" name="data_nasc" value="<%= data_nasc %>"><br><br>
                        Nivel: <input type="text" style="margin-left: 110px;" name="nivel" value="<%= userNivel %>"><br><br>
                        <div style="margin-left: 130px;"><button class="botao" name="submit" type="submit">Atualizar</button></div>
                        <br>
                    </form>
                    <a href="mudar_pass.jsp?utilizador=<%= utilizador %>"><div style="margin-left: 85px;"><button class="botao" name="fechar">Alterar Palavra-passe</button></div></a>
                    <br>
                    <%
                        if (!"apagado".equals(userNivel)) {
                            out.print("<a href='validar.jsp?utilizador=" + utilizador + "&nivel=apagado'><div style='margin-left: 100px;'><button class='botao_vermelho' name='fechar'>Apagar Utilizador</button></div></a>");
                        }
                    %>
                </div>     
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS e dependências -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
</body>
</html>