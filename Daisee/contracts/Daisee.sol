contract Daisee {

    Usager[] public usagers;
    uint public currentTime;
    uint prixKwh;

    /* Usagers */
    struct Usager {
        address addr;
        uint[] conso;
        uint[] prod;

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

    function sajouterUsager(string name) {
        Usager nouvelUsager = anusager;
        nouvelUsager.nom = name;
        nouvelUsager.credit = msg.value;
        nouvelUsager.addr = msg.sender;

        usagers[usagers.length++] = nouvelUsager;

        // {addr: msg.sender, credit: msg.value, nom: name, conso:[0], prod: [0], disponible:[0]}
        for (uint i = 0; i < currentTime; ++i) {
            usagers[usagers.length].conso[i]=0;
            usagers[usagers.length].prod[i]=0;
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
            unit pourmille = 1000*dispoTot/desireeTot;

            for (uint i = 0; i < usagers.length; ++i) {
                if(usagers[i].temps == currentTime){
                    // Surplus prod personelle en temps de deficit
                    if(usagers[i].conso[currentTime]<=usagers[i].prod[currentTime]){
                        usagers[i].credit+=usagers[i].prod[currentTime]-usagers[i].conso[currentTime];
                    }
                    // Deficit prod personelle en temps de deficit
                    else {
                        usagers[i].credit+=(usagers[i].prod[currentTime]-usagers[i].conso[currentTime])*pourmille/1000;
                        usagers[i].achatEDF-=(usagers[i].prod[currentTime]-usagers[i].conso[currentTime])*(1000-pourmille)/1000;
                    }
                }
            }
        }
        else {
        // Surplus
            unit pourmille = 1000*desireeTot/dispoTot;

            for (uint i = 0; i < usagers.length; ++i) {
                if(usagers[i].temps == currentTime){
                    // Deficit prod personelle en temps de surplus
                    if(usagers[i].prod[currentTime]<=usagers[i].conso[currentTime]){
                        usagers[i].credit+=usagers[i].prod[currentTime]-usagers[i].conso[currentTime];
                    }
                    // Surplus prod personelle en temps de surplus
                    else {
                        usagers[i].credit+=(usagers[i].prod[currentTime]-usagers[i].conso[currentTime])*pourmille/1000;
                        usagers[i].venteEDF+=(usagers[i].prod[currentTime]-usagers[i].conso[currentTime])*(1000-pourmille)/1000;
                    }
                }
            }
        }
        currentTime++;
    }
}
