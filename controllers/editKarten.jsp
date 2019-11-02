<style>
body{
    background-image: url("./Bilder/titelbild.png");
    margin: 20px;
    background-repeat:none;
    width:100%;
}
.karte{
    width: 670px;
    height: 250px;
    background-color: lightblue;
    margin-left: auto;
    margin-right: auto;
    border-radius: 7px;
}
.container {
    margin: 7px;
}
.form-control {
    width: 50%;
}
h2 {
    margin-left :28%;
}
</style>
<body>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<h1>Deine Lernkarten verwalten</h1>
<form action = "index.jsp" method = "POST">
    <button type="submit" Name="login" class="btn btn-primary">Zur Startseite</button>
</form>
<h2>Neue Karte Hinzufügen</h2>
    <div class="karte">
        <form action="index.jsp" method="POST" class="container" id="neu">
            <table>
                <tr>
                    <th>Vorderseite</th>
                    <th>Rückseite</th>
                </tr>
                <tr>
                <label for="dropdown" style="font-weight: bold;">Lernsprache</label>
                    <select class="form-control" name="sprachen" id="dropdownNeu">
                        <option value="1">Französisch</option>
                        <option value="2">Englisch</option>
                        <option value="3">Italienisch</option>
                        <option value="4">Spanisch</option>
                        <option value="5">Griechisch</option>
                        <option value="6">Türkisch</option>
                    </select>
                </tr>
                <tr>
                    <td><textarea form="neu" rows="2" cols="40" name="vorderseite" pattern="{1,50}" required></textarea></td>
                    <td><textarea rows="2" cols="40" name="rueckseite" form="neu" pattern="{1,50}" required></textarea></td>
                </tr>
                <tr>
                    <td><button type="submit" name="addCard" class="btn btn-success">Lernkarte Hinzufügen</button>
                </tr>
            </table>
        </form>
    </div>
    <br>
    <h2>Vorhandene Karten bearbeiten</h2>
    <%     
    try 
    {
        conn =DriverManager.getConnection(url, dbuser, pw); 
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
    else
    {
        try 
        {
            String sql1="SELECT * FROM karteikarten WHERE FK_Benutzer= '"+session.getAttribute("Id")+"'";
            rs = st.executeQuery(sql1);
            while (rs.next())
            {
             %>
                <div class="karte">
                    <form action="index.jsp" method="POST" class="container" id="test">
                        <table>
                            <tr> 
                                <th>Vorderseite</th>
                                <th>Rückseite</th>
                            </tr>
                            <tr>   
                                <label for="dropdown" style="font-weight: bold;">Lernsprache</label>
                                <select class="form-control" name="sprachen" id="dropdown">
                                <% 
                                if (rs.getInt("FK_Sprache") == 1)
                                {
                                    %><option selected value="1">Französisch</option><%
                                }
                                else
                                {
                                    %><option value="1">Französisch</option><%
                                }
                                if (rs.getInt("FK_Sprache") == 2)
                                {
                                    %><option selected value="2">Englisch</option><%
                                }
                                else 
                                {
                                    %><option value="2">Englisch</option><%
                                }
                                if (rs.getInt("FK_Sprache") == 3) 
                                {
                                    %><option selected value="3">Italienisch</option><%
                                }
                                else 
                                {
                                    %><option value="3">Italienisch</option><%
                                }
                                if (rs.getInt("FK_Sprache") == 4) 
                                {
                                    %><option selected value="4">Spanisch</option><%
                                }
                                else 
                                {
                                    %><option value="4">Spanisch</option><%
                                }
                                if (rs.getInt("FK_Sprache") == 5)
                                {
                                    %><option selected value="5">Griechisch</option><%
                                }
                                else 
                                {
                                    %><option value="5">Griechisch</option><%
                                }
                                if (rs.getInt("FK_Sprache") == 6) 
                                {
                                    %><option selected value="6">Türkisch</option><%
                                }
                                else 
                                {
                                    %><option value="6">Türkisch</option><%
                                }                   
                                %>
                            </select>
                            </tr>
                            <tr>
                                <td style="display: none;"><input type="text" name="kartenNummer" value="<%= rs.getInt("Karten_NR") %>"></td>
                                <td><input type="text" name="vorderseiteEdit" style="width:300px; height:50px;" required pattern="{1,50}" value="<%= rs.getString("Vorderseite") %>"></td>
                                <td><input type="text" name="rueckseiteEdit" style="width:300px; height:50px;" required pattern="{1,50}" value="<%= rs.getString("Rueckseite") %>"></td>
                            </tr>
                            <tr>
                                <td><button type="submit" name="editCard" class="btn btn-success">Ändern</button>
                                <td><button id="btn-confirm2" type="submit" name="deleteCard" onclick="confirm('Karte wirklich löschen ?');" class="btn btn-danger">Karte Löschen</button></td>
                            </tr>
                        </table>
                    </form>
                    <br>
                </div>
                <%
            }
    } 
    catch(Exception e)
    {
        status = "error";
    }
    finally
    {
        conn.close();
    }
    if (status != null)
    {
        response.sendRedirect("http://localhost:8080/fremdsprachen/fehlerpage.jsp");
    }             
}
    
%>
</body>
