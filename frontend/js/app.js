async function loadConcours() {

    const response =
        await fetch("../backend/getConcours.php");

    const text = await response.text();

    const parser = new DOMParser();

    const xml =
        parser.parseFromString(text, "application/xml");

    const concours =
        xml.getElementsByTagName("concours");

    let html = "";

    for(let i = 0; i < concours.length; i++) {

        const c = concours[i];

        if(c.getElementsByTagName("titre").length === 0)
            continue;

        html += `
        <tr>
            <td>${c.getElementsByTagName("titre")[0].textContent}</td>

            <td>${c.getElementsByTagName("date")[0].textContent}</td>

            <td>${c.getElementsByTagName("categorie")[0].textContent}</td>

            <td>${c.getElementsByTagName("coefficient")[0].textContent}</td>
        </tr>
        `;
    }

    document.getElementById("concoursBody").innerHTML = html;
}

async function inscrireMembre(event){

    event.preventDefault();

    const form =
        document.getElementById("inscriptionForm");

    const formData = new FormData(form);

    const response =
        await fetch("../backend/inscrire.php",{
            method:"POST",
            body:formData
        });

    const result = await response.json();

    document.getElementById("message").innerHTML =
        result.message;
}

async function afficherResultats(){

    const concoursId =
        document.getElementById("concoursSelect").value;

    const response =
        await fetch(
            "../backend/getResultats.php?concoursId="
            + concoursId
        );

    const text = await response.text();

    const parser = new DOMParser();

    const xml =
        parser.parseFromString(text,"application/xml");

    const participants =
        xml.getElementsByTagName("participant");

    let maxScore = 0;

    for(let p of participants){

        const score =
            parseFloat(
                p.getElementsByTagName("score")[0]
                .textContent
            );

        if(score > maxScore)
            maxScore = score;
    }

    let html = `
    <table>
        <tr>
            <th>Nom</th>
            <th>Prénom</th>
            <th>Score</th>
        </tr>
    `;

    for(let p of participants){

        const score =
            parseFloat(
                p.getElementsByTagName("score")[0]
                .textContent
            );

        const winner =
            score === maxScore ? "winner" : "";

        html += `
        <tr class="${winner}">
            <td>${p.getElementsByTagName("nom")[0].textContent}</td>

            <td>${p.getElementsByTagName("prenom")[0].textContent}</td>

            <td>${score}</td>
        </tr>
        `;
    }

    html += "</table>";

    document.getElementById("resultats").innerHTML =
        html;
}

async function executeQuery(){

    const query =
        document.getElementById("xquery").value;

    const formData = new FormData();

    formData.append("query", query);

    const response =
        await fetch("../backend/executeQuery.php",{
            method:"POST",
            body:formData
        });

    const result = await response.text();

    document.getElementById("queryResult").innerText =
        result;
}