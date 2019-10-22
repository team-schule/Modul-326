<style>
  .test{
    width:50%;
    height:50%;
    background-color: lightgrey;
    margin-left:auto;
    margin-right:auto;
    margin-top:10%;
    border-radius: 7px;
    border: 3px solid black;
    box-shadow: 5px 10px #888888;
    padding:10px;
      }
    body{
     background-image: url("./Bilder/login.png");
       background-repeat: no-repeat;
    }
    .login{
      
    }
    h1{
        font-family: "Comic Sans MS", cursive, sans-serif;
        margin-left:8%;
    }

</style>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<body>
<br>
<h1>Fremdsprachen lernen</h1>
<div class="login">
<div class="test">
<h3>Login</h3>
<%
  if (request.getAttribute("error") != null)
  {
    %>
    <h4 style="color:red;">Login Fehlgeschlagen</h4>
    <%
  }
%>
<br>
<form action = "index.jsp" method = "POST">
  <div class="form-group">
    <label for="formGroupExampleInput">Login Name:</label>
    <input type="text" class="form-control" id="formGroupExampleInput" Name="loginName" aria-describedby="emailHelp" placeholder="Login Name">
  </div>
  <div class="form-group">
    <label for="exampleInputPassword1">Password:</label>
    <input type="password" class="form-control" id="exampleInputPassword1" Name="password" placeholder="Password">
  </div>
  <br>
  <button type="submit" Name="login" class="btn btn-primary">Login</button>
  <button Name="register" class="btn btn-primary">Registrieren</button>
</form>
</div>
</div>
</body>