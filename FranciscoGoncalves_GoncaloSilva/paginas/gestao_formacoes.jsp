<%@	include	file="../basedados/basedados.h"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%
    if(session == null || (!session.getAttribute("nivel").equals("admin") && !session.getAttribute("nivel").equals("docente"))){
        response.sendRedirect("logout.jsp");
        return;
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
                <a class="navbar-brand" href="pagina_inicial_adm.jsp">Formação Total</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <%
                            if(session.getAttribute("username") != null){
                                // Mostra a opcao de terminar sessao
                        %>
                                <li class="nav-item">
                                    <a class="nav-link" aria-current="page" href="logout.jsp">Terminar Sessão</a>
                                </li>
                        <%
                            } else {
                                // Mostra as opcoes da navbar iniciar sessao e criar conta
                        %>
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
        <div class="contorno" >
            <div class="caixa" style="max-width: 85%; min-width: 75%;">
                <div id="cabecalho" style="display: flex;justify-content: center;align-items: center;">
                    <div class="caixa" style="width: 100%; text-align: center;border: none;margin-top:20px;margin-bottom:20px;">
                        <h1>Cursos de Formação</h1>
                    </div>
                </div>
                <div style="display: flex; justify-content: center">
                    <div class="caixa" style="width: 100%; text-align: center;border: none;margin-top:20px;margin-bottom:20px;">
                        <a href="adiciona_formacao.jsp"><button class="botao">+ Adicionar</button></a>
                    </div>
                    <br><br><br>
                </div>
                <div style="display: flex; justify-content: center">
                    <center>
                        <%
                            Statement stmt = null;
                            ResultSet rs = null;

                            try {
                                stmt = conn.createStatement();
                                
                                String sql = "";
                                if(session.getAttribute("nivel").equals("docente")) {
                                    sql = "SELECT f.nome AS nome, f.data_fecho AS data_fecho, f.criterio_selecao AS criterio_selecao, f.esta_fechada AS esta_fechada, f.num_maximo AS numMax, COUNT(i.nome) AS numInscricoes " +
                                          "FROM utilizador u " +
                                          "JOIN formacao f ON u.username = f.username " +
                                          "LEFT JOIN inscricao i ON f.nome = i.nome " +
                                          "WHERE u.username = '" + nome + "' " +
                                          "GROUP BY f.nome, f.num_maximo;";
                                } else if(session.getAttribute("nivel").equals("admin")) {
                                    sql = "SELECT f.nome AS nome, f.data_fecho AS data_fecho, f.criterio_selecao AS criterio_selecao, f.esta_fechada AS esta_fechada, f.num_maximo AS numMax, COUNT(i.nome) AS numInscricoes " +
                                          "FROM utilizador u " +
                                          "JOIN formacao f ON u.username = f.username " +
                                          "LEFT JOIN inscricao i ON f.nome = i.nome " +
                                          "GROUP BY f.nome, f.num_maximo;";
                                }
                                
                                rs = stmt.executeQuery(sql);
                                out.println("<table border='1' style='text-align:center; width: 1000px;'><tr><th>Nome</th><th>Vagas</th><th>Inscrições</th><th>Data Fecho</th><th>Critério</th><th>Estado</th></tr>");

                                while(rs.next()) {
                                    String estado = rs.getBoolean("esta_fechada") ? "Fechada" : "Aberta";
                                    out.println("<tr onclick=\"window.location='formacao.jsp?nome=" + rs.getString("nome") + "';\" style='cursor:pointer;' class='tabela'>");
                                    out.println("<td style='width: 10%;'>" + rs.getString("nome") + "</td>");
                                    out.println("<td style='width: 15%'>" + rs.getInt("numMax") + "</td>");
                                    out.println("<td style='width: 20%'>" + rs.getInt("numInscricoes") + "</td>");
                                    out.println("<td style='width: 25%'>" + rs.getString("data_fecho") + "</td>");
                                    out.println("<td style='width: 20%'>" + rs.getString("criterio_selecao") + "</td>");
                                    out.println("<td style='width: 20%'>" + estado + "</td>");
                                    out.println("</tr>");
                                }

                                out.println("</table><br/>");
                            } catch (Exception e) {
                                out.println("Could not connect: " + e.getMessage());
                            } finally {
                                try {
                                    if(rs != null) rs.close();
                                    if(stmt != null) stmt.close();
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
