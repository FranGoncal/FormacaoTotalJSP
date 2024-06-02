<%@ include file="../basedados/basedados.h" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.sql.*" %>

<%
    String nivel = (String) session.getAttribute("nivel");
    if (nivel == null || !nivel.equals("aluno")) {
        response.sendRedirect("logout.jsp");
        return;
    }

    if (request.getParameter("nome") != null) {
        session.setAttribute("nome", request.getParameter("nome"));
    }

    String nome = (String) session.getAttribute("nome");

    PreparedStatement ps = null;
    ResultSet rs = null;

    String vagas = "";
    String esta_fechada = "";
    String criterio = "";
    String data_fecho = "";
    String responsavel = "";
    String descricao = "";

    try {
        String sql = "SELECT * FROM formacao WHERE nome = '" + nome + "'";
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();

        if (rs.next()) {
            vagas = rs.getString("num_maximo");
            esta_fechada = rs.getString("esta_fechada");
            criterio = rs.getString("criterio_selecao");
            data_fecho = rs.getString("data_fecho");
            responsavel = rs.getString("username");
            descricao = rs.getString("descricao");
        } else {
            out.println("Nenhuma formação encontrada!");
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
                if ("aluno".equals(nivel))
                    out.print("<a class='navbar-brand' href='pagina_inicial.jsp'>Formação Total</a>");
                else
                    out.print("<a class='navbar-brand' href='pagina_inicial_adm.jsp'>Formação Total</a>");
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
        <div class="caixa" style="min-width: 60%;">
            <div id="cabecalho" style="display: flex;justify-content: center;align-items: center;">
                <div class="caixa" style="width: 100%; text-align: center;border: none;margin-top:20px;margin-bottom:20px;">
                    <h1>Dados do Curso de Formação</h1>
                </div>
            </div>

            <div style="min-height: 500px;display: flex;">
                <%
                    String estadoFormacao = "Aberta";
                    if ("1".equals(esta_fechada)) {
                        estadoFormacao = "Fechada";
                    }

                    out.print("<div id='direita' style='width:50%; padding-top: 60px;padding-bottom: 60px; padding-left: 50px;text-align: left;margin-left: 8%;'>");
                    out.print("Nome da Formação: " + nome + "<br><br>");
                    out.print("Vagas: " + vagas + "<br><br>");
                    out.print("Data Fecho: " + data_fecho + "<br><br>");
                    out.print("Critério Seleção: " + criterio + "<br><br>");
                    out.print("Docente: " + responsavel + "<br><br>");

                    String inscricaoSql = "SELECT * FROM inscricao WHERE username = '" + session.getAttribute("username") + "' AND nome = '" + nome + "'";
                    ResultSet inscricaoRs = null;
                    try {
                        
                        ps = conn.prepareStatement(inscricaoSql);
                        
                        inscricaoRs = ps.executeQuery(inscricaoSql);

                        boolean temInscricao = inscricaoRs.next();  

                        //se não tem inscricao e a mesma esta fechada
                        if ( !temInscricao && "1".equals(esta_fechada)) {
                            out.print("<div style='margin-left: 100px;'><button class='botao_cinzento'>Fechada</button></div>");
                        }   //se não tem inscricao mas esta aberta 
                        else if (!temInscricao) {
                            out.println("Fazer Inscrição em horário:");
                            out.print("<div style='margin-left: 10px;'><a href='inscricao.jsp?nome=" + nome + "&valor=inscrever&horario=Diurno'><button class='botao' name='fechar'>Diurno</button></a>");
                            out.print("<a href='inscricao.jsp?nome=" + nome + "&valor=inscrever&horario=Noturno'><button class='botao' name='fechar' style='margin-left:20px'>Noturno</button></a></div>");
                       
                        }   //se esta fechada e ele foi aceite
                        else if ("1".equals(esta_fechada) && "aceite".equals(inscricaoRs.getString("estado"))) {
                            out.print("<div style='margin-left: 100px;'><button class='botao_verde'>Aceite</button></div>");
                        }   //se tem inscricao mas não esta fechada 
                        else {
                            String horario = inscricaoRs.getString("horario");
                            out.println("Inscrição no horário : "+horario);
                            out.print("<div style='margin-left: 10px;'><a href='inscricao.jsp?nome=" + nome + "&valor=desinscrever'><button class='botao_vermelho' name='fechar'>Desinscrever</button></a>");
                            if(horario.equals("Diurno")){
                                out.print("<a href='inscricao.jsp?nome=" + nome + "&valor=editar&horario=Noturno'><button class='botao_laranja' name='fechar' style='margin-left:20px'>Alterar Horario</button></a></div>");
                            }
                            else{
                                out.print("<a href='inscricao.jsp?nome=" + nome + "&valor=editar&horario=Diurno'><button class='botao_laranja' name='fechar' style='margin-left:20px'>Alterar Horario</button></a></div>");
                            }

                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                %>
                </div>
                <div style="width: 50%; margin-right: 10px; margin-top: 45px;">
                    <h5>Descrição:</h5>
                    <div style="border: 1px solid #07416b; margin: 15px;">
                        <%= descricao %>   
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
