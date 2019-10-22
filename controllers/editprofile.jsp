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

</style>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Class.forName("com.mysql.jdbc.Driver"); 
    Connection con =DriverManager.getConnection("jdbc:mysql://localhost:3306/fremdsprachen","root",""); 
    Statement s = con.createStatement(); 
    String sql =  sql="SELECT * FROM benutzer WHERE Benutzer_ID= '"+session.getAttribute("Id")+"'";

    ResultSet rs = s.executeQuery(sql);
    if (rs.next())
    {
        session.setAttribute("Vorname", rs.getString("Vorname"));
        session.setAttribute("Nachname", rs.getString("Nachname"));
        session.setAttribute("Anrede", rs.getString("Anrede"));
        session.setAttribute("Email", rs.getString("Email"));
        session.setAttribute("Aktiv", rs.getString("Letzte_Aktivitaet"));   
    }
    else
    {
        response.sendRedirect("http://localhost:8080/dbTest/errorPage.jsp");  
    }
    rs.close();
%>
<body>
<h2>Profil von  <%= session.getAttribute("Benutzername") %> : </h2>


<div class="test">
<div class="edit">
<%
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
    if (geschlecht.equals("Herr")){
      %>
      <option selected>Herr</option>
      <option>Frau</option>
      <%
    }
    else{
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
    <input type="text" class="form-control" id="exampleInputPassword1" required
        Name="vorname" placeholder="Vorname" value="<%= session.getAttribute("Vorname") %>">
  </div>
  <div class="form-group">
    <label for="exampleInputPassword1">Nachname:</label>
    <input type="text" class="form-control" id="exampleInputPassword1" required
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
  <button type="submit" Name="aendern" class="btn btn-primary">Ändern</button>
</form>
<br>
<form action = "index.jsp" method = "POST">
 <button type="submit" Name="login" class="btn btn-primary">Zur Startseite</button>
</form>
<p>Letze Aktivität: <%= session.getAttribute("Aktiv") %> </p>
</div>
</div>

</body>