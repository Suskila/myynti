<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.15.0/jquery.validate.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Muuta asiakas</title>
</head>
<body onkeydown="tutkiKey(event)">
<form id="tiedot">
	<table>
		<thead>	
			<tr>
				<th colspan="3" id="ilmo"></th>
				<th colspan="2" class="oikealle"><a href="listaaasiakkaatJS.jsp" id="takaisin">Takaisin listaukseen</a></th>
			</tr>		
			<tr>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>S�hk�posti</th>
				<th>Hallinta</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><input type="text" name="etunimi" id="etunimi"></td>
				<td><input type="text" name="sukunimi" id="sukunimi"></td>
				<td><input type="text" name="puhelin" id="puhelin"></td> 
				<td><input type="text" name="sposti" id="sposti"></td>
				<td><input type="submit" id="tallenna" value="Tallenna" onclick="muutaAsiakas()"></td>
			</tr>
		</tbody>
	</table>
	<input type="hidden" name="asiakas_id" id="asiakas_id">
</form>
<span id="ilmo"></span>
</body>
<script>
function tutkiKeyX(event){
	if(event.keyCode==13){//Enter
		vieTiedot();
	}		
}

var tutkiKey = (event) => {
	if(event.keyCode==13){//Enter
		vieTiedot();
	}	
}

document.getElementById("etunimi").focus();
	
	var asiakas_id = requestURLParam("asiakas_id");
	
	fetch("asiakkaat/haeyksi/" + asiakas_id,{
	      method: 'GET'	      
	    })
	.then( function (response) {
		return response.json()
	})
	.then( function (responseJson) {
		console.log(responseJson);
		document.getElementById("etunimi").value = responseJson.etunimi;		
		document.getElementById("sukunimi").value = responseJson.sukunimi;	
		document.getElementById("puhelin").value = responseJson.puhelin;	
		document.getElementById("sposti").value = responseJson.sposti;	
		document.getElementById("asiakas_id").value = responseJson.asiakas_id;	
	});	


	function muutaAsiakas(){	
			var ilmo="";
			if(document.getElementById("etunimi").value.length<3){
				ilmo="Etunimi ei kelpaa!";		
			}else if(document.getElementById("sukunimi").value.length<3){
				ilmo="Sukunimi ei kelpaa!";		
			}else if(document.getElementById("puhelin").value*1!=document.getElementById("puhelin").value){
				ilmo="Puhelin ei kelpaa!";		
			}else if(document.getElementById("sposti").value.length<5){
				ilmo="S�hk�posti ei kelpaa!";
			}
			if(ilmo!=""){
				document.getElementById("ilmo").innerHTML=ilmo;
				setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 3000);
				return;
			}
			document.getElementById("etunimi").value=siivoa(document.getElementById("etunimi").value);
			document.getElementById("sukunimi").value=siivoa(document.getElementById("sukunimi").value);
			document.getElementById("puhelin").value=siivoa(document.getElementById("puhelin").value);
			document.getElementById("sposti").value=siivoa(document.getElementById("sposti").value);	
				
			var formJsonStr=formDataToJSON(document.getElementById("tiedot"));  
		console.log(formJsonStr);
		fetch("asiakkaat",{
		      method: 'PUT',
		      body:formJsonStr
		    })
		.then( function (response) {
			return response.json();
		})
		.then( function (responseJson) {
			var vastaus = responseJson.response;		
			if(vastaus==0){
				document.getElementById("ilmo").innerHTML= "Asiakkaan p�ivitys ep�onnistui";
	        }else if(vastaus==1){	        	
	        	document.getElementById("ilmo").innerHTML= "Asiakkaan p�ivitys onnistui";			      	
			}	
			setTimeout(function(){ document.getElementById("ilmo").innerHTML=""; }, 5000);
		});	
		document.getElementById("tiedot").reset();
	}
	
</script>
</html>