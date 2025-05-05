/*alogithme pour Calculer des 4 prochains tours à partir de la date actuelle
les classes concernées: Rotation, TourDePassage et Calendrier
#on part du principe que la liste des agents est définis
#on instancie un premier objet tour avec un agents
TourDePassage tour1 = TourDePassage(...,...)
#on l'ajoute à la liste des tours dans la table Rotation
Dans le cas ou la liste des tours dans la table Rotation est déjà remplie, 
Je recupère le dernier tour de la liste puis le champs "datePrevue"
int i = 1;
while(i inferieur à 4)
{ 
    #je verifie si cette date ne se trouve pas dans la liste des jours fériés ou 
    evenement de la compagnie
    if(date in Calendrier.joursFeriers or Calendrier.eventCompany){
        date = date + 7 //on fait un decalage de deux semaine
        i--;
    }
    else
    {
        date = date + 7;
        i++;
        print(date);
    }
}*/
import 'agent.dart';
import 'tourdepassage.dart';
class Rotation{
Agent? agentCourant;
int? nombreCycle;
List<TourDePassage>? tour;
}