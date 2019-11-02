<style>
body{
       background-image: url("./Bilder/titelbild.png");
       margin: 20px;
       background-repeat:none;
    }
.registrieren{
    width:800px;
    height:640px;
    background-color:lightgrey;
    margin-left:auto;
    margin-right:auto;
    margin-top:1%;
    border-radius: 7px;
}
.form{
    width:80%;
    margin-left:auto;
    margin-right:auto;

}

</style>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<body>
<h1>Registrieren bei Fremdsprachen.ch</h1>
<div class="registrieren">
<div class="form">
<form action = "index.jsp" method = "POST">
  <div class="form-group">
    <div class="form-group">
    <%
    if (request.getAttribute("loginName") != null)
    {
        %>
            <h5 style="color:red">Login Name ist schon vergeben</h4>
        <%
    }
    %>
    <label for="exampleFormControlSelect1">Anrede</label>
    <select class="form-control" id="exampleFormControlSelect1" name="anrede">
    <option value="Frau">Frau</option>
    <option value="Herr">Herr</option>
    </select>
  </div>
  </div>
  <div class="form-group">
    <label for="exampleInputPassword1">Vorname:</label>
    <input type="text" class="form-control" id="exampleInputPassword1" pattern="[A-Za-z]{3,30}" required
        Name="vorName" placeholder="Vorname">
  </div>
  <div class="form-group">
    <label for="exampleInputPassword1">Nachname:</label>
    <input type="text" class="form-control" id="exampleInputPassword1" pattern="[A-Za-z]{3,30}" required
        Name="nachName" placeholder="Nachname">
  </div>
  <div class="form-group">
    <label for="exampleInputPassword1">Login Name:</label>
    <input type="text" class="form-control" id="exampleInputPassword1" pattern="[A-Za-z]{3,30}" required
        Name="loginName" placeholder="LoginName">
  </div>
  <div class="form-group">
    <label for="exampleInputPassword1">Email:</label>
    <input type="email" class="form-control" id="exampleInputPassword1" required
        Name="email" placeholder="Email" pattern="^[a-z_0-9-]+@([a-z_0-9-]{3,}\.)+[a-z]{2,}$">
  </div>
  <div class="form-group">
    <label for="exampleInputPassword1">Password:</label>
    <input type="password" class="form-control" id="exampleInputPassword1" pattern="{6,12}" title="Passwort muss eine Länge zwischen 8 und 12 Zeichen haben" 
        Name="password" placeholder="Password" required>
    <small id="passwordHelpBlock" class="form-text text-muted">
        Passwort muss eine Länge zwischen 8 und 12 Zeichen haben
    </small>
  </div>
  <button type="submit" Name="registrieren" class="btn btn-success">Registrieren</button>
  <button type="reset" class="btn btn-warning">Reset</button>
   </form>
   <br>
  <form action = "index.jsp" method = "POST">
  <button Name="zumLogin" class="btn btn-primary">Zurück</button>
 
</form>
</div>
</div>
</body>