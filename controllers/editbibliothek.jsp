<style>
body{
    background-image: url("./Bilder/titelbild.png");
    margin: 20px;
    background-repeat:none;
}
.center {
  display: block;
  margin-left: auto;
  margin-right: auto;
  width: 50%;
}
</style>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<form action = "index.jsp" method = "POST">
 <button type="submit" Name="login" class="btn btn-primary">Zur Startseite</button>
 </form>
 <!--
 <img src="./Bilder/under.png" class="center">
 <br>
 <img src="./Bilder/soon.jpg" class="center">
-->
<h2>Neue Sprache hinzufügen</h2>
<br>
<div class="form-group">
    <form action="index.jsp" method="POST">
        <label for="sprachen">Sprachen</label>
        <select class="form-control" id="sprachen" name="sprachen">
            <option value="Französisch">Französisch</option>
            <option value="Englisch">Englisch</option>
            <option value="Italienisch">Italienisch</option>
            <option value="Spanisch">Spanisch</option>
            <option value="Griechisch">Griechisch</option>
            <option value="Türkisch">Türkisch</option>
        </select>
    <button type="submit" Name="addSprache" class="btn btn-success">Hinzufügen</button>
    </form> 
    <br>
    <br> 
     <h2>Einträge bearbeiten</h2>
 <%
    String titel[] = new String[20];
    int i = 0;
    int laenge = 0;
    try 
    {
        conn =DriverManager.getConnection(url, dbuser, pw); 
        st = conn.createStatement(); 
        String sql="SELECT * FROM bibliotheken WHERE FK_Benutzer= '"+session.getAttribute("Id")+"'";
        rs = st.executeQuery(sql);
        while (rs.next())
        {
            if (rs.getInt("Ebene") == 2)
            {
                titel[i] = rs.getString("Titel");
                i++;
                laenge++;
                session.setAttribute("Position",laenge);
                %>
                    <h3><%= rs.getString("Titel") %></h3>
                <%
            }
            else if (rs.getInt("Ebene") == 3)
            {
                %>
                <form action="index.jsp" method="POST">
                <input type="text" class="form-control" id="name" pattern="{3,30}" required
                    Name="name" placeholder="Eintrag" value="<%= rs.getString("Titel") %>">    
                <button type="submit" Name="editBib" class="btn btn-success">Ändern</button>
                <br>
                </form>
                <%
            }
        }
        %>
        <h2>Bibliothek Eintrag hinzufügen</h2>
        <form>
        <div class="form-group">
        <label for="exampleFormControlSelect1">Sprache</label>
        <select class="form-control" id="exampleFormControlSelect1" name="sprache">
            <%
            for (int y = 0; y < laenge; y++)
            {
                %>
                <option value="2"><%= titel[y]%></option>
                <%
            }
            %>
            </select>
            <input type="text" class="form-control" id="nameAdd" pattern="{3,30}" required
                    Name="name" placeholder="Eintrag">   
            <button type="submit" Name="editBib" class="btn btn-success">Hinzufügen</button>
            </form>
            <%
    }
    catch (Exception e)
    {
        dbStatus = "error";
    }
    finally
    {
        conn.close();
    }
    if (dbStatus != null)
    {
        response.sendRedirect("http://localhost:8080/fremdsprachen/errorPage.jsp");
    }
 %>