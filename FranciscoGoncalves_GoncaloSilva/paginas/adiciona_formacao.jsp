<%@ include file="../basedados/basedados.h" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%!
    boolean formacaoValida(String nome, Connection conn) throws SQLException {
        String sql = "SELECT * FROM formacao WHERE nome = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, nome);
        ResultSet rs = pstmt.executeQuery();
        //retorna se a consulta !(encontrou formacao)
        return !rs.next();
    }
    boolean nVagasValido(int vagas) {
        return vagas > 0;
    }
%>

<%
    String nivel = (String) session.getAttribute("nivel");
    if (nivel == null || !(nivel.equals("docente") || nivel.equals("admin"))) {
        response.sendRedirect("logout.jsp");
    }

    String username = (String) session.getAttribute("username");

    if(request.getParameter("submit") != null) {
        String nome = request.getParameter("nome");
        int vagas = Integer.parseInt(request.getParameter("vagas"));
        String dataFecho = request.getParameter("data_fecho");
        String criterioSelecao = request.getParameter("criterio");
        String descricao = request.getParameter("descricao");

        if(formacaoValida(nome, conn) && nVagasValido(vagas)) {
            String sql = "INSERT INTO formacao (nome, num_maximo, esta_fechada, criterio_selecao, data_fecho, username, descricao) VALUES (?, ?, false, ?, ?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                
                //Para evitar desformatação de caracteres especiais para dentro da BD
                nome = new String(nome.getBytes("ISO-8859-1"), "UTF-8");
                criterioSelecao = new String(criterioSelecao.getBytes("ISO-8859-1"), "UTF-8");
                username = new String(username.getBytes("ISO-8859-1"), "UTF-8");
                descricao = new String(descricao.getBytes("ISO-8859-1"), "UTF-8");

                pstmt.setString(1, nome);
                pstmt.setInt(2, vagas);
                pstmt.setString(3, criterioSelecao);
                pstmt.setString(4, dataFecho);
                pstmt.setString(5, username);
                pstmt.setString(6, descricao);

                int affectedRows = pstmt.executeUpdate();

                if(affectedRows == 1) {
                    out.println("<script>");
                    out.println("if(confirm('Formação criada com sucesso!')) {");
                    out.println("window.location.href = 'gestao_formacoes.jsp';");
                    out.println("}");
                    out.println("</script>");
                } else {
                    out.println("<script>alert('Algo correu mal! :(');</script>");
                }
            } catch(SQLException e) {
                out.println("<script>alert('Erro: " + e.getMessage() + "');</script>");
            }
        } else if(!nVagasValido(vagas)) {
            out.println("<script>alert('Número de vagas inválido!');</script>");
        } else {
            out.println("<script>alert('Essa formação já existe! :(');</script>");
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
            <div class="caixa" style="min-width: 80%;">
                <div id="cabecalho" style="display: flex;justify-content: center;align-items: center;">
                    <div class="caixa" style="width: 100%; text-align: center;border: none;margin-top:20px;margin-bottom:20px;">
                        <h1>Novo Curso de Formação</h1>
                    </div>
                </div>
                <div style="min-height: 500px;display: flex;">
                    <div id="esquerda" style="width:50%; padding-top: 60px;padding-bottom: 60px;text-align: center;">
                        <img src="formacao.png" style="width: 200px; height:200px;margin-bottom: 24px;" alt="">
                    </div>
                    <div id="direita" style="width:50%; padding-top: 60px;padding-bottom: 60px; padding-left: 50px;text-align: left;">
                        <form method="post" action="adiciona_formacao.jsp">
                            Nome do Curso de Formação: <input type="text" name="nome" required><br><br>
                            Vagas: <input type="number" style="margin-left: 95px;" name="vagas" required><br><br>
                            Data de Fecho: <input type="date" name="data_fecho" style="margin-left: 35px;" required><br><br>
                            Critério Seleção:
                            <select id="opcoes" name="criterio" style="margin-left: 35px;" required>
                                <option value="Data Inscrição">Data Inscrição</option>
                                <option value="Ordem Alfabética">Ordem Alfabética</option>
                                <option value="Maior Idade">Maior Idade</option>
                                <option value="Menor Idade">Menor Idade</option>
                            </select>
                            <br><br> 
                            <h6>Descrição:</h6>    
                            <textarea id="texto" name="descricao" rows="7" cols="45">Escreva uma descrição do curso de formação...</textarea>
                            <br><br><br><br>   
                            <div style="margin-left: 100px;">
                                <button class="botao" name="submit" type="submit">Criar</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    
        <!-- Bootstrap JS e dependências -->
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
    </body>
</html>
