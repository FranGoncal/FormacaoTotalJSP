<%@	include	file="../basedados/basedados.h"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fechar Formação</title>
</head>
<body>
<%
    if (!"docente".equals(session.getAttribute("nivel")) && !"admin".equals(session.getAttribute("nivel"))) {
        response.sendRedirect("logout.jsp");
        return;
    }

    String vagas = request.getParameter("vagas");
    String nome = request.getParameter("nome");
    String criterio = request.getParameter("criterio");

    Statement stmt = null;

    try {
        
        String sql = "UPDATE formacao SET esta_fechada = TRUE WHERE nome = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, nome);
        pstmt.executeUpdate();

        switch (criterio) {
            case "Data Inscrição":
                sql = "UPDATE inscricao SET estado = 'aceite' WHERE nome = ? AND username IN (SELECT username FROM (SELECT username FROM inscricao WHERE nome = ? ORDER BY data_inscricao LIMIT ?) AS subquery);";
                break;
            case "Ordem Alfabética":
                sql = "UPDATE inscricao SET estado = 'aceite' WHERE nome = ? AND username IN (SELECT username FROM (SELECT username FROM inscricao WHERE nome = ? ORDER BY (SELECT nome FROM utilizador WHERE utilizador.username = inscricao.username) ASC LIMIT ?) AS subquery);";
                break;
            case "Maior Idade":
                sql = "UPDATE inscricao SET estado = 'aceite' WHERE nome = ? AND username IN (SELECT username FROM (SELECT username FROM inscricao WHERE nome = ? ORDER BY (SELECT data_nasc FROM utilizador WHERE utilizador.username = inscricao.username) ASC LIMIT ?) AS subquery);";
                break;
            case "Menor Idade":
                sql = "UPDATE inscricao SET estado = 'aceite' WHERE nome = ? AND username IN (SELECT username FROM (SELECT username FROM inscricao WHERE nome = ? ORDER BY (SELECT data_nasc FROM utilizador WHERE utilizador.username = inscricao.username) DESC LIMIT ?) AS subquery);";
                break;
            default:
                out.println("<script>alert('O critério "+criterio+" não é válido :(!');</script>");
                return;
        }

        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, nome);
        pstmt.setString(2, nome);
        pstmt.setInt(3, Integer.parseInt(vagas));
        pstmt.executeUpdate();

        out.println("<script>alert('Formação fechada com sucesso! :)');</script>");
    } catch (Exception e) {
        out.println("<script>alert('Ocorreu um erro :(!');</script>");
        e.printStackTrace();
    } finally {
        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
    response.sendRedirect("formacao.jsp");
%>
</body>
</html>
