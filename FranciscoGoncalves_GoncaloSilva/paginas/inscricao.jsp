<%@	include	file="../basedados/basedados.h"%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.sql.*" %>

<%
    
    String nivel = (String) session.getAttribute("nivel");
    if (nivel == null || !nivel.equals("aluno")) {
        response.sendRedirect("logout.jsp");
        return;
    }

    String valor = request.getParameter("valor");
    String nome = request.getParameter("nome");
    String horario = request.getParameter("horario");
    

    String sql = "";
    if ("inscrever".equals(valor)) {
        sql = "INSERT INTO inscricao (username, estado, nome, data_inscricao, horario) VALUES('" + session.getAttribute("username") + "', 'pendente', '" + nome + "', CURDATE(), '" + horario + "')";
    } 
    else if ("desinscrever".equals(valor)) {
        sql = "DELETE FROM inscricao WHERE username = '" + session.getAttribute("username") + "' AND nome = '" + nome + "'";
    } 
    else if ("editar".equals(valor)) {
        
        sql = "UPDATE inscricao SET horario = '" + horario + "' WHERE nome = '" + nome + "' AND username = '"+session.getAttribute("username")+"';";
        
    }
    else {
        response.sendRedirect("int_erro.html");
        return;
    }

    Statement stmt = null;
    
    try {
        out.print(sql);
        stmt = conn.createStatement();
        int retval = stmt.executeUpdate(sql);
        
        if (retval == 1) {
            out.print("<script>");
            out.print("if(confirm('Inscrito com sucesso!')){");
            out.print("window.location.href = 'gestao_formacoes.jsp';");
            out.print("}");
            out.print("</script>");
        }

        response.sendRedirect("dados_formacao.jsp?nome=" + nome);
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException se) {
            se.printStackTrace();
        }
    }
%>
