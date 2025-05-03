# DartDéj

**DartDéj est un outil en ligne de commande écrit en Dart pour automatiser la gestion de la rotation du petit‑déjeuner au sein d’une équipe. Il gère :**

- La liste circulaire des agents  
- Les jours fériés et événements exceptionnels  
- Les indisponibilités déclarées (J–2 minimum)  
- L’envoi de rappels à J–2 et J–1  
- La création d'une groupe/équipe indépendants  

---

## 🚀 Fonctionnalités clés

- **Initialisation & gestion des agents** 
  - Ajouter, modifier ou supprimer des agents  
  - Authentification par rôle (Agent / Admin)  
- **Configuration** des rotations  
  - Choix d’un jour fixe par semaine (Vendredi par défaut)  
  - Import ou saisie des jours fériés et événements exceptionnels  
  - Multi‑groupes (équipes séparées avec leur propre calendrier)  
- **Planification & visualisation**  
  - Calcul dynamique des 4 prochains tours, en tenant compte :  
    - des jours fériés (fixes et dynamiques)  
    - des indisponibilités déclarées  
  - Affichage clair en console  
- **Gestion des indisponibilités**  
  - Déclaration par l’agent (au moins 2 jours à l’avance)  
  - Substitution automatique et enregistrement dans l’historique  
- **Rappels & notifications**  
  - Simulation d’envoi d’email/SMS à J–2 et J–1 via un service interne  
  - Option d’audit (journalisation) des rappels envoyés  

---

## 📦 Installation

1. **Cloner le dépôt**  
   ```bash
   git clone https://github.com/djibrilmaiga/dartDej.git
   cd dartDej

