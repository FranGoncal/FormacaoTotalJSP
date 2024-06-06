<%@	include	file="../basedados/basedados.h"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%!
    String[] getInscricao(String username, String curso, Connection conn) throws SQLException {
        String sql = "SELECT * FROM inscricao WHERE nome = '"+curso+"' AND username = '"+username+"';";
        PreparedStatement ps = null;

        ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        String estado = null;
        String horario = null;
        String[] inscricao = new String[2];
        if(rs.next()){
            estado = rs.getString("estado");
            horario = rs.getString("horario");
            
            inscricao[0] = estado;
            inscricao[1] = horario; 
        }

        //retorna o estado e o horario
        return inscricao;
    }
%>

<%
    String nivel = (String) session.getAttribute("nivel");
    if (nivel == null || !(nivel.equals("docente") || nivel.equals("admin"))) {
        response.sendRedirect("logout.jsp");
        return;
    }
    String curso = request.getParameter("nome");
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
                            String username = (String) session.getAttribute("username");
                            if (username != null) {
                        %>
                            <li class="nav-item">
                                <a class="nav-link" aria-current="page" href="logout.jsp">Terminar Sessão</a>
                            </li>
                        <%
                            } else {
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
        <div class="contorno">
            <div class="caixa" style="max-width: 85%; min-width: 80%;">
                <div id="cabecalho" style="display: flex; justify-content: center; align-items: center;">
                    <div class="caixa" style="width: 100%; text-align: center; border: none; margin-top: 20px; margin-bottom: 20px;">
                        <h1>Gestão de Inscrições de <%= curso %></h1>
                    </div>
                </div>

                <div style="display: flex; justify-content: center">
                    <center>
                        <%
                            PreparedStatement ps = null;
                            try {
                                String sql = "SELECT * FROM utilizador WHERE nivel = 'aluno' ORDER BY nivel ASC";
                                ps = conn.prepareStatement(sql);
                                ResultSet rs = ps.executeQuery();
                        %>
                        <table border='1' style='text-align:center; width: 1200px;'>
                            <tr>
                                <th>Nome</th>
                                <th>Username</th>
                                <th>Data Nascimento</th>
                                <th>Horario</th>
                                <th>Inscrever</th>
                                <th>Validar</th>
                                <th>Eliminar</th>
                            </tr>
                            <%
                                while (rs.next()) {
                                    String[] inscricao = new String[2];
                                    inscricao = getInscricao(rs.getString("username"), curso, conn);
                                    String estadoInscricao =inscricao[0];
                                    String horario =inscricao[1];
                            %>
                            <tr>
                                <td style='width: 18%'><%= rs.getString("nome") %></td>
                                <td style='width: 18%'><%= rs.getString("username") %></td>
                                <td style='width: 18%'><%= rs.getDate("data_nasc") %></td>
                                
                                <%
                                    //coluna horario
                                    if (horario != null) {
                                %>
                                <td style='width: 18%'><%= horario %> <a style='margin: 5px' href='editar_inscricao.jsp?utilizador=<%= rs.getString("username") %>&acao=alterar_horario&curso=<%= curso %>&horario=<%= horario %>'><img src='alterar.png' alt='Alterar Horario' style='width:28px'></a></td>
                                <%
                                    }
                                    else{
                                %>
                                    <td style='width: 18%'></td>
                                <%
                                    }
                                %>


                                <%
                                    //coluna inscrever
                                    if (estadoInscricao == null) {
                                %>
                                <td style='width: 10%'><a href='inscrever_adm.jsp?utilizador=<%= rs.getString("username") %>&curso=<%= curso %>'><img src='formacao.png' alt='editar' style='width:28px'></a></td>
                                <%
                                    }
                                    else{
                                %>
                                    <td style='width: 10%'></td>
                                <%
                                    }
                                %>


                                <%
                                    //coluna validar
                                    if (estadoInscricao != null && estadoInscricao.equals("pendente")) {
                                %>
                                <td style='width: 13%'>
                                    <a style='margin: 5px' href='editar_inscricao.jsp?utilizador=<%= rs.getString("username") %>&acao=validar&curso=<%= curso %>'><img src='validar.png' alt='validar aluno' style='width:28px'></a>
                                </td>
                                <%
                                    }
                                    else{
                                %>
                                    <td style='width: 13%'></td>
                                <%
                                    }
                                %>


                                <%
                                    //coluna eliminar
                                    if (estadoInscricao != null) {
                                %>
                                <td style='width: 13%'>
                                    <a style='margin: 5px' href='editar_inscricao.jsp?utilizador=<%= rs.getString("username") %>&acao=eliminar&curso=<%= curso %>'><img src='eliminar.png' alt='validar aluno' style='width:28px'></a>
                                </td>
                                <%
                                    }
                                %>

                            </tr>
                        <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            } 
                        %>
                        </table>
                        <br/>
                    </center>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS e dependências -->
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
    </body>
</html>
