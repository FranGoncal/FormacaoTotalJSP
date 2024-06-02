<%@	include	file="../basedados/basedados.h"%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    
    String nivel = (String) session.getAttribute("nivel");
    if (!(nivel.equals("docente") || nivel.equals("admin"))) {
        response.sendRedirect("logout.jsp");
        return;
    }
    
    String acao = request.getParameter("acao");
    String username = request.getParameter("utilizador");
    String nome = request.getParameter("curso");
    String horario = request.getParameter("horario");
    

    String sql = "";
    if (acao.equals("inscrever")) {
        sql = "INSERT INTO inscricao (username, estado, nome, data_inscricao, horario) VALUES('" + username + "', 'pendente', '" + nome + "', CURDATE(), '" + horario + "')";
    } 
    else if ("eliminar".equals(acao)) {
        sql = "DELETE FROM inscricao WHERE username = '" + username + "' AND nome = '" + nome + "'";
    } 
    else if ("validar".equals(acao)) {
        sql = "UPDATE inscricao SET estado = 'aceite' WHERE nome = '" + nome + "' AND username = '"+ username +"';";
    }
    else if ("alterar_horario".equals(acao) && horario.equals("Noturno")) {
        sql = "UPDATE inscricao SET horario = 'Diurno' WHERE nome = '" + nome + "' AND username = '"+ username +"';";
    }
    else if ("alterar_horario".equals(acao) && horario.equals("Diurno")) {
        sql = "UPDATE inscricao SET horario = 'Noturno' WHERE nome = '" + nome + "' AND username = '"+ username +"';";
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
        
        if (retval == 1 && acao.equals("inscrever")) {
            out.print("<script>");
            out.print("if(confirm('Inscrito com sucesso!')){");
            out.print("window.location.href = 'gerir_inscricoes_adm.jsp?nome=" + nome + "';");
            out.print("}");
            out.print("</script>");
        }
        else if(retval == 1 && "eliminar".equals(acao)){
            out.print("<script>");
            out.print("if(confirm('Inscrição eliminada com sucesso!')){");
            out.print("window.location.href = 'gerir_inscricoes_adm.jsp?nome=" + nome + "';");
            out.print("}");
            out.print("</script>");
        }
        else if(retval == 1 && "validar".equals(acao)){
            out.print("<script>");
            out.print("if(confirm('Inscrição validada!')){");
            out.print("window.location.href = 'gerir_inscricoes_adm.jsp?nome=" + nome + "';");
            out.print("}");
            out.print("</script>");
        }
        else if(retval == 1 && "alterar_horario".equals(acao)){
            out.print("<script>");
            out.print("if(confirm('Horario alterado!')){");
            out.print("window.location.href = 'gerir_inscricoes_adm.jsp?nome=" + nome + "';");
            out.print("}");
            out.print("</script>");
        }

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
