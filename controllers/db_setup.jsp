<%@ page import="java.sql.*" %>

<%
    if (application.getAttribute ("db") == null){
        
        try{
            Class.forName("com.mysql.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/fremdsprachen";
            String user = "root";
            String pw = "";
            Connection conn = DriverManager.getConnection(url, user, pw); 
            application.setAttribute ("db", conn);
        }
        catch (Exception e){
            application.setAttribute ("db", null);
            

        }
    }
    %>