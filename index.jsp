<%--INDEX.JSP ist eigentlich der 1. Controller, der immer aus dem Web angesprochen wird
    Er realisiert den Life Cycle des MVC
--%>
<%@ page session="true" trimDirectiveWhitespaces="true" %>

<%@ include file="/controllers/db_setup.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    if (application.getAttribute ("db") != null)
    {
       
    }
    else 
    {
        response.sendRedirect("http://localhost:8080/dbTest/errorPage.jsp");    
    }
%>

<%@ include file="/controllers/header.jsp" %>

<%
    if (request.getParameter("logout") != null)
    {
        session.removeAttribute("Vorname");
    }
%>
<%
    if (session.getAttribute("Vorname") == null)
    {
        if (request.getParameter("register") != null)
        {
             %>
                 <%@include file="/controllers/registrieren.jsp" %>;
            <%
        }
        else if (request.getParameter("login") != null)
        {
            String user = request.getParameter("loginName"); 
            String password = request.getParameter("password"); 
            Class.forName("com.mysql.jdbc.Driver"); 
            Connection con =DriverManager.getConnection("jdbc:mysql://localhost:3306/fremdsprachen","root",""); 
            Statement s = con.createStatement(); 
            String sql = "SELECT * FROM benutzer" + 
                " WHERE Benutzername='" + user + "'" + 
                " AND Passwort='" + password + "'"; 
            ResultSet rs = s.executeQuery(sql);
            if (rs.next())
            {  
                session.setAttribute("Vorname", rs.getString("Vorname"));
                session.setAttribute("Nachname", rs.getString("Nachname"));
                session.setAttribute("Benutzername",rs.getString("Benutzername"));
                session.setAttribute("Letzte_Aktivitaet", rs.getString("Letzte_Aktivitaet"));
                session.setAttribute("Id", rs.getInt("Benutzer_ID"));
                session.setAttribute("kartenNummer",0);
                rs.close();
                %>
                    <%@ include file="/controllers/startseite.jsp" %>
                <%
            } 
            else
            { 
                request.setAttribute("error", "Login Fehlgeschlagen");       
                    %>
                        <%@include file="/controllers/login.jsp" %>;
                    <%
            }
        }
        else 
        {
            %>
                <%@include file="/controllers/login.jsp" %>;
            <%
        }
    }
    else
    {
        if (request.getParameter("profilbearbeiten") != null)
        {
            %>
                 <%@include file="/controllers/editprofile.jsp" %>;
            <%
        }
        else if (request.getParameter("aendern") != null)
        {

            String anrede = request.getParameter("anrede");
            String vorname = request.getParameter("vorname");
            String nachname = request.getParameter("nachname");
            String email = request.getParameter("email");
            String passwort = request.getParameter("password");
            String sql2 = "UPDATE benutzer " +
                            "SET Anrede = '"+ anrede + "' " +
                            ", Vorname = '"+ vorname + "' " +
                            ", Nachname = '"+ nachname + "' " +
                            ", Email = '"+ email + "' " +
                            ", Passwort = '"+ passwort+ "' " +
                            " WHERE Benutzer_ID = '" + session.getAttribute("Id") + "' ";
            Class.forName("com.mysql.jdbc.Driver"); 
            Connection con2 =DriverManager.getConnection("jdbc:mysql://localhost:3306/fremdsprachen","root",""); 
            Statement s2 = con2.createStatement(); 
            s2.executeUpdate(sql2);
            request.setAttribute("edit","Erfolgreich");
            %>
            <%@include file="/controllers/editprofile.jsp" %>;
            <%
        }
        else if (request.getParameter("next") != null)
        {
            request.setAttribute("next","next");
             %>
                 <%@include file="/controllers/startseite.jsp" %>;
            <%

        }
        else
        {
            %>
                 <%@include file="/controllers/startseite.jsp" %>;
            <%
        }
       
    }
%>


    


<%@include file="/controllers/footer.jsp" %>
<%--
<%@ include file="/controllers/router.jsp" %>

<%@ include file="/controllers/getView" %>
--%>
