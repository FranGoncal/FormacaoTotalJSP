

<%@ page import="java.sql.*" %>
<%@ page import="java.io.*, java.security.*" %>
<%@ page import="javax.servlet.*, javax.servlet.http.*" %>

<%@ page import="java.sql.*" %>
<%@ page import="java.io.*, java.security.*" %>
<%@ page import="javax.servlet.*, javax.servlet.http.*" %>

<%
    String username = request.getParameter("username");
    String password = request.getParameter("palavra_passe");
    
    if (request.getParameter("submit") != null) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            // Estabelecer conexão com o banco de dados
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost/seu_banco_de_dados", "seu_usuario", "sua_senha");

            String sql = "SELECT nivel FROM utilizador WHERE username = ? AND palavra_passe = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password); // Use Apache Commons Codec para fazer o hash MD5

            rs = stmt.executeQuery();

            if (rs.next()) {
                String nivel = rs.getString("nivel");

                // Configurar a sessão
                //HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("nivel", nivel);

                // Redirecionar com base no nível de acesso
                if ("aluno".equals(nivel)) {
                    response.sendRedirect("pagina_inicial.jsp");
                } else if ("admin".equals(nivel) || "docente".equals(nivel)) {
                    response.sendRedirect("pagina_inicial_adm.jsp");
                } else if ("pendente".equals(nivel)) {
                    out.println("<script>alert('A sua conta ainda não foi validada. Tente mais tarde!'); window.location.href = 'logout.jsp';</script>");
                } else if ("apagado".equals(nivel)) {
                    out.println("<script>alert('A sua conta foi apagada!'); window.location.href = 'logout.jsp';</script>");
                } else {
                    out.println("<script>alert('Este acesso não foi autorizado!'); window.location.href = 'logout.jsp';</script>");
                }
            } else {
                out.println("<script>alert('Credenciais incorretas! :(');</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Fechar conexões
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
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
