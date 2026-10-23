# Edge Functions

Les fonctions serveur devront vérifier le JWT et l’identité, contrôler les permissions, écrire les événements d’audit côté serveur et exiger une approbation valide avant toute action à risque. Elles doivent renvoyer des erreurs structurées et ne jamais annoncer un succès en cas d’échec.

Aucune fonction d’exécution autonome n’est livrée dans cette fondation. Vérifier le schéma dans un projet Supabase de développement avant déploiement.
