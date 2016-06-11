contract Daisee {
  // temps artificiel - pour chaque cycle le temps artificiel est augmenté
  uint public currentTime;
  uint usagers;

  address []addr;

  // consomation et production en kwh
  uint []conso;
  uint []prod;

  string []nom;
  // somme des unités vendues ou achetés entre la communauté
  uint []credit;
  // somme des unités achetés et vendue de l'EDF
  uint []achatEDF;
  uint []venteEDF;
  // temps artificiel des dernier données d'un usager
  uint []temps;

  /*  Initialisation */
  function Daisee() {
      currentTime = 0;
      usagers=0;
  }


  function sajouterUsager(string name) {
      credit.length++;
	  credit[usagers] = 0;
	  addr.length++;
      addr[usagers] = msg.sender;

      // initialiser le nouvel usager

	  nom.length++;
	  nom[usagers]=name;
	  credit.length++;
	  credit[usagers]=0;

      // le nouvel usager n'a pas encore livré des données pour le cycle actuel -> currentTime
	  temps.length++;
      temps[usagers]=currentTime-1;
      // la facture EDF est zero
	  achatEDF.length++;
	  venteEDF.length++;
	  achatEDF[usagers]=0;
	  venteEDF[usagers]=0;
	  usagers++;
  }

     // function qui met les données d'un usager - à utiliser à partir des rasberries
     function publier(uint consoActuelle, uint prodActuelle) {
         uint prodDiff = prodActuelle - consoActuelle;
         // address vendeut - ça devrait être un mapping
         for (uint i = 0; i < usagers; ++i) {
             if(addr[i] == msg.sender){
                 conso[i] = consoActuelle;
                 prod[i] = prodActuelle;
                 temps[i] = currentTime;
             }
         }
     }

     // function qui fait le calcul pour un cycle
     function nextTime() {
         // calculer les chiffres totals. Est-ce qu'il y a trop d'energie ou un manque d'energie?
         uint dispoTot=0;
         uint desireeTot=0;

         // Un loop sur tous les usagers qui ont participer au cycle actuel pour calculer le total
         for (uint i = 0; i < usagers; ++i) {
             if(temps[i] == currentTime)
             {
			 	if(prod[i]>conso[i]){
                   dispoTot+=prod[i]-conso[i];
               }
               else{
                   desireeTot+=conso[i]-prod[i];
               }
             }
         }

		uint pourmille;
        if(desireeTot>dispoTot){ // Deficit
            pourmille = 1000*dispoTot/desireeTot;

            for (uint j = 0; j < usagers; ++j) {
                if(temps[j] == currentTime){
                    // Surplus prod personelle en temps de deficit
                    if(conso[j]<=prod[j]){
						credit[j]+=prod[j]-conso[j];
                    }
                    // Deficit prod personelle en temps de deficit
                    else {
                        credit[j]+=(prod[j]-conso[j])*pourmille/1000;
                        achatEDF[j]-=(prod[j]-conso[j])*(1000-pourmille)/1000;
                    }
                }
            }
        }

        else {
        // Surplus
            pourmille = 1000*desireeTot/dispoTot;

            for (uint k = 0; k < usagers; ++i) {
                if(temps[k] == currentTime){
                    // Deficit prod personelle en temps de surplus
                    if(prod[k]<=conso[k]){
                        credit[k]+=prod[k]-conso[k];
                    }
                    // Surplus prod personelle en temps de surplus
                    else {
                        credit[k]+=(prod[k]-conso[k])*pourmille/1000;
                        venteEDF[k]+=(prod[k]-conso[k])*(1000-pourmille)/1000;
                    }
                }
            }

        }

        currentTime++;
      }

}
