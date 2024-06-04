<%@ include file="../basedados/basedados.h" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String nivel = (String) session.getAttribute("nivel");
    if (nivel == null || !(nivel.equals("docente") || nivel.equals("admin"))) {
        response.sendRedirect("logout.jsp");
    }

    String nome = request.getParameter("nome");

    try {   
        String sql = "DELETE FROM inscricao WHERE nome = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, nome);
        int rowsAffected = ps.executeUpdate();

        if (rowsAffected == 1) {
            out.println("<script>");
            out.println("if(confirm('Apagado Inscricoes sem sucesso!')){");
            out.println("window.location.href = 'gestao_formacoes.jsp';");
            out.println("}");
            out.println("</script>");
        }

        sql = "DELETE FROM formacao WHERE nome = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, nome);
        rowsAffected = ps.executeUpdate();

        if (rowsAffected == 1) {
            out.println("<script>");
            out.println("if(confirm('Apagado com sucesso!')){");
            out.println("window.location.href = 'gestao_formacoes.jsp';");
            out.println("}");
            out.println("</script>");
        } 
        else {
            out.println("<script>");
            out.println("if(confirm('Apagado sem sucesso! :(')){");
            out.println("window.location.href = 'gestao_formacoes.jsp';");
            out.println("}");
            out.println("</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
