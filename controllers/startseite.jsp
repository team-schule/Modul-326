<style>
body{
      background-image: url("./Bilder/titelbild.png");
       margin: 20px;
    }
#logoutButton{
  background-color: #4CAF50;
  border: none;
  color: white;
  padding: 16px 32px;
  text-align: center;
  border-radius: 7px;
  text-decoration: none;
  display: block;
  font-size: 16px;
  margin: 4px 2px;
  -webkit-transition-duration: 0.4s; 
  transition-duration: 0.4s;
 
  cursor: pointer;
}
#logoutButton:hover{
   font-weight: bold;
}
.header{
   width: 100%;
    display: flex;
  flex-wrap: nowrap;
  justify-content: flex-end;
}
header > div{
   padding: 10px;
}
.seite{
   width:100%;
   height:500px;
   display:flex;
}
.baum{
   width:45%;
   float:left;
 
}
.karte{
   width:45%;
   float:left;
   margin-left:10%;
}
#lernkarte{
   width:80%;
   height:50%;
   background-color:grey;
   margin:auto;
   bottom:auto;
   transform-style: preserve-3d;
   transition: transform 1s;
   border-radius:15px;
   color:white;
   border: 2px solid black;
}
#lernkarte figure {
  margin: 0;
  display: block;
  position: absolute;
  width: 100%;
  height: 100%;
  backface-visibility: hidden;
  border-radius:15px;
  border: 2px solid black;
}

#lernkarte .front {
  background: grey;
}

#lernkarte .back {
  background: lightgrey;
  color:black;
  transform: rotateY( 180deg);
}

#lernkarte.flipped {
  transform: rotateY( 180deg);
}
button{
     background-color: #4CAF50;
  border: none;
  color: white;
  padding: 16px 32px;
  text-align: center;
  border-radius: 7px;
  text-decoration: none;
  font-size: 16px;
   margin-right:15%;
  -webkit-transition-duration: 0.4s; 
  transition-duration: 0.4s;
}
#flip{
   margin:7%;
   margin-left:25%;
}
h3,h4{
   text-align:center;
   margin-top:5%;
}
.pkarte{
   text-align:center;
   font-size:3em;
   color:red;
    font-weight: bold;
}
.htitel{
   font-weight:bold;
   color: blue;
   margin-left:20%;
   font-size:3em;
}
.bib1{
   margin-left:10%;
   font-size:2em;
   cursor:pointer;
   font-weight:bold;
   padding-left: 50px;
}
.bib2{
   margin-left:10%;
   font-size:2em;
   cursor:pointer;
   font-weight:bold;
   padding-left: 100px;
}
#unterkarte{
   display: flex;
}


</style>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
   

   Connection con2 =DriverManager.getConnection("jdbc:mysql://localhost:3306/fremdsprachen","root",""); 
   Statement s2 = con2.createStatement(); 
   String sql2="SELECT * FROM karteikarten WHERE FK_Benutzer= '"+session.getAttribute("Id")+"'";
   String sql3="SELECT * FROM bibliotheken WHERE FK_Benutzer= '"+session.getAttribute("Id")+"'";
   
  

   ResultSet rs3 = s2.executeQuery(sql3);

   int i = 0;
   int laenge = 0;
   String bib[] = new String[10];
   int ebe[] = new int[10];
   while (rs3.next())
   {
      ebe[i] = rs3.getInt("Ebene");
      bib[i] = rs3.getString("Titel");
      i++;
      laenge++;
   }
   rs3.close();

  ResultSet rs2 = s2.executeQuery(sql2);

   int z = 0;
   String rueckseite[] = new String[20];
   String vorderseite[] = new String[20];
   int sprache[] = new int[20];
    while (rs2.next())
    {
       rueckseite[z] = rs2.getString("Rueckseite");
       vorderseite[z]= rs2.getString("Vorderseite");
       sprache[z] = rs2.getInt(5);
       z++;
    }

%>

<body>
<div class="header">
<form action = "index.jsp" method = "POST">
<div><input type="submit" id="logoutButton" name="profilbearbeiten" value="Profil bearbeiten"></div>
</form>
<form action = "index.jsp" method = "POST">
<div><input type="submit" id="logoutButton" name="logout" value="Logout"></div>
</form>
</div>
<h2>Hallo <span style="color: red;"><%= session.getAttribute("Vorname")%>&nbsp;<%= session.getAttribute("Nachname")%>
</span> Willkommen auf unserer Webseite</h2>
<br>
<div class="seite">
   <div class="baum">
   
   <h2 class="htitel">Bibliothek</h2>
   <br>
   <br>
   <%
   for(int y = 1; y < laenge; y++){

      if (ebe[y] == 2){
         %>
         <p class="bib1"><%=bib[y] %>
         <%
      }
         if (ebe[y] == 3){
         %>
         <p class="bib2"><%=bib[y] %>
         <%
      }
   }
   %>

      


   </div>
   <div class="karte">
   <h2 class="htitel">Lernkarten</h2>
   <br>
   <br>
   <div id="lernkarte">
   <%
    Integer kartenNummer = (Integer) session.getAttribute("kartenNummer");
  
    if (request.getAttribute("next") != null)
    {
      kartenNummer++;
      session.setAttribute("kartenNummer",kartenNummer);
      if (vorderseite[kartenNummer] == null)
      {
         kartenNummer = 0;
         session.setAttribute("kartenNummer",kartenNummer);
      }
    }
   
      String lernsprache = "";
      if (sprache[kartenNummer] == 1) lernsprache = "Französisch";
      if (sprache[kartenNummer] == 2) lernsprache = "Englisch";
      if (sprache[kartenNummer] == 3) lernsprache = "Italienisch";
      if (sprache[kartenNummer] == 4) lernsprache = "Spanisch";
      if (sprache[kartenNummer] == 5) lernsprache = "Griechisch";
      if (sprache[kartenNummer] == 6) lernsprache = "Türkisch";
    
   %>
      <figure class="front">
      <h3>Vorderseite</h3>
      <h4>Lernsprache: <%=lernsprache %> </h4>
         <p class="pkarte"><%= vorderseite[kartenNummer]%></p>
      </figure>
      <figure class="back"><h3>Rückseite</h3>
      <br>
      <br>
      <p class="pkarte"><%= rueckseite[kartenNummer] %>
      </figure>
      
   </div>
   <br>
    <div id=unterkarte>
    <button id="flip">Karte drehen</button>
   <form action ="index.jsp" method="Post">
    <button id="nextcard" name="next">Nächste Karte</button>
    </form>
   </div>

   </div>
</div>


</body>
  <script>
  var card = document.getElementById('lernkarte');

document.getElementById('flip').addEventListener('click', function() {
    card.classList.toggle('flipped');
}, false);
  
  </script>