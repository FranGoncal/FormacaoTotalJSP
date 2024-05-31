<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../basedados/basedados.h" %>

<%!
    boolean nVagasValido(int vagas) {
        return vagas > 0;
    }

%>

<%

    if (!session.getAttribute("nivel").equals("docente") && !session.getAttribute("nivel").equals("admin")) {
        response.sendRedirect("logout.jsp");
        return;
    }

    if (request.getParameter("nome") != null) {
        session.setAttribute("nome", request.getParameter("nome"));
    }

    String nome = (String) session.getAttribute("nome");

    String vagas = "";
    boolean esta_fechada = false;
    String criterio = "";
    String data_fecho = "";
    String responsavel = "";
    String descricao = "";

    String sql = "SELECT * FROM formacao WHERE nome = ?";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, nome);
        ResultSet result = ps.executeQuery();

        if (result.next()) {
            vagas = result.getString("num_maximo");
            esta_fechada = result.getBoolean("esta_fechada");
            criterio = result.getString("criterio_selecao");
            data_fecho = result.getString("data_fecho");
            responsavel = result.getString("username");
            descricao = result.getString("descricao");
        } else {
            out.println("Nenhum utilizador encontrado!");
            return;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        vagas = request.getParameter("num_maximo");
        data_fecho = request.getParameter("data_fecho");
        criterio = request.getParameter("criterio_selecao");
        descricao = request.getParameter("descricao");

        //Para evitar desformatação de caracteres especiais para dentro da BD
        criterio = new String(criterio.getBytes("ISO-8859-1"), "UTF-8");
        descricao = new String(descricao.getBytes("ISO-8859-1"), "UTF-8");
        //nome = new String(nome.getBytes("ISO-8859-1"), "UTF-8");


        if (nVagasValido(Integer.parseInt(vagas))) {
            sql = "UPDATE formacao SET num_maximo = ?, descricao = ?, data_fecho = ?, criterio_selecao = ? WHERE nome = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, vagas);
                ps.setString(2, descricao);
                ps.setString(3, data_fecho);
                ps.setString(4, criterio);
                ps.setString(5, nome);
                int rowsUpdated = ps.executeUpdate();
                if (rowsUpdated > 0) {
                    out.println("<script>alert('Atualizado com sucesso!');</script>");
                } else {
                    out.println("<script>alert('Atualizado sem sucesso :(!');</script>");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            out.println("<script>alert('Número de vagas inválido!');</script>");
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
        <div class="caixa" style="min-width: 80%;">
            <div id="cabecalho" style="display: flex;justify-content: center;align-items: center;">
                <div class="caixa" style="width: 100%; text-align: center;border: none;margin-top:20px;margin-bottom:20px;">
                    <h1>Dados do Curso de Formação</h1>
                </div>
            </div>

            <div style="min-height: 500px;display: flex;">
                <%
                    String estadoFormacao = esta_fechada ? "Fechada" : "Aberta";

                    if (!esta_fechada) {
                %>
                    <div id="direita" style="width:100%; padding-top: 60px;padding-bottom: 60px; padding-left: 50px;text-align: left;margin-left: 33%;">
                        <form method="post" action="formacao.jsp">
                            Nome do Curso de Formação: <%= nome %><br><br>
                            Vagas: <input type="number" style="margin-left: 95px;" name="num_maximo" value="<%= vagas %>"><br><br>
                            Estado do Curso de Formação: <%= estadoFormacao %><br><br>
                            Data de Fecho: <input type="date" style="margin-left: 65px;" name="data_fecho" value="<%= data_fecho %>"><br><br>

                            Critério de Seleção:
                            <select id="opcoes" name="criterio_selecao" style="margin-left: 35px;">
                                <option value="Data Inscrição" <%= "Data Inscrição".equals(criterio) ? "selected" : "" %>>Data Inscrição</option>
                                <option value="Ordem Alfabética" <%= "Ordem Alfabética".equals(criterio) ? "selected" : "" %>>Ordem Alfabética</option>
                                <option value="Maior Idade" <%= "Maior Idade".equals(criterio) ? "selected" : "" %>>Maior Idade</option>
                                <option value="Menor Idade" <%= "Menor Idade".equals(criterio) ? "selected" : "" %>>Menor Idade</option>
                            </select><br><br>
                            Docente: <%= responsavel %>
                            <div style="width: 50%; margin-right: 10px; margin-top: 45px;">
                                <h5>Descrição:</h5>
                                <textarea id="texto" name="descricao" rows="7" cols="45"><%= descricao %></textarea>
                                <br><br>       
                            </div> 
                            <div style="display:flex; width:420px;justify-content: center;padding:15px;"><!---->
                                <div style="flex: 1;text-align: center;"><button class="botao" name="submit" type="submit">Atualizar</button></div><!-- style="margin-left: 130px;"-->
                            </div>
                        </form>
                        <%
                            out.print("<div style='display:flex; width:420px;justify-content: center;'> <!---->");

                            if (data_fecho.compareTo(new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())) < 0) {
                                out.print("<div style='flex: 1;text-align: center; padding:10px;'><a href='fechar_formacao.jsp?nome=" + nome + "&criterio=" + criterio + "&vagas=" + vagas + "'><button class='botao' name='fechar'>Fechar Curso</button></a></div>");//style='margin-left: 100px;'
                            } else {
                                out.print("<div style='flex: 1;text-align: center; padding:10px;'><button class='botao_off' type='submit' onclick=\"alert('A Data limite ainda não passou')\">Fechar Curso</button></div>");
                            }

                            
                            out.print("<br><div style='flex: 1;text-align: center; padding:10px;'><a href='apagar_formacao.jsp?nome=" + nome + "'><button class='botao_vermelho' name='apagar'>Apagar Curso</button></a></div>");
                            out.print("<br><div style='flex: 1;text-align: center; padding:10px;'><a href='gerir_inscricoes_adm.jsp?nome=" + nome + "'><button class='botao_laranja' name='gerir'>Gerir Inscrições</button></a></div>");

                            
                        %>
                        </div> <!---->
                    </div>
                <%
                    } else {
                %>
                    <div id="direita" style="width: 400px; max-width: 450px;padding-top: 60px;padding-bottom: 60px; padding-left: 60px;text-align: left;margin: 6%;">
                        <div>
                            Nome do Curso de Formação: <%= nome %><br><br>
                            Vagas: <%= vagas %><br><br>
                            Estado do Curso de Formação: <%= estadoFormacao %><br><br>
                            Data de Fecho: <%= data_fecho %><br><br>
                            Critério de Seleção: <%= criterio %><br><br>
                            Docente: <%= responsavel %><br><br>
                            <h5>Descrição:</h5>
                            <div style="border: 1px solid #07416b;"><%= descricao %></div>
                        </div>
                    </div>

                    <div style='padding: auto;'><table border='1' style='text-align:center; width: 450px; height: auto; margin: 6%; margin-top:17%'>
                        <tr>
                            <th>Username</th>
                            <th>Nome</th>
                            <th>Data Nascimento</th>
                        </tr>
                        <%
                            sql = "SELECT u.username, u.nome, u.data_nasc FROM utilizador u JOIN inscricao i ON u.username = i.username JOIN formacao f ON i.nome = f.nome WHERE f.nome = ? AND i.estado = 'aceite'";
                            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                                ps.setString(1, nome);
                                ResultSet rs = ps.executeQuery();
                                while (rs.next()) {
                                    out.print("<tr><td style='width: 33%'>" + rs.getString("username") + "</td><td style='width: 34%'>" + rs.getString("nome") + "</td><td style='width: 33%'>" + rs.getString("data_nasc") + "</td></tr>");
                                }
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        %>
                    </table><br/>
                    
                    
                    <a href="apagar_formacao.jsp?nome=<%= nome %>"><div style="margin-left: 150px;"><button class="botao_vermelho" name="apagar">Apagar Formação</button></div></a>
                    </div>
                    <br>
                    
                <%
                    }
                %>
            </div>     
        </div>
    </div>

    <!-- Bootstrap JS e dependências -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
</body>
</html>
