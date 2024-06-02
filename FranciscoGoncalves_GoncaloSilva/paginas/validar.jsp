<%@ include file="../basedados/basedados.h" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String nivel = (String) session.getAttribute("nivel");
    if (nivel == null || !nivel.equals("admin")) {
        response.sendRedirect("logout.jsp");
        return;
    }

    String utilizador = request.getParameter("utilizador");
    String novoNivel = request.getParameter("nivel");

    PreparedStatement ps = null;

    try {
        String sql = "UPDATE utilizador SET nivel = ? WHERE username = ?";
        ps = conn.prepareStatement(sql);

        ps.setString(1, novoNivel);
        ps.setString(2, utilizador);
        int rowsAffected = ps.executeUpdate();

        if (rowsAffected > 0) {
            response.sendRedirect("gerir_utilizadores.jsp");
        } else {
            out.println("<script>alert('Ocorreu um erro :(!');</script>");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
