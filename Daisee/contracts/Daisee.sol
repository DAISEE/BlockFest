contract Daisee {

    Usager[] public usagers;
    uint public currentTime;
    uint prixKwh;

    /* Usagers */
    struct Usager {
        address addr;
        uint[] conso;
        uint[] prod;
        uint[] disponible;

        string nom;
        uint credit;
        uint achatEDF;
        uint venteEDF;
        uint temps;
    }

    Usager anusager;

    /*  Initialisation */
    function Daisee() {
        currentTime = 0;
    }


    function () {
        bool trouve=false;

        for (uint i = 0; i < usagers.length; ++i) {
            if(usagers[i].addr == msg.sender){
                usagers[i].credit = usagers[i].credit + msg.value;
                trouve=true;
            }
        }
        if(trouve){

        }else {
            throw;
        }

    }

    function sajouterUsager(
        string name
        ) {
        Usager nouvelUsager = anusager;
        nouvelUsager.nom = name;
        nouvelUsager.credit = msg.value;
        nouvelUsager.addr = msg.sender;


        usagers[usagers.length++] = nouvelUsager;

        // {addr: msg.sender, credit: msg.value, nom: name, conso:[0], prod: [0], disponible:[0]}
        for (uint i = 0; i < currentTime; ++i) {
            usagers[usagers.length].conso[i]=0;
            usagers[usagers.length].prod[i]=0;
            usagers[usagers.length].disponible[i]=0;
        }
        usagers[usagers.length].temps=currentTime-1;
        usagers[usagers.length].achatEDF=0;
        usagers[usagers.length].venteEDF=0;
    }

    function publier(uint consoActuelle, uint prodActuelle) {
        uint prodDiff = prodActuelle - consoActuelle;
        // address vendeut - ça devrait être un mapping
        for (uint i = 0; i < usagers.length; ++i) {
            if(usagers[i].addr == msg.sender){
                usagers[i].conso[currentTime] = consoActuelle;
                usagers[i].prod[currentTime] = prodActuelle;
                usagers[i].temps = currentTime;
            }
        }
    }

    function nextTime() {
        uint dispoTot=0;
        uint desireeTot=0;

        for (uint i = 0; i < usagers.length; ++i) {
            if(usagers[i].temps == currentTime){
                if(usagers[i].prod[currentTime]>usagers[i].conso[currentTime]){
                    dispoTot+=usagers[i].prod[currentTime]-usagers[i].conso[currentTime];
                }
                else{
                    desireeTot+=usagers[i].conso[currentTime]-usagers[i].prod[currentTime];
                }
            }
        }

        if(desireeTot>dispoTot){ // Deficit
            uint pourmille = 1000*dispoTot/desireeTot;

            for (uint j = 0; j < usagers.length; ++j) {
                if(usagers[j].temps == currentTime){
                    // Surplus prod personelle en temps de deficit
                    if(usagers[j].conso[currentTime]<=usagers[j].prod[currentTime]){
                    }
                    // Deficit prod personelle en temps de deficit
                    else {
                        usagers[j].credit+=(usagers[j].prod[currentTime]-usagers[j].conso[currentTime])*pourmille/1000;
                        usagers[j].achatEDF-=(usagers[j].prod[currentTime]-usagers[j].conso[currentTime])*(1000-pourmille)/1000;
                    }
                }
            }
        }
        else {
        // Surplus
            uint pourmille2 = 1000*desireeTot/dispoTot;

            for (uint k = 0; k < usagers.length; ++i) {
                if(usagers[k].temps == currentTime){
                    // Deficit prod personelle en temps de surplus
                    if(usagers[k].prod[currentTime]<=usagers[k].conso[currentTime]){
                        usagers[k].credit+=usagers[k].prod[currentTime]-usagers[k].conso[currentTime];
                    }
                    // Surplus prod personelle en temps de surplus
                    else {
                        usagers[k].credit+=(usagers[k].prod[currentTime]-usagers[k].conso[currentTime])*pourmille2/1000;
                        usagers[k].venteEDF+=(usagers[k].prod[currentTime]-usagers[k].conso[currentTime])*(1000-pourmille2)/1000;
                    }
                }
            }

        }

        currentTime++;
    }

}
