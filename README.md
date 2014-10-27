Cluedo
=================
Un jeu familial (avec des morts)
-----------------

# Qu'est ce que c'est quoi
Ceci est une version actualisée du classique jeu de société "Cluedo",
inspiré par la série "Sherlock". Sa particularité est d'être joué en utilisant
des smartphones a la place des vieux papier et crayons

# Installation
Avant de commencer a jouer, il faut d'abord découper toutes les petites pièces.
Cela se fait simplement grace aux commandes `npm install` et `bower install`,
qui vont installer toutes les dépendances. Il suffit ensuite d'exécuter la
commande `gulp build` pour tout compiler.

Une fois la compilation terminée, il faut installer le plateau.
Executez la commande `npm start` pour démarrer le serveur, et ouvrez la page
[http://localhost:3000/plateau](http://localhost:3000/plateau) dans votre
navigateur. Vous devriez voir apparaitre une fenetre avec un QR-Code et la
liste (vide) des équipes connectés.

Le QR-Code devrait normalement pointer vers
[http://(votre-ip):3000/](http://(votre-ip):3000/). Toutefois la détéction de
l'IP marche chez moi mais ne marchera peut être pas chez vous. Si l'IP n'est pas
valide, ouvrez un terminal et executez la commande `ipconfig` (Windows) ou
`ifconfig` (Unix) pour connaitre votre vraie IP.

L'adresse fournie par le QR-Code (ou que vous avez trouvée tout seul comme un
grand) est a ouvrir sur tous les téléphones participants au jeu. Ceux ci
devraient voir apparaitre le nom de leur équipe. Une fois toutes les équipes
connectées, cliquez sur le gros bouton "Commencer" sur le plateau pour ...
commencer.
