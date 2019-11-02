<style>
body{
    background-image: url("./Bilder/titelbild.png");
    margin: 20px;
    background-repeat:none;
}
.test{
    width: 60%;
    height:50%;
    margin-left: 10%;
    background-color: lightgrey;
    border-radius:7px;
}
.edit{
    margin:5%;
}
h2{
    margin-left:10%;
}
p{
    margin-left:65%;
}
#buttonunten{
}

</style>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
    String sql =  sql="SELECT * FROM benutzer WHERE Benutzer_ID= '"+session.getAttribute("Id")+"'";
    // Try Catch Block um Sicher zu stellen das die Verbindung zur DB besteht
    try 
    {
        conn = DriverManager.getConnection(url, dbuser, pw);
        st = conn.createStatement(); 
        rs = st.executeQuery(sql);
        if (rs.next())
        {
            session.setAttribute("Vorname", rs.getString("Vorname"));
            session.setAttribute("Nachname", rs.getString("Nachname"));
            session.setAttribute("Anrede", rs.getString("Anrede"));
            session.setAttribute("Email", rs.getString("Email"));
            session.setAttribute("Aktiv", rs.getString("Letzte_Aenderung"));   
            rs.close();
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
    // Ist die DB nicht erreichbar bei der Abfrage wird zur ErrorPage weitergeleitet
    if (dbStatus != null){
        response.sendRedirect("http://localhost:8080/fremdsprachen/errorPage.jsp"); 
    }
    
%>
<body>
<h2>Profil von  <%= session.getAttribute("Benutzername") %> : </h2>
<div class="test">
<div class="edit">
<%
    // wurden die Daten erfolgreich geändert wird beim neuladen der EdditSeite eine Meldung angezeigt
    if (request.getAttribute("edit") != null)
    {
        %>
            <h4 style="color:green;">Daten erfolgreich geändert</h4>
        <%
    }
%>
<form action = "index.jsp" method = "POST">
    <div class="form-group">
    <div class="form-group">
    <label for="exampleFormControlSelect1">Anrede</label>
    <select class="form-control" id="exampleFormControlSelect1" name="anrede">
    <%
    String geschlecht = (String) session.getAttribute("Anrede");
    if (geschlecht.equals("Herr"))
    {
        %>
        <option selected>Herr</option>
        <option>Frau</option>
        <%
    }
    else
    {
        %>
        <option>Herr</option>
        <option selected>Frau</option>
        <%
    }
    %>
    </select>
  </div>
  </div>
  <div class="form-group">
    <label for="exampleInputPassword1">Vorname:</label>
    <input type="text" class="form-control" id="exampleInputPassword1" pattern="[A-Za-z]{3,30}" required
        Name="vorname" placeholder="Vorname" value="<%= session.getAttribute("Vorname") %>">
  </div>
  <div class="form-group">
    <label for="exampleInputPassword1">Nachname:</label>
    <input type="text" class="form-control" id="exampleInputPassword1" pattern="[A-Za-z]{3,30}" required
        Name="nachname" placeholder="Nachname" value="<%= session.getAttribute("Nachname") %>">
  </div>
  <div class="form-group">
    <label for="exampleInputPassword1">Email:</label>
    <input type="email" class="form-control" id="exampleInputPassword1" required
        Name="email" placeholder="Email" pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}" value="<%= session.getAttribute("Email") %>">
  </div>
  <div class="form-group">
    <label for="exampleInputPassword1">Password:</label>
    <input type="password" class="form-control" id="exampleInputPassword1" pattern=".{6,12}" title="Passwort muss eine Länge zwischen 8 und 12 Zeichen haben" 
        Name="password" placeholder="Password" required>
    <small id="passwordHelpBlock" class="form-text text-muted">
        Passwort muss eine Länge zwischen 8 und 12 Zeichen haben
    </small>
  </div>
  <br>
  <button type="submit" Name="aendern" class="btn btn-success">Ändern</button>
  <button type="reset" class="btn btn-warning">Reset</button>
</form>
<br>
<div id="buttonunten">
<form action = "index.jsp" method = "POST">
 <button type="submit" Name="login" class="btn btn-primary">Zur Startseite</button>
  <button style="margin-left:50%;" id="btn-confirm" type="submit" name="delete" onclick="return clicked()" class="btn btn-danger">Profil löschen</button>
</form>
</div>

<p>Letze Aktivität: <%= session.getAttribute("Aktiv") %> </p>
</div>
</div>

</body>

<script type="text/javascript">
    function clicked() {
       if (confirm('Profil: <%= session.getAttribute("Vorname") %>'+ ' ' + '<%= session.getAttribute("Nachname") %> löschen ? ')) {
           yourformelement.submit();
       } else {
           return false;
       }
    }

</script>
