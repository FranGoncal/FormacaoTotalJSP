<%@	include	file="../basedados/basedados.h"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

    //caso de inscrever
    if ("inscrever".equals(valor)) {
        sql = "INSERT INTO inscricao (username, estado, nome, data_inscricao, horario) VALUES('" + session.getAttribute("username") + "', 'pendente', '" + nome + "', CURDATE(), '" + horario + "')";
    } 
    //caso de desinscrever
    else if ("desinscrever".equals(valor)) {
        sql = "DELETE FROM inscricao WHERE username = '" + session.getAttribute("username") + "' AND nome = '" + nome + "'";
    } 
    //caso de alterar o horario
    else if ("editar".equals(valor)) {
        sql = "UPDATE inscricao SET horario = '" + horario + "' WHERE nome = '" + nome + "' AND username = '"+session.getAttribute("username")+"';";  
    }
    else {
        out.print("<script>");
        out.print("if(confirm('Algo correu mal!')){");
        out.print("window.location.href = 'dados_formacao.jsp?nome="+nome+"'");
        out.print("}");
        out.print("</script>");
    }

    PreparedStatement ps = null;
    
    try {
        out.print(sql);
        ps = conn.prepareStatement(sql);
        int retval = ps.executeUpdate(sql);
  
        //caso de inscrever
        if (retval == 1 && valor.equals("inscrever")) {
            out.print("<script>");
            out.print("if(confirm('Inscrito com sucesso!')){");
            out.print("window.location.href = 'dados_formacao.jsp?nome="+nome+"'");
            out.print("}");
            out.print("</script>");
        }
        //caso de desinscrever
        else if(retval == 1 && valor.equals("desinscrever")){
            out.print("<script>");
            out.print("if(confirm('Desinscrito com sucesso!')){");
            out.print("window.location.href = 'dados_formacao.jsp?nome="+nome+"'");
            out.print("}");
            out.print("</script>");
        }   
        //caso de alterar o horario
        else if(retval == 1 && valor.equals("editar")){
            out.print("<script>");
            out.print("if(confirm('Editado com sucesso!')){");
            out.print("window.location.href = 'dados_formacao.jsp?nome="+nome+"'");
            out.print("}");
            out.print("</script>");
        }
        else{
            out.print("<script>");
            out.print("if(confirm('Algo correu mal!')){");
            out.print("window.location.href = 'dados_formacao.jsp?nome="+nome+"'");
            out.print("}");
            out.print("</script>");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
    } 
%>
