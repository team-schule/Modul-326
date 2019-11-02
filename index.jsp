<!--Imports -->
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page session="true" trimDirectiveWhitespaces="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Strings für dei Verbindung werden erstellt
    // URL String zur DB
    String url = "jdbc:mysql://localhost:3306/fremdsprachen";
    // DB Benutzer
    String dbuser = "root";
    // DB Passwort
    String pw = "";
    Connection conn = null;
    Statement st = null;
    ResultSet rs = null;
    String dbStatus = null;
    String status = null;
%>

<%@ include file="/controllers/db_setup.jsp" %>

<%
// DB Status wird beim ersten Aufruf abgefragt ist der Status = Null wird zur Error Page weitergeleitet
    if (application.getAttribute ("db") == null)
    {
        response.sendRedirect("http://localhost:8080/fremdsprachen/errorPage.jsp");    
    }
%>
<!-- War die DB Connection erfolgreich wird der Header geladen -->
<%@ include file="/controllers/header.jsp" %>

<%
    // Wurde der Button Logout gedrückt wird der Vorname aus der Session gelöscht
    if (request.getParameter("logout") != null)
    {
        session.removeAttribute("Vorname");
    }
%>
<%
    // Ist der Vorname in der Session Null kommen diese Abfragen zum Zug
    if (session.getAttribute("Vorname") == null)
    {
        // Wurde der Registrieren Button gedrückt wird die regsitrier seite geladen
        if (request.getParameter("register") != null)
        {
             %>
                 <%@include file="/controllers/registrieren.jsp" %>
            <%
        }
        // Wurde die Registrierung ausgefüllt und auf Regsitrieren gedrückt wird dieser Block ausgeführt
        else if (request.getParameter("registrieren") != null)
        {
            String anrede = request.getParameter("anrede");
            String vorName = request.getParameter("vorName");
            String nachName = request.getParameter("nachName");
            String loginName = request.getParameter("loginName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            // Eingegebenes Passwort wird in ein SHA256 umgewandelt
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashInBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashInBytes) {
            sb.append(String.format("%02x", b));
            password = sb.toString();
        }
            // Try and Catch Block um die Verbindung der DB zu überprüfen
            try 
            {
                conn = DriverManager.getConnection(url, dbuser, pw); 
                st = conn.createStatement(); 
                String sql = "SELECT * FROM benutzer" + 
                " WHERE Benutzername='" + loginName + "'";
                rs = st.executeQuery(sql);
                
                if (rs.next())
                {
                    request.setAttribute("loginName","loginName");
                    rs.close();
                    %>
                        <%@include file="/controllers/registrieren.jsp" %>
                    <%
                }
                else
                {
                    conn = DriverManager.getConnection(url, dbuser, pw); 
                    st = conn.createStatement(); 
                    String sql2 ="INSERT INTO benutzer(Anrede, Vorname, Nachname, Email, Benutzername, Passwort) VALUES ('"+anrede+ "','"+vorName+ "','"+nachName+ "','"+ email + "','"+ loginName + "','"+ password + "')";
                    // Try an Catch Block um die Antwort der DB zu überprüfen
                    try
                    {
                        st.executeUpdate(sql2);
                    }
                    catch (Exception e)
                    {
                        status = "error";
                        session.setAttribute("error",e.getMessage());
                    }
                    // Wurde von der DB ein Fehler geworfen wird dieser abgefangen und die Message an die FehlerPage weitergeleitet
                    if (status != null)
                    {
                        // Es wird zur FehlerPage weitergeleitet
                        response.sendRedirect("http://localhost:8080/fremdsprachen/fehlerpage.jsp");  
                    }
                    // Ist die Registrierung erfolgreich wird die LoginSeite mit der Nachricht geladen
                    request.setAttribute("registriert","registriert");
                     %>
                        <%@include file="/controllers/login.jsp" %>
                    <% 
                } 
            }
            catch (Exception e)
            {
                dbStatus = "error";
            }
            finally
            {
                conn.close();
            } 
            // Ist die Verbindung zur DB unterbrochen wird zur ErrorPage weitergeleitet
            if (dbStatus != null)
            {
                response.sendRedirect("http://localhost:8080/fremdsprachen/errorPage.jsp");
            }
           
        }
        // Wurde der Login Button gedrückt kommt dieser Block zum Zuge
        else if (request.getParameter("login") != null)
        {
            String user = request.getParameter("loginName"); 
            String password = request.getParameter("password");
            // Login String wird in SHA256 umgewandelt 
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashInBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashInBytes) {
            sb.append(String.format("%02x", b));
            }
            password = sb.toString();
            // Try and Catch Block um die DB Verbindung Sicherzustellen
            try 
            {
                conn = DriverManager.getConnection(url, dbuser, pw);
                st = conn.createStatement(); 
                String sql = "SELECT * FROM benutzer" + 
                    " WHERE Benutzername='" + user + "'" + 
                    " AND Passwort='" + password + "'"; 
                rs = st.executeQuery(sql);
                // Hat sich der Benutzer Erfolgreich registriert werden die benötigten Daten in die Session gespeichert und die Startseite geladen
                if (rs.next())
                {  
                    session.setAttribute("Vorname", rs.getString("Vorname"));
                    session.setAttribute("Nachname", rs.getString("Nachname"));
                    session.setAttribute("Benutzername",rs.getString("Benutzername"));
                    session.setAttribute("Letzte_Aktivitaet", rs.getString("Letzte_Aenderung"));
                    session.setAttribute("Id", rs.getInt("Benutzer_ID"));
                    session.setAttribute("kartenNummer",0);
                    rs.close();
                     %>
                        <%@ include file="/controllers/startseite.jsp" %>
                    <%
                }   
                else
                { 
                    // Ist der Login fehlerhaft wird erneut die Loginseite mit Fehlermeldung aufgerufen
                    request.setAttribute("error", "Login Fehlgeschlagen");       
                    %>
                        <%@include file="/controllers/login.jsp" %>
                    <%
                }
            }
            catch (Exception e)
            {
                dbStatus = "error";
            }
            finally
            {
                conn.close();
            }
            // Ist bei der Abfrage des Logins die DB nicht erreichbar wird zur errorPage weitergeleitet
            if (dbStatus != null)
            {
                response.sendRedirect("http://localhost:8080/fremdsprachen/errorPage.jsp");
            }   
        }
        // Wenn nichts gedrückt wurde und die Session leer ist kommt der Else Bock zum Zug und lädt die Login Seite
        else 
        {
            %>
                <%@include file="/controllers/login.jsp" %>
            <%
        }
    }
    else
    {
        // Wurde der Profil bearbeiten in der Startseite gedrückt wird die editprofile Seite hier geladen
        if (request.getParameter("profilbearbeiten") != null)
        {
            %>
                 <%@include file="/controllers/editprofile.jsp" %>
            <%
        }
        // Wurde der Ändern Button gedrückt im Profil bearbeiten kommt der else if Block zum Zug
        else if (request.getParameter("aendern") != null)
        {
            String anrede = request.getParameter("anrede");
            String vorname = request.getParameter("vorname");
            String nachname = request.getParameter("nachname");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashInBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashInBytes) {
            sb.append(String.format("%02x", b));
            }
            password = sb.toString();
            String sql2 = "UPDATE benutzer " +
                            "SET Anrede = '"+ anrede + "' " +
                            ", Vorname = '"+ vorname + "' " +
                            ", Nachname = '"+ nachname + "' " +
                            ", Email = '"+ email + "' " +
                            ", Passwort = '"+ password+ "' " +
                            " WHERE Benutzer_ID = '" + session.getAttribute("Id") + "' ";
            
            // Try and Catch Block um Sicherzustellen das die Verbindung zur DB besteht
            try
            {
                conn = DriverManager.getConnection(url, dbuser, pw);
                st = conn.createStatement();
                try 
                {
                    st.executeUpdate(sql2);
                    // Ist die änderung erfolgreich wird die editProfile Seite neu geladen mit der Meldung
                    request.setAttribute("edit","Erfolgreich");
                    %>
                        <%@include file="/controllers/editprofile.jsp" %>
                    <% 
                } 
                catch (Exception e)
                {
                    status = "error";
                    session.setAttribute("error",e.getMessage());
                }
                if (status != null)
                {
                    // Es wird zur FehlerPage weitergeleitet
                    response.sendRedirect("http://localhost:8080/fremdsprachen/fehlerpage.jsp");  
                }
                
            }
            catch (Exception e)
            {
                dbStatus = "error";
            }
            finally
            {
                conn.close();
            }
            // Ist die Verbindung zur DB unterbrochen wird zur ErrorPage weitergeleitet
            if (dbStatus != null)
            {
                response.sendRedirect("http://localhost:8080/fremdsprachen/errorPage.jsp");
            }
           
        }
        // Wurde in der Startseite der KartenButton nächste gedrückt wird hier die startseite neu geladen.
        else if (request.getParameter("next") != null)
        {
            request.setAttribute("next","next");
             %>
                 <%@include file="/controllers/startseite.jsp" %>
            <%

        }
        // Wurde der Button Bibliothek bearbeiten gedrückt wird die editbibliothek geladen
        else if (request.getParameter("bibedit") != null)
        {
             %>
                 <%@include file="/controllers/editbibliothek.jsp" %>
            <%
        }
        // Wurde der Button Karten bearbeiten gedrückt wird die Edit Karten geladen
        else if (request.getParameter("editKarten") != null)
        {
             %>
                 <%@include file="/controllers/editKarten.jsp" %>
            <%
        }
        // Wurde im Profil bearbeiten der Löschen Button gedrückt wird dieser else if Block ausgeführt
        else if (request.getParameter("delete") != null)
        { 
            // Try and Catch Block um Sicherzustellen das die Verbindung zur DB besteht
            try
            {
                conn = DriverManager.getConnection(url, dbuser, pw);
                st = conn.createStatement(); 
                String sql2 = "DELETE FROM benutzer WHERE Benutzer_ID = '" + session.getAttribute("Id") + "' ";
                st.executeUpdate(sql2);
                // Ist das löschen erfolgreich wird die Session gelöscht und zur Index Seite weitergeleitet
                session.removeAttribute("Vorname");
                response.sendRedirect("http://localhost:8080/fremdsprachen/index.jsp");  
            }
            catch (Exception e)
            {
                dbStatus = "error";
            }
            finally
            {
                conn.close();
            }
            // Ist die DB beim Löschen nicht erreichbar wird zur errorPage weitergeleitet
            if (dbStatus != null)
            {
               response.sendRedirect("http://localhost:8080/fremdsprachen/errorPage.jsp"); 
            } 
        }
        // wurde der Button neue Karte hinzufügen gedrückt geh es hier weiter
        else if (request.getParameter("addCard") != null)
        {
            // Die Variablen für das Statement werden erstellt
            int sprachId = Integer.parseInt(request.getParameter("sprachen"));
            String vorderseite = request.getParameter("vorderseite");
            String rueckseite = request.getParameter("rueckseite"); 
            // Die Connection wird in einem Try Catch Block ausgeführt um ein Unterbruch der Verbindung abzufangen
            try 
            {
                conn = DriverManager.getConnection(url, dbuser, pw);
                st = conn.createStatement();
                String sql = "INSERT INTO karteikarten(Vorderseite, Rueckseite, FK_Benutzer, FK_Sprache) VALUES ('"+vorderseite+"','"+rueckseite+"',"+session.getAttribute("Id")+","+sprachId+")";
                // Das Statment wird in einem Try Catch Block ausgeführt um Fehler Seiten der DB abzufangen und in einer Fehlpage anzuzeigen
                try 
                {
                    st.executeUpdate(sql);
                }
                catch (Exception e)
                {
                    status = "error";
                    session.setAttribute("error",e.getMessage());
                }
                // Hat die DB einen Fehler geworfen wird dieser Abgefangen und die Fehlermeldung an die Fehlerpage weitergegeben
                if (status != null)
                {
                    response.sendRedirect("http://localhost:8080/fremdsprachen/fehlerpage.jsp");
                }
                // Ist alles ok geht es zur Starteite 
                response.sendRedirect("http://localhost:8080/fremdsprachen/index.jsp");
            }
            catch (Exception e)
            {
                dbStatus = "error";
            }
            finally
            {
                conn.close();
            }
            // Ist keine Verbindung zur DB möglich wird die errorPage geladen
            if (dbStatus != null)
            {
                response.sendRedirect("http://localhost:8080/fremdsprachen/errorPage.jsp"); 
            }
                 
        }
        // Wurde der Karte löschen Button gedrückt geht es hier weiter
        else if (request.getParameter("deleteCard") != null)
        {
            int kartenId = Integer.parseInt(request.getParameter("kartenNummer"));
            // Die Verbindung zur DB wird in einem Try Catch Block ausgeführt um Fehler mit der Verbindung abzufangen
            try
            {
                conn = DriverManager.getConnection(url, dbuser, pw);
                st = conn.createStatement();
                // Das Statement wird in einem Try Catch Block ausgeführt um Fehler seitens DB abzufangen
                try 
                {
                    String sql = "DELETE FROM karteikarten WHERE Karten_NR = '" + kartenId + "' ";
                    st.executeUpdate(sql);
                } 
                catch (Exception e)
                {
                    status = "error";
                    session.setAttribute("error",e.getMessage());
                }
                // Hat die Db einen Fehler geworfen wird die fehlerpage geladen und der Fehler mitgegeben
                if (status != null)
                {
                    response.sendRedirect("http://localhost:8080/fremdsprachen/fehlerpage.jsp");
                } 
                // Wenn alles ok ist wird die Startseite geladen
                response.sendRedirect("http://localhost:8080/fremdsprachen/index.jsp"); 
            }
            catch (Exception e)
            {
                dbStatus = "error";
            }
            finally
            {
                conn.close();
            }
            // Ist keine Verbindung zur DB möglich wird hier die errorPage geladen
            if (dbStatus != null)
            {
                response.sendRedirect("http://localhost:8080/fremdsprachen/errorPage.jsp"); 
            }
        }
        else if (request.getParameter("editCard") != null)
        {
            int kartenIdEdit = Integer.parseInt(request.getParameter("kartenNummer"));
            int sprachIdEdit = Integer.parseInt(request.getParameter("sprachen"));
            String vorderseiteEdit = request.getParameter("vorderseiteEdit");
            String rueckseiteEdit = request.getParameter("rueckseiteEdit"); 
            try
            {
                conn = DriverManager.getConnection(url, dbuser, pw);
                st = conn.createStatement();
            }
            catch (Exception e)
            {
                dbStatus = "error";
            }
            if (dbStatus != null)
            {
                response.sendRedirect("http://localhost:8080/fremdsprachen/errorPage.jsp");
            }
            try
            {
                String sql = "UPDATE karteikarten " +
                    "SET Vorderseite = '"+ vorderseiteEdit + "' " +
                    ", Rueckseite = '"+ rueckseiteEdit + "' " +
                    ", FK_Sprache = "+ sprachIdEdit + " " +
                    " WHERE Karten_NR = '" + kartenIdEdit + "' ";
                st.executeUpdate(sql);
            }
            catch (Exception e)
            {
                status = "error";
                session.setAttribute("error",e.getMessage());
            }
            finally
            {
                conn.close();
            }
            // Hat die Db einen Fehler geworfen wird die fehlerpage geladen und der Fehler mitgegeben
            if (status != null)
            {
                response.sendRedirect("http://localhost:8080/fremdsprachen/fehlerpage.jsp");
            } 
            else
            {
                // Wenn alles ok ist wird die Startseite geladen
                response.sendRedirect("http://localhost:8080/fremdsprachen/index.jsp");  
            }    
        }
        else if (request.getParameter("addSprache") != null)
        {
            String Titel = request.getParameter("sprachen");
            Integer position = (Integer) session.getAttribute("Position");
            position++;
            try
            {
                conn = DriverManager.getConnection(url, dbuser, pw);
                st = conn.createStatement();
            }
            catch (Exception e)
            {
                dbStatus = "error";
            }
            if (dbStatus != null)
            {
                response.sendRedirect("http://localhost:8080/fremdsprachen/errorPage.jsp");
            } 
            try
            {
                String sql = "INSERT INTO bibliotheken(Titel, Ebene, Position, FK_Benutzer)  " +
                        "VALUES ('"+Titel+"',"+2+","+position+","+session.getAttribute("Id")+")";
                st.executeUpdate(sql);
            }
            catch (Exception e)
            {
                status = "error";
                session.setAttribute("error",e.getMessage());
            }
            finally
            {
                conn.close();
            }
            // Hat die Db einen Fehler geworfen wird die fehlerpage geladen und der Fehler mitgegeben
            if (status != null)
            {
                response.sendRedirect("http://localhost:8080/fremdsprachen/fehlerpage.jsp");
            }
            else
            {
                // Wenn alles ok ist wird die Startseite geladen
                response.sendRedirect("http://localhost:8080/fremdsprachen/index.jsp"); 
            } 

        }
        else
        {
            %>
                 <%@include file="/controllers/startseite.jsp" %>
            <%
        }       
    }
%>

<%@include file="/controllers/footer.jsp" %>

