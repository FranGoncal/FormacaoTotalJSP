<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../basedados/basedados.h" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<%
    if (!"admin".equals(session.getAttribute("nivel")) && !"docente".equals(session.getAttribute("nivel"))) {
        response.sendRedirect("logout.jsp");
        return;
    }

    String nome = request.getParameter("nome");

    Statement stmt = null;

    try {
        // Ligar à base de dados

        String sql = "DELETE FROM inscricao WHERE nome = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, nome);
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected == 1) {
            out.println("<script>");
            out.println("if(confirm('Apagado Inscricoes sem sucesso!')){");
            out.println("window.location.href = 'gestao_formacoes.jsp';");
            out.println("}");
            out.println("</script>");
        }

        sql = "DELETE FROM formacao WHERE nome = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, nome);
        rowsAffected = pstmt.executeUpdate();

        if (rowsAffected == 1) {
            out.println("<script>");
            out.println("if(confirm('Apagado com sucesso!')){");
            out.println("window.location.href = 'gestao_formacoes.jsp';");
            out.println("}");
            out.println("</script>");
        } else {
            out.println("<script>");
            out.println("if(confirm('Apagado sem sucesso! :(')){");
            out.println("window.location.href = 'gestao_formacoes.jsp';");
            out.println("}");
            out.println("</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
