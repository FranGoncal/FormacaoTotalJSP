<%@	include	file="../basedados/basedados.h"%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.sql.*" %>

<%!
    String estadoInscricao(String nome, Connection conn, String username) throws SQLException {
        String estado = null;
        String sql = "SELECT estado FROM inscricao WHERE username = '"+username+"' AND nome = '"+nome+"'";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            estado = rs.getString("estado");
        }
        rs.close();
        pstmt.close();

        return estado;
    }
%>

<%
    String nivel = (String) session.getAttribute("nivel");
    if (nivel == null || !nivel.equals("aluno")) {
        response.sendRedirect("logout.jsp");
    }

    String nome = (String) session.getAttribute("username");
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
            <a class="navbar-brand" href="pagina_inicial.jsp">Formação Total</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <%
                        if (session.getAttribute("username") != null) {
                            //Mostra a opcao de terminar sessao
                            out.println("<li class='nav-item'><a class='nav-link' aria-current='page' href='logout.jsp'>Terminar Sessão</a></li>");
                        } else {
                            //Mostra as opcoes da navbar iniciar sessao e criar conta
                            out.println("<li class='nav-item'><a class='nav-link' aria-current='page' href='iniciar_sessao.jsp'>Iniciar Sessão</a></li>");
                            out.println("<li class='nav-item'><a class='nav-link' aria-current='page' href='criar_conta.jsp'>Criar Conta</a></li>");
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
        <div class="caixa" style="max-width: 85%; min-width: 75%;">
            <div id="cabecalho" style="display: flex; justify-content: center; align-items: center;">
                <div class="caixa" style="width: 100%; text-align: center; border: none; margin-top: 20px; margin-bottom: 20px;">
                    <h1>Gerir Inscrições de Cursos</h1>
                </div>
            </div>

            <form action="gerir_inscricoes.jsp" method="post">
                <div style="display: flex; justify-content: center">
                    <div style="margin-top: 4px; margin-right: 20px;">
                        <%
                            if (request.getParameter("option") == null) {
                                out.println("<input type='checkbox' name='option' >");
                            } else {
                                out.println("<input type='checkbox' name='option' checked >");
                            }
                        %>
                        As minhas Inscrições
                    </div>
                    <div style="background-color: #cccccc; border-radius: 20px; border: 1px solid #02365c; padding-left: 12px; padding-right: 10px;">
                        <input type="text" name="nome" placeholder="A sua pesquisa..." style="height: 30px; border: 0px; background-color: #dddddd; margin: 2px;">
                        <button class="botao_cinzento" name="submit" type="submit" style="height: 30px;">Pesquisar</button>
                    </div>
                </div>
            </form>
            <br>
            <div style="display: flex; justify-content: center">
                <center>
                    <%
                        Statement stmt = null;
                        try {

                            String sql = "";
                            String searchNome = request.getParameter("nome");
                            boolean optionChecked = request.getParameter("option") != null;
                            boolean searchSubmitted = request.getParameter("submit") != null;

                            if (!searchSubmitted) {
                                sql = "SELECT f.nome AS nome, f.data_fecho AS data_fecho, f.criterio_selecao AS criterio_selecao, f.esta_fechada AS esta_fechada, f.num_maximo AS numMax FROM formacao f LEFT JOIN inscricao i ON f.nome = i.nome AND i.estado='aceite'";
                            } else if (optionChecked) {
                                sql = "SELECT f.nome AS nome, f.data_fecho AS data_fecho, f.criterio_selecao AS criterio_selecao, f.esta_fechada AS esta_fechada, f.num_maximo AS numMax FROM formacao f LEFT JOIN inscricao i ON f.nome = i.nome WHERE f.nome LIKE '%" + searchNome + "%' AND i.username = '" + nome + "' AND i.estado='aceite'";
                            } else {
                                sql = "SELECT f.nome AS nome, f.data_fecho AS data_fecho, f.criterio_selecao AS criterio_selecao, f.esta_fechada AS esta_fechada, f.num_maximo AS numMax FROM formacao f LEFT JOIN inscricao i ON f.nome = i.nome WHERE f.nome LIKE '%" + searchNome + "%' GROUP BY f.nome, f.num_maximo";
                            }

                            stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery(sql);

                            out.println("<table border='1' style='text-align:center; width: 1100px;'><tr><th>Nome</th><th>Vagas</th><th>Data Fecho</th><th>Critério</th><th>Estado</th><th>Inscricao</th></tr>");
                            while (rs.next()) {
                                String estado;
                                String nomeFormacao = rs.getString("nome");

                                out.println("<tr onclick=\"window.location='dados_formacao.jsp?nome=" + nomeFormacao + "';\" style='cursor:pointer;' class='tabela'>");
                                out.println("<td style='width: 15%'>" + rs.getString("nome") + "</td>");
                                out.println("<td style='width: 15%'>" + rs.getInt("numMax") + "</td>");
                                out.println("<td style='width: 15%'>" + rs.getDate("data_fecho") + "</td>");
                                out.println("<td style='width: 20%'>" + rs.getString("criterio_selecao") + "</td>");

                                if (rs.getBoolean("esta_fechada"))
                                    estado = "Fechada";
                                else
                                    estado = "Aberta";
                                out.println("<td style='width: 20%'>" + estado + "</td>");

                                String inscricaoEstado = estadoInscricao(nomeFormacao, conn, nome);
                                if ("aceite".equals(inscricaoEstado)) {
                                    out.println("<td style='width: 20%'>Aceite</td>");
                                } else if ("pendente".equals(inscricaoEstado)) {
                                    out.println("<td style='width: 20%'>Pendente</td>");
                                } else {
                                    out.println("<td style='width: 20%'></td>");
                                }
                                out.println("</tr>");
                            }
                            out.println("</table><br/>");
                            rs.close();
                            stmt.close();
                            conn.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            try {
                                if (stmt != null) stmt.close();
                            } catch (SQLException se2) {
                            }
                            try {
                                if (conn != null) conn.close();
                            } catch (SQLException se) {
                                se.printStackTrace();
                            }
                        }

                        
                    %>
                </center>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS e dependências -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
</body>
</html>
