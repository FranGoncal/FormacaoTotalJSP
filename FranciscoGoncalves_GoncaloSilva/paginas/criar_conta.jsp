<%@	include	file="../basedados/basedados.h"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %><!-- verificar se necessario-->


<%!
    // valida se o username já está em uso
    boolean usernameValido(String username, Connection conn) throws SQLException {
        String sql = "SELECT * FROM utilizador WHERE username = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, username);
        ResultSet rs = pstmt.executeQuery();
        
        if(rs.next())
            return false;
        
        rs.close();
        pstmt.close();
        return true;
    }

%>

<%
    String data_nasc = request.getParameter("data_nasc") != null ? request.getParameter("data_nasc") : "";
    String nome = request.getParameter("nome") != null ? request.getParameter("nome") : "";
    String username = request.getParameter("username") != null ? request.getParameter("username") : "";
    String password = request.getParameter("palavra_passe") != null ? request.getParameter("palavra_passe") : "";
    String p_confirmar = request.getParameter("confirmar_senha") != null ? request.getParameter("confirmar_senha") : "";
  
    if(request.getParameter("submit") != null) {
        if(p_confirmar.equals(password)){
            
            if(usernameValido(username,conn)){
                String sql = "INSERT INTO utilizador (username, palavra_passe, nome, data_nasc, nivel) VALUES (?,md5(?),?,?,?)";
                PreparedStatement pstmt = conn.prepareStatement(sql);

                //Para evitar desformatação de caracteres especiais para dentro da BD
                username = new String(username.getBytes("ISO-8859-1"), "UTF-8");
                password = new String(password.getBytes("ISO-8859-1"), "UTF-8");
                nome = new String(nome.getBytes("ISO-8859-1"), "UTF-8");

                pstmt.setString(1, username);
                pstmt.setString(2, password);
                pstmt.setString(3, nome);
                pstmt.setString(4, data_nasc);
                pstmt.setString(5, "pendente");
                
                int rowsInserted = pstmt.executeUpdate();
                pstmt.close();
                conn.close();
                
                if(rowsInserted == 1){//INSERT com sucesso
                    out.println("<script>");
                    out.println("if(confirm('Conta criada com sucesso!')){");
                    out.println("window.location.href = 'iniciar_sessao.jsp';");
                    out.println("}");
                    out.println("</script>");
                    return;
                }
                else{//INSERT falhou
                    out.println("<script>alert('Algo correu mal! :(');</script>");
                }
            }
            else{
                out.println("<script>alert('Esse nome de utilizador já foi usado! :(');</script>");
            }
        }
        else{
            out.println("<script>alert('As palavras-passes não coincidem! :(');</script>");
        }
    }

    
%>

<!DOCTYPE html>
<html lang="pt-br">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Formação Total - Criar Conta</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Estilos personalizados -->
        <link rel="stylesheet" href="folha_css.css">
    </head>
    <body style="padding-top: 0px;">
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
                        <a class="nav-link" aria-current="page" href="iniciar_sessao.jsp">Iniciar Sessão</a>
                        </li>
                        <li class="nav-item">
                        <a class="nav-link" aria-current="page" href="#">Criar Conta</a>
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
                    <h3 class="text-center">Criar Conta</h3>
                    </div>
                    <div class="card-body">
                        <form action="criar_conta.jsp" method="post">
                            <div class="mb-3">
                                <label for="nome" class="form-label">Nome</label>
                                <input required name="nome" type="text" class="form-control" id="nome">
                            </div>
                            <div class="mb-3">
                                <label for="email" class="form-label">Nome de Utilizador</label>
                                <input required type="text"  class="form-control" id="username" name="username" aria-describedby="emailHelp">
                            </div>
                            <div class="mb-3">
                                <label for="senha" class="form-label">Palavra-Passe</label>
                                <input required type="password" class="form-control" id="palavra_passe" name="palavra_passe" minlength="8">
                            </div>
                            <div class="mb-3">
                                <label for="confirmar_senha" class="form-label">Confirmar Palavra-Passe</label>
                                <input required type="password" class="form-control" id="confirmar_senha" name="confirmar_senha" minlength="8">
                            </div>
                            <div class="mb-3">
                                <label for="data" class="form-label">Data de Nascimento</label>
                                <input required type="date" value="2000-01-01" class="form-control" name="data_nasc">
                            </div>
                            <button type="submit" name="submit" class="btn btn-primary btn-block">Criar Conta</button>
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