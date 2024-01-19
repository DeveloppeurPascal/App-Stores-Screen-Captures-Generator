# 20240119 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* updated dependencies (sub module)
* finalisation de l'écran de démarrage (menu)
* mise en place de l'écran de gestion des projets sous forme de classeur à onglets
* modification du fichier du projet pour prendre en charge les magasins actifs dessus
* ajout de la liste des ID des magasins pris en charge par le projet dans sa structure
* modification du stockage des langues
* modification du stockage des bitmaps avec ajout des langues et des magasins sur lesquels elle doit être générée

--

Fin de stream sur un freeze de l'IDE sans sauvegarde des modifications en cours au niveau de TASSCGBitmap, TASSCGLanguages (remplaçant TASSCGLanguageList) et l'ajout du "Project" dans la liste des magasins.

Une récupération post stream du fichier dans ./_restored a permi de ne perdre que la partie TBitmap des modifications du jour. Elles seront resaisies avant le stream suivant.
