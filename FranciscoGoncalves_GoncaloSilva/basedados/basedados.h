<%@ page  language="java" import="java.sql.*" %>
<%
	Connection conn = null;
	try{
		//Ligar á base de dados criar_bd
		Class.forName("com.mysql.cj.jdbc.Driver").newInstance(); 
		String jdbcURL="jdbc:mysql://localhost:3306/formacao_total";
		conn = DriverManager.getConnection(jdbcURL,"root", "");
	}catch(Exception e){
		//Caso não seja possivel
		out.println("Não foi possível conectar à base de dados! " + e.getMessage());  
	}
%>