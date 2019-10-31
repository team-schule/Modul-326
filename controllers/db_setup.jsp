<%@ page import="java.sql.*" %>

<%
    if (application.getAttribute ("db") == null){
        
        try{
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, dbuser, pw); 
            application.setAttribute ("db", conn);
        }
        catch (Exception e){
            application.setAttribute ("db", null); 
        }
    }
    %>