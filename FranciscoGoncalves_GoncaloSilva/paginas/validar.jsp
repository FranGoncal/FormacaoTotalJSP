<%@ include file="../basedados/basedados.h" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%

    String nivel = (String) session.getAttribute("nivel");
    out.println(nivel);
    if (nivel == null || !nivel.equals("admin")) {
        response.sendRedirect("logout.jsp");
        return;
    }

    String utilizador = request.getParameter("utilizador");
    String novoNivel = request.getParameter("nivel");

    PreparedStatement pstmt = null;

    try {
        String sql = "UPDATE utilizador SET nivel = ? WHERE username = ?";
        pstmt = conn.prepareStatement(sql);

        //Para evitar desformatação de caracteres especiais para dentro da BD
        novoNivel = new String(novoNivel.getBytes("ISO-8859-1"), "UTF-8");
        //utilizador = new String(utilizador.getBytes("ISO-8859-1"), "UTF-8");

        pstmt.setString(1, novoNivel);
        pstmt.setString(2, utilizador);
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            response.sendRedirect("gerir_utilizadores.jsp");
        } else {
            response.getWriter().println("Erro ao atualizar o nível do utilizador.");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        response.getWriter().println("Erro ao acessar o banco de dados.");
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException se) {
            se.printStackTrace();
        }
    }
%>
